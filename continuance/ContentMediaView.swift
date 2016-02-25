//
//  ContentMediaView.swift
//  continuance
//
//  Created by shin.kawani on 2/21/16.
//  Copyright © 2016 shin-kawani. All rights reserved.
//

import UIKit

class ContentMediaView: UIView {

  @IBOutlet var contentMedia: UIView!
  @IBOutlet weak var mediaImage: UIImageView!

  required init(coder aDecoder:NSCoder) {
    super.init(coder: aDecoder)!
    sharedInit()
  }

  override init(frame:CGRect) {
    super.init(frame:frame)
    sharedInit()
  }

  private func sharedInit() {

    NSBundle.mainBundle().loadNibNamed("ContentMediaView", owner: self, options: nil)
    addSubview(contentMedia)
  }

  // MARK: - Constraints
  private func setupConstraints() {

    let topConstraint = NSLayoutConstraint(item: contentMedia, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0)

    let leftConstraint = NSLayoutConstraint(item: contentMedia, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1.0, constant: 0.0)

    let rightConstraint = NSLayoutConstraint(item: contentMedia, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: 0.0)

    let constraints = [topConstraint, /*bottomConstraint,*/ leftConstraint, rightConstraint]

    //contentMedia.translatesAutoresizingMaskIntoConstraints = false
    addConstraints(constraints)
  }

}
