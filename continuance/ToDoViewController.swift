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
}

extension ToDoViewController: UITableViewDelegate,UITableViewDataSource {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = ToDoTableViewCell(style: .Default, reuseIdentifier: "TaskCell")
    if let _ = toDoList {
      
      cell.textLabel?.text = toDoList![indexPath.row].text
      
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
    
    let doneAction =
      UITableViewRowAction(style: .Normal, title: "完了"){(action, indexPath) in
        print("\(indexPath) done")
      }
    
    doneAction.backgroundColor = UIColor.greenColor()
    
    
    let deleteAction =
      UITableViewRowAction(style: .Default, title: "削除"){(action, indexPath) in
        print("\(indexPath) deleted")
      }
    deleteAction.backgroundColor = UIColor.redColor()
    
    return [doneAction, deleteAction]
    
  }
  
}
