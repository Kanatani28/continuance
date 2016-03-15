//
//  ToDoTableViewCell.swift
//  continuance
//
//  Created by sk on 2016/02/28.
//  Copyright © 2016年 shin-kawani. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

@objc protocol ToDoTableViewCellDelegate {
  optional func didChangeTask()
}

class ToDoTableViewCell: UITableViewCell {
  
  var label:UITextField!
  var delegate:AnyObject?
  var parentTableView:UITableView?
  var initialContentOffsetY:CGFloat!
  var txtFildHeight:CGFloat!
  
  var _task:Task!
  var task:Task
    {
    get {
      return _task
    }
    set (task){
      _task = task
      label!.text = task.text
      
      
      label.textColor = UIColor.blackColor()
      label.attributedText = NSAttributedString(string: task.text, attributes: [NSStrikethroughStyleAttributeName:0])
      if (task.isDone == true) {
        
        label.attributedText = NSAttributedString(string: task.text, attributes: [NSStrikethroughStyleAttributeName:1])
        label.textColor = UIColor.grayColor()
        
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder:aDecoder)!
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    label = UITextField(frame: CGRect.null)
    label.textColor = UIColor.blackColor()
    label.font = UIFont.systemFontOfSize(19.0)
    
    label.returnKeyType = UIReturnKeyType.Done
    
    label.delegate = self
    label.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
    
    print("called init!!!")
    
    addSubview(label)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
//    let notificationCenter = NSNotificationCenter.defaultCenter()
//    notificationCenter.addObserver(self, selector: "keyboardShowHandler:", name: UIKeyboardWillShowNotification, object: nil)
//    notificationCenter.addObserver(self, selector: "keyboardHideHandler:", name: UIKeyboardWillHideNotification, object: nil)
    
    label.frame = CGRect(x: 15.0, y: 0, width: bounds.size.width, height: bounds.size.height)
    
  }
  
  
  
  func keyboardShowHandler(notification:NSNotification) {
    
    let userInfo = notification.userInfo!
    let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    let myBoundSize: CGSize = UIScreen.mainScreen().bounds.size
    let txtLimit = txtFildHeight
    let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
    
    print("テキストフィールドの下辺：(\(txtLimit))")
    print("キーボードの上辺：(\(kbdLimit))")
    
    if txtLimit >= kbdLimit {
      //parentTableView?.contentOffset.y = kbdLimit
      parentTableView?.setContentOffset(CGPoint(x: (parentTableView?.contentOffset.x)!, y: txtLimit - kbdLimit), animated: true)
    }
  }
  
  func keyboardHideHandler(notification: NSNotification) {
    if let _ = initialContentOffsetY {
      parentTableView?.contentOffset.y = 0
      
    }
  }
  
}

extension ToDoTableViewCell:UITextFieldDelegate  {
  
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    txtFildHeight = self.frame.origin.y + self.frame.height + 8.0
    initialContentOffsetY = parentTableView?.contentOffset.y
    print("called!!!---------------- (\(txtFildHeight))")
    print("called!!!---------------- (\(parentTableView?.contentOffset.y))")
    return true
  }
  
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    label.resignFirstResponder()
    return true
  }
  
  func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    
    _task.text = label.text!
    
    if (_task.shouldRegister == true) {
      
      ToDoViewController.Api.registration(task).doWithCompletionHandler({(request, response, json, error) in })
      
    } else {
      
      ToDoViewController.Api.update(task).doWithCompletionHandler({(request, response, json, error) in })
      
    }
    
    return true
  }
}
