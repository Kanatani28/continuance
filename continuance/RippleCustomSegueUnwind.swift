//
//  RippleCustomSegueUnwind.swift
//  continuance
//
//  Created by shin.kawani on 2/5/16.
//  Copyright © 2016 shin-kawani. All rights reserved.
//

import UIKit

class RippleCustomSegueUnwind: UIStoryboardSegue {

  var tappedPoint:CGPoint!

  override func perform() {
    let source = self.sourceViewController as UIViewController!

    source?.navigationController?.popViewControllerAnimated(true)

  }
}
