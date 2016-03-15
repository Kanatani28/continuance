//
//  Task.swift
//  continuance
//
//  Created by sk on 2016/02/27.
//  Copyright © 2016年 shin-kawani. All rights reserved.
//

import UIKit

class Task: NSObject {
  
  var id: Int
  var text: String
  var isDone: Bool
  var shouldRegister:Bool = false
  
  init(id:Int, text:String, isDone:Bool) {
    
    self.id = id
    self.text = text
    self.isDone = isDone
    
  }
  
  func toJSON() -> [String:AnyObject] {
    return [
      "id":id,
      "isDone":isDone,
      "text":text,
    ]
  }
  
}
