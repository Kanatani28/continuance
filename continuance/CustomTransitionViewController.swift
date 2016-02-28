//
//  CustomTransitionViewController.swift
//  continuance
//
//  Created by shin.kawani on 2/16/16.
//  Copyright © 2016 shin-kawani. All rights reserved.
//

import UIKit
import Alamofire

protocol CustomTransitionViewControllerProtocol {
    var customTransitionViewController: CustomTransitionViewController { get } // getterの実装を要求している
    var scrollView: UIScrollView { get } // getterの実装を要求している
}


class CustomTransitionViewController: UIPageViewController {

  private let contentViewHeihgt: CGFloat = 280.0
  private let scrollViewHeight: CGFloat = 44.0
  private var contentViewControllers: [UIViewController] = []
  private var catchContentView:CatchContentViewController!

  private var shouldScrollFrame:Bool = true
  private var shouldUpdateLayout: Bool = false

  private var updateIndex: Int = 0

  private var scrollContentOffsetY: CGFloat = 0.0

  private var currentIndex: Int? {
    guard let viewController = viewControllers?.first, index = contentViewControllers.indexOf(viewController) else {
      return nil
    }
    return index
    
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    contentViewControllers = createContentViews()
    setupContentViewController()
    setupCatchContentView()
    self.navigationController?.navigationBarHidden = true
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func viewDidLayoutSubviews() {
    setupContentInset()
    let vc = contentViewControllers[currentIndex!] as! ContentViewController
    vc.scrollView.contentSize = CGSizeMake(vc.scrollView.frame.width, vc.scrollView.frame.height * 5)

  }

}


// MARK: - Setup inner views
extension CustomTransitionViewController {

  func createContentViews() -> [UIViewController] {

    let viewController = UIStoryboard(name: "ContentStoryboard", bundle: nil).instantiateViewControllerWithIdentifier("ContentView")

    return [viewController]

  }

  func setupContentViewController() {
    dataSource = self
    delegate = self
    setViewControllers(
      self.contentViewControllers
      , direction: .Forward
      , animated: false
      , completion: {[weak self] (completed:Bool) in
        self?.setupContentInset()
      })
  }

  func setupCatchContentView() {
    catchContentView = CatchContentViewController(frame:CGRectMake(0.0, 0.0, view.frame.width, contentViewHeihgt))
    catchContentView?.scrollDidChangeBlock = {[weak self] (scroll:CGFloat, shouldScroll:Bool) in
      self?.shouldScrollFrame = shouldScroll
      self?.updateContentOffsetY(scroll)
    }

    catchContentView?.delegate = self

    view.addSubview(catchContentView!)
  }

}

extension CustomTransitionViewController {


  private func setupContentInset() {
    guard let currentIndex = currentIndex, vc = contentViewControllers[currentIndex] as? CustomTransitionViewControllerProtocol
    else {
      return
    }
    let inset = UIEdgeInsetsMake(contentViewHeihgt, 0.0, 0.0, 0.0)
    vc.scrollView.contentInset = inset
    vc.scrollView.scrollIndicatorInsets = inset
  }

  private func setupContentOffsetY(index: Int, scroll: CGFloat) {
    guard let  vc = contentViewControllers[index] as? CustomTransitionViewControllerProtocol else {
      return
    }

    if scroll == 0.0 {
      vc.scrollView.contentOffset.y = -contentViewHeihgt
    } else if (scroll < contentViewHeihgt - scrollViewHeight) || (vc.scrollView.contentOffset.y <= -scrollViewHeight) {
      vc.scrollView.contentOffset.y = scroll - contentViewHeihgt
    }
  }

  private func updateContentOffsetY(scroll: CGFloat) {
    if let currentIndex = currentIndex, vc = contentViewControllers[currentIndex] as? CustomTransitionViewControllerProtocol {
      vc.scrollView.contentOffset.y += scroll
    }
  }

  func updateLayoutIfNeeded() {
    if shouldUpdateLayout {
      let vc = contentViewControllers[updateIndex] as? CustomTransitionViewControllerProtocol
      let shouldSetupContentOffsetY = vc?.scrollView.contentInset.top != contentViewHeihgt

      let scroll = scrollContentOffsetY
      setupContentInset()
      setupContentOffsetY(updateIndex, scroll: -scroll)
      shouldUpdateLayout = shouldSetupContentOffsetY
    }
  }

  func updateCatchContentViewFrame() {
    guard let currentIndex = currentIndex, vc = contentViewControllers[currentIndex] as? CustomTransitionViewControllerProtocol
    else {
      return
    }



//    if (vc.scrollView.contentOffset.y > -scrollViewHeight) { // ヘッダを固定
//
//      let scroll = contentViewHeihgt - scrollViewHeight
//      updateContentView(-scroll)
//      vc.scrollView.scrollIndicatorInsets.top = scrollViewHeight
//
//    }

    var scroll = contentViewHeihgt + vc.scrollView.contentOffset.y

    if (vc.scrollView.contentOffset.y >= -contentViewHeihgt) {
      scroll = scroll / 2
    }

    updateContentView(-scroll)
    vc.scrollView.scrollIndicatorInsets.top = -vc.scrollView.contentOffset.y

  }

  private func updateContentView(scroll: CGFloat) {
    if shouldScrollFrame {
      if let _ = catchContentView {
        catchContentView.frame.origin.y = scroll
      }
      scrollContentOffsetY = scroll
    }
    shouldScrollFrame = true
  }

}

// MARK: - UIPageViewControllerDataSource

extension CustomTransitionViewController:UIPageViewControllerDataSource {

  // 順送りにページ送りした時に呼ばれる
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {

    guard var index = contentViewControllers.indexOf(viewController) else {
        return nil
    }

    index++

    if index >= 0 && index < contentViewControllers.count {
        return contentViewControllers[index]
    }
    return nil
  }

  // 逆送りにページ送りした時に呼ばれる
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

    guard var index = contentViewControllers.indexOf(viewController) else {
      return nil
    }

    index--

    if index >= 0 && index < contentViewControllers.count {
      return contentViewControllers[index]
    }
    return nil
  }

}

// MARK: - UIPageViewControllerDelegate

extension CustomTransitionViewController: UIPageViewControllerDelegate {

  func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
//    if let vc = pendingViewControllers.first, index = pageViewControllers.indexOf(vc) {
//      shouldUpdateLayout = true
//      updateIndex = index
//    }

  }

  func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//    guard let _ = previousViewControllers.first, currentIndex = currentIndex else {
//      return
//    }

//    if shouldUpdateLayout {
//      setupContentInset()
//      setupContentOffsetY(currentIndex, scroll: -scrollContentOffsetY)
//    }
//
//    if currentIndex >= 0 && currentIndex < contentsView.tabButtons.count {
//      contentsView.updateCurrentIndex(currentIndex, animated: false)
//    }
  }
}

// MARK: -CatchContentViewControllDelegate
extension CustomTransitionViewController:CatchContentViewControllDelegate {
  func backScreen() {
    self.navigationController?.navigationBarHidden = false
    self.navigationController?.popViewControllerAnimated(true)
  }
}
