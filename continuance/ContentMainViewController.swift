//
//  ContentMainViewController.swift
//  continuance
//
//  Created by shin.kawani on 2/21/16.
//  Copyright © 2016 shin-kawani. All rights reserved.
//

import UIKit

class ContentMainViewController: UIViewController {

  @IBOutlet weak var mainScrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!

  var contentMediaView:ContentMediaView!
  var mediaFrameHight:CGFloat!

  override func viewDidLoad() {
    super.viewDidLoad()
    mediaFrameHight = (view.frame.width * 3) / 4

    contentMediaView = ContentMediaView(frame: CGRectMake(0.0,0.0, view.frame.width, mediaFrameHight))
    contentMediaView.backgroundColor = UIColor.blackColor()
    mainScrollView.delegate = self
    view.insertSubview(contentMediaView, belowSubview: mainScrollView)

    self.navigationController?.navigationBarHidden = true

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(true)
  }

  override func viewDidLayoutSubviews() {
    let inset = UIEdgeInsetsMake(mediaFrameHight, 0.0, 0.0, 0.0)
    mainScrollView.contentInset = inset
  }

  @IBAction func pressedBackButton(sender: AnyObject) {
    self.navigationController?.popViewControllerAnimated(true)
    self.navigationController?.navigationBarHidden = false
  }
}

// MARK: -UIScrollViewDelegate
extension ContentMainViewController:UIScrollViewDelegate {

  func scrollViewDidScroll(scrollView: UIScrollView) {

    // スクロール量に応じて見出しの画像のフレームを更新
    updateMediaFrame()

  }

  func updateMediaFrame() {

    // 見出しメディアのスクロール両
    var scroll = mediaFrameHight + mainScrollView.contentOffset.y
    if (mainScrollView.contentOffset.y >= -mediaFrameHight) {
      scroll = scroll / 2
    }

    let offsetY = (mainScrollView.contentOffset.y + mainScrollView.contentInset.top) * -1;

    if(mainScrollView.contentOffset.y <= -mediaFrameHight) { // 画像ビヨーン

      let scale = (1.0 + offsetY / mediaFrameHight);
      contentMediaView.transform = CGAffineTransformMakeScale(scale, scale);
      contentMediaView.frame.origin.y = 0.0
      contentMediaView.mediaImage.alpha = 1

    } else {

      contentMediaView.mediaImage.alpha = 1 - (offsetY / mediaFrameHight) * -1
      contentMediaView.frame.origin.y = -scroll

    }

    mainScrollView.scrollIndicatorInsets.top = -mainScrollView.contentOffset.y
  }

}
