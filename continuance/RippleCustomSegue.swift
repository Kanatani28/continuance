//
//  RippleCustomSegue.swift
//  continuance
//
//  Created by shin.kawani on 2/5/16.
//  Copyright © 2016 shin-kawani. All rights reserved.
//

import UIKit

class RippleCustomSegue: UIStoryboardSegue {

  var tapPoint:CGPoint? = nil

  override func perform() {
    let source = self.sourceViewController as UIViewController!
    let destination = self.destinationViewController as UIViewController!

    source?.navigationController?.pushViewController(destination!, animated: true)
  }

}
