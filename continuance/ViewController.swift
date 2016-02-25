//
//  ViewController.swift
//  continuance
//
//  Created by shin.kawani on 2/5/16.
//  Copyright © 2016 shin-kawani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var contentsTableView: UITableView!

  private var contents = ["CustomSegue with RippleAnimation", "AsynchroScroll"]

  enum demos : Int {

    case CustomSegue
    case AsynchroScroll

    func toStoryboardName()->String {
      switch (self) {
      case .CustomSegue:
        return "RippleTransitionStoryboard"
      case .AsynchroScroll:
        return "ContentMainStoryboard"
      }
    }

    func toViewControllerName()->String {
      switch (self) {
      case .CustomSegue:
        return "RippleTransition"
      case .AsynchroScroll:
        return "ContentMain"
      }
    }

  }

  override func viewDidLoad() {
    super.viewDidLoad()

    contentsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "contentCell")

    contentsTableView.dataSource = self
    contentsTableView.delegate = self

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }


  // MARK: - UITableViewDelegate
  // セルが選択された時
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    contentsTableView.deselectRowAtIndexPath(indexPath, animated: true)
    print("Num: \(indexPath.row)")
    print("Value: \(contents[indexPath.row])")

    let storyboardName = demos.init(rawValue: indexPath.row)?.toStoryboardName()
    let viewControllerName = demos.init(rawValue: indexPath.row)?.toViewControllerName()

    let storyboard:UIStoryboard = UIStoryboard(name:storyboardName!, bundle: nil)
    let viewController:UIViewController = storyboard.instantiateViewControllerWithIdentifier(viewControllerName!)
    self.navigationController?.pushViewController(viewController, animated: true)

  }

  // MARK: - UITableViewDataSource

  // セルの数を返す
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contents.count
  }

  // セルの値設定
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    // 再利用するCellを取得する.
    let cell = tableView.dequeueReusableCellWithIdentifier("contentCell", forIndexPath: indexPath)

    cell.textLabel!.text = "\(contents[indexPath.row])"
    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

    cell.setNeedsLayout()


    return cell
  }

}

