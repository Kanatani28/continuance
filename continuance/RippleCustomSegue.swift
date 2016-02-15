//
//  RippleCustomSegue.swift
//  continuance
//
//  Created by shin.kawani on 2/5/16.
//  Copyright © 2016 shin-kawani. All rights reserved.
//
  //let window = UIApplication.sharedApplication().keyWindow
  //window?.insertSubview(destination.view, aboveSubview: source.view)
  //source?.presentViewController(destination, animated: true, completion: nil)

import UIKit

class RippleCustomSegue: UIStoryboardSegue, RippleAnimationDelegate {

  var tappedPoint:CGPoint!

  override func perform() {
    let source = self.sourceViewController as UIViewController!
    let destination = self.destinationViewController as UIViewController!

    let rippleAnimation = RippleAnimation(
      tappedPoint: tappedPoint!
      , duration: 0.25
      , shouldSpread: true
      , source: source.view
      , dest: destination.view
    )

    source?.navigationController?.view.insertSubview(destination.view, aboveSubview: source.view)

    rippleAnimation.delegate = self
    rippleAnimation.animate()


  }

  func animationCompleted() {
    let source = self.sourceViewController as UIViewController!
    let destination = self.destinationViewController as UIViewController!
    source?.navigationController?.pushViewController(destination!, animated: false)
  }

}
