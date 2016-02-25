//
//  catchContentViewController.swift
//  continuance
//
//  Created by shin.kawani on 2/18/16.
//  Copyright © 2016 shin-kawani. All rights reserved.
//

import UIKit

@objc protocol CatchContentViewControllDelegate {
  optional func backScreen()
}

class CatchContentViewController: UIView {

  var currentIndex:Int = 0

  var delegate:AnyObject? = nil

  // 親ビューのスクロール検知用
  var scrollDidChangeBlock:((scroll:CGFloat, shouldScroll:Bool)->Void)?

  @IBOutlet weak var catchContentView: UIView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var menuView: UIView!
  @IBOutlet weak var containerView: UIView!

  @IBOutlet weak var backButton: UIButton!
  required init(coder aDecoder:NSCoder) {
    super.init(coder: aDecoder)!
    sharedInit()

  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    sharedInit()
  }

  private func sharedInit() {
    NSBundle.mainBundle().loadNibNamed("CatchContentViewController", owner: self, options: nil)
    addSubview(catchContentView)

    setupConstraints()

    scrollView.delegate = self
    scrollView.scrollsToTop = false
  }

  @IBAction func pressedBackButton(sender: AnyObject) {
    self.delegate?.backScreen!()
  }
}

// MARK: -UIScrollViewDelegate
extension CatchContentViewController:UIScrollViewDelegate {

  private func setupConstraints() {
    let topConstraint = NSLayoutConstraint(item: catchContentView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0)

    let bottomConstraint = NSLayoutConstraint(item: catchContentView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)

    let leftConstraint = NSLayoutConstraint(item: catchContentView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0.0)

    let rightConstraint = NSLayoutConstraint(item: catchContentView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: 0.0)

    let constraints = [topConstraint, bottomConstraint, leftConstraint, rightConstraint]

    // translatesAutoresizingMaskIntoConstraintsの説明は
    // http://blogios.stack3.net/archives/54

    catchContentView.translatesAutoresizingMaskIntoConstraints = false
    addConstraints(constraints)
  }

}
