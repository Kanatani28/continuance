//
//  ToDoViewController.swift
//  continuance
//
//  Created by sk on 2016/02/26.
//  Copyright © 2016年 shin-kawani. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

class ToDoViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var toDoList:Array<Task>?
  
  enum Api {
    
    case list
    case registration(Task?)
    case update(Task?)
    case delete(Task?)
    
    
    var apiBaseUrl:String {
      return "http://kwnpanda-app.au-syd.mybluemix.net/api/"
    }
    
    func doWithCompletionHandler(completionHandler:((NSURLRequest, NSHTTPURLResponse?, JSON, ErrorType?)->Void)!) {
    
      switch self {
      case .list:
        
        Alamofire.request(.GET, apiBaseUrl + "Items"
          , parameters: nil
          , encoding:.JSON).responseSwiftyJSON(completionHandler)
        
      case .registration(let task?):
        
        let parameter = task.toJSON()
        Alamofire.request(.POST, apiBaseUrl + "Items"
          , parameters: parameter
          , encoding:.JSON).responseSwiftyJSON(completionHandler)
        
      case .update(let task?):
      
        let parameter = task.toJSON()
        Alamofire.request(.PUT, apiBaseUrl + "Items/" + task.id.description
          , parameters: parameter
          , encoding:.JSON).responseSwiftyJSON(completionHandler)
        
      case .delete: break
      default:
        break
      }
    }
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.tableHeaderView?.hidden = true
    tableView.allowsSelection = false
    tableView.rowHeight = 60.0
    
    
    toDoList = Array()
    
    Alamofire.request(.GET, "http://kwnpanda-app.au-syd.mybluemix.net/api/Items"
      , parameters: nil
      , encoding:.JSON).responseSwiftyJSON({(request, response, json, error) in
        for var i = 0; i < json.count; i++ {
          let todo = json[i]
        
          let task = Task(id: todo["id"].int!
            , text: todo["text"].string!
            , isDone: todo["isDone"].bool!)
          self.toDoList?.append(task)
        }
        
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation:UITableViewRowAnimation.Fade)
        
      })
  }

  override func didReceiveMemoryWarning() {
    
    super.didReceiveMemoryWarning()
    
  }
  
  func addToDoItem() {
    
    var id = 1
    if let count = toDoList?.count {
      id = count + 1
    }
    
    let task = Task(id: id, text: "", isDone: false)
    task.shouldRegister = true
    
    toDoList?.append(task)
    
    tableView.frame.size.height = tableView.frame.size.height + 60.0
    
    let indexPath = NSIndexPath(forRow: id - 1 , inSection: 0)
    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Bottom)
    
    // セルを足したりしてもう一度レイアウト(AutoLayout)しなきゃいけないのでこれをやる
    // もしやらない場合はスクロール領域が変更されず最後までスクロールできないままになる
    tableView.layoutIfNeeded()
    
    tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    
    let cell = tableView.cellForRowAtIndexPath(indexPath) as? ToDoTableViewCell
    
    cell?.label.becomeFirstResponder()
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
}

extension ToDoViewController: UITableViewDelegate,UITableViewDataSource {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = ToDoTableViewCell(style: .Default, reuseIdentifier: "TaskCell")
    cell.parentTableView = self.tableView
    if let _ = toDoList {
      
      cell.task = toDoList![indexPath.row]
      
    }
      
    return cell
    
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if let _ = toDoList {
      
      return toDoList!.count
      
    } else {
      
      return 0
      
    }
    
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    
    let task = self.toDoList?[indexPath.row]
    
    var title = "完了"
    if (task?.isDone == true) {
      title = "未完"
    }
    
    
    let doneAction =
      UITableViewRowAction(style: .Normal, title: title){(action, indexPath) in
        task?.isDone = !(task?.isDone)!
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? ToDoTableViewCell
        cell?.task = task!
        
        Api.update(task).doWithCompletionHandler({(request, response, json, error) in })
        
        self.tableView.setEditing(false, animated:true)

      }
    
    if (task?.isDone == true) {
      
      doneAction.backgroundColor = UIColor.grayColor()
      
    } else {
      
      doneAction.backgroundColor = UIColor.greenColor()
      
    }
    
    // Blumix MobileAccessClientSDK を用意しないとAPIでアクセスできない。
    // 2016/02/29時点では用意してないのでiOSで削除してもバックエンド側からは削除されない
    let deleteAction =
      UITableViewRowAction(style: .Default, title: "削除"){(action, indexPath) in
        
        self.toDoList?.removeAtIndex(indexPath.row)
        self.tableView.setEditing(false, animated:true)
        
        //self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation:UITableViewRowAnimation.Fade)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        
      }
    
    deleteAction.backgroundColor = UIColor.redColor()
    
    return [doneAction, deleteAction]
    
  }
  
}
