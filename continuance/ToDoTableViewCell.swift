//
//  ToDoTableViewCell.swift
//  continuance
//
//  Created by sk on 2016/02/28.
//  Copyright © 2016年 shin-kawani. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell, UITextFieldDelegate {
  
  var label:UITextField!
  var task:Task
    {
    get {
      return self.task
    }
    set (task){
      label!.text = task.text
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
    
    label = UITextField(frame: CGRect.null)
    label.textColor = UIColor.blackColor()
    label.font = UIFont.systemFontOfSize(19.0)
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    label.delegate = self
    label.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
    
    addSubview(label)
  }


}
