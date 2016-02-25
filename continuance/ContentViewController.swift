//
//  ContentViewController.swift
//  continuance
//
//  Created by shin.kawani on 2/18/16.
//  Copyright © 2016 shin-kawani. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

  @IBOutlet weak var contentScrollView: UIScrollView!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var contentView: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()
    contentScrollView.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    customTransitionViewController.updateLayoutIfNeeded()

  }

  override func viewDidLayoutSubviews() {
    scrollView.contentSize = CGSizeMake(view.frame.width, view.frame.height * 5)
  }
}

// MARK: -UIScrollView
extension ContentViewController:UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    customTransitionViewController.updateCatchContentViewFrame()
  }

}

// MARK: -CustomTransitionViewControllerProtocol
extension ContentViewController: CustomTransitionViewControllerProtocol {

  var customTransitionViewController: CustomTransitionViewController {
    return parentViewController as! CustomTransitionViewController
  }

  var scrollView: UIScrollView {
    return contentScrollView
  }
}