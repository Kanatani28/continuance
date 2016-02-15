//
//  RippleTransitionViewController.swift
//  continuance
//
//  Created by shin.kawani on 2/5/16.
//  Copyright © 2016 shin-kawani. All rights reserved.
//

import UIKit

class RippleTransitionViewController: UIViewController {

  @IBOutlet weak var rippleButton: UIButton!
  var tapPoint:CGPoint?


  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  @IBAction func tappedRippleButton(sender: AnyObject) {
    //self.performSegueWithIdentifier("toNextFromButton", sender: self)
  }

  @IBAction func returnFromSecondView(sender: UIStoryboardSegue) {
  }


  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    tapPoint = sender?.center
    if let s = segue as? RippleCustomSegue {
      if let point = self.tapPoint {
        s.tappedPoint = point
      }
    }
  }

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
