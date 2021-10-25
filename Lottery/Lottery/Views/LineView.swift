//
//  LineView.swift
//  Lottery
//
//  Created by hoseung Lee on 2021/10/26.
//

import UIKit

class LineView: UIView {
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    guard let context = UIGraphicsGetCurrentContext() else { return }
    
    context.setStrokeColor(UIColor.lightGray.cgColor)
    context.setLineWidth(1)
    context.move(to: .init(x: bounds.minX, y: bounds.midY))
    context.addLine(to: .init(x: bounds.maxX, y: bounds.midY))
    context.strokePath()
  }
  
  
}
