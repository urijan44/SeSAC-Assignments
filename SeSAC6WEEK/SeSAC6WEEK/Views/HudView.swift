//
//  AddHudView.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/03.
//

import UIKit

class HudView: UIView {
  var text = ""
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    let boxWidth: CGFloat = 96
    let boxHeight: CGFloat = 96
    
    let boxRect = CGRect(
      x: round((bounds.width - boxWidth) / 2),
      y: round((bounds.height - boxHeight) / 2),
      width: boxWidth,
      height: boxHeight)
    
    let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
    UIColor(white: 0.3, alpha: 1).setFill()
    roundedRect.fill()
    
    if let image = UIImage(named: "Openbook") {
      image.withTintColor(.white)
      let imagePoint = CGPoint(
        x: center.x - round(image.size.width / 2),
        y: center.y - round(image.size.height / 2) - boxHeight / 8)
      image.draw(at: imagePoint)
    }
    
    let attribs = [
      NSAttributedString.Key.font: UIFont.mainLight,
      NSAttributedString.Key.foregroundColor: UIColor.white
    ]
    
    let textSize = text.size(withAttributes: attribs)
    
    let textPoint = CGPoint(
      x: center.x - round(textSize.width / 2),
      y: center.y - round(textSize.height / 2) + boxHeight / 3)
    
    text.draw(at: textPoint, withAttributes: attribs)
  }
  
  class func hud(inView view: UIView, animated: Bool) -> HudView {
    let hudView = HudView(frame: view.bounds)
    hudView.isOpaque = false
    
    view.addSubview(hudView)
    view.isUserInteractionEnabled = false
    hudView.show(animated: animated)
    return hudView
  }
  
  func show(animated: Bool) {
    if animated {
      alpha = 0
      transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
      
      UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: []) {
        self.alpha = 1
        self.transform = CGAffineTransform.identity
      }
    }
  }
  
  func hide() {
    superview?.isUserInteractionEnabled = true
    removeFromSuperview()
  }
}
