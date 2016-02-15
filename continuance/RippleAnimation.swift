//
//  RippleAnimation.swift
//  continuance
//
//  Created by shin.kawani on 2/9/16.
//  Copyright © 2016 shin-kawani. All rights reserved.
//

import UIKit

protocol RippleAnimationDelegate {
  func animationCompleted()
}

class RippleAnimation: NSObject{
  private let tappedPoint: CGPoint!
  private let duration: NSTimeInterval!
  private let shouldSpread: Bool!
  private let source:UIView!
  private let dest:UIView!
  var delegate:RippleAnimationDelegate?

  init(tappedPoint:CGPoint, duration:NSTimeInterval, shouldSpread:Bool, source:UIView, dest:UIView) {
    self.tappedPoint = tappedPoint
    self.duration = duration
    self.shouldSpread = shouldSpread
    self.source = source
    self.dest = dest
  }

  func animate() {

    let radius = { () -> CGFloat in

      //タップされたポイントから画面の端まで遠い方の座標を取る
      let x = max(self.tappedPoint.x, source!.frame.width - self.tappedPoint.x)
      let y = max(self.tappedPoint.y, source!.frame.height - self.tappedPoint.y)

      // タップされたポイントから一番遠い角までの距離を取得(三平方の定理)
      // ここで取得した距離が遠の半径になる
      return sqrt(x * x + y * y)
    }()

    // 円を作るための矩形を作る
    let rectAroundCircle = { (radius: CGFloat) -> CGRect in
        return CGRectInset(CGRect(origin: self.tappedPoint, size: CGSizeZero), -radius, -radius)
    }

    // 始まりと終わりの円のPathを作る
    let startPath = CGPathCreateWithEllipseInRect(rectAroundCircle(0), nil)
    let endPath = CGPathCreateWithEllipseInRect(rectAroundCircle(radius), nil)

    let timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)

    var rippleAnimation:CABasicAnimation
    if (self.shouldSpread!) {

      rippleAnimation = CABasicAnimation(
        keyPath: "path"
        , fromValue: startPath
        , toValue: endPath
        , duration: duration
        , timingFunction: timingFunction)

    } else {

      rippleAnimation = CABasicAnimation(
        keyPath: "path"
        , fromValue: endPath
        , toValue: startPath
        , duration: duration
        , timingFunction: timingFunction)

    }

    let fadein = CABasicAnimation(keyPath: "opacity", fromValue: 0, toValue: 1, duration: duration, timingFunction: timingFunction)

    // 複数のアニメーションを同時に動かすのでCAAnimationGroupを作る
    let animationGroup = CAAnimationGroup()
    animationGroup.setValue("animations", forKey: "animationName")
    animationGroup.animations = [rippleAnimation, fadein]
    animationGroup.removedOnCompletion = false
    animationGroup.fillMode = kCAFillModeForwards
    animationGroup.delegate = self


    if (self.shouldSpread!) {
      dest.layer.mask = CAShapeLayer()
      dest.layer.mask!.addAnimation(animationGroup, forKey: "circular")
    } else {
      source.layer.mask = CAShapeLayer()
      source.layer.mask!.addAnimation(animationGroup, forKey: "circular")
    }

  }

  override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
    if anim.valueForKey("animationName") as! String == "animations" {
      self.delegate?.animationCompleted()
    }
  }
}


extension CABasicAnimation {
  convenience init(keyPath: String!, fromValue: AnyObject, toValue: AnyObject, duration: CFTimeInterval, timingFunction: CAMediaTimingFunction) {
    self.init(keyPath: keyPath)
    
    self.fromValue = fromValue
    self.toValue = toValue
    self.duration = duration
    self.timingFunction = timingFunction
    self.delegate = delegate
    
    self.removedOnCompletion = false
    self.fillMode = kCAFillModeForwards
  }
}

