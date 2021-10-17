//
//  VerticalLineView.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/18.
//

import UIKit

class VerticalLineView: UIView {
  
  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else { return }
    
    let midX = bounds.midX
    let minY = bounds.minY
    let maxY = bounds.maxY
    
    context.setStrokeColor(UIColor.gray.cgColor)
    context.setLineWidth(1)
    context.move(to: CGPoint(x: midX, y: minY))
    context.addLine(to: CGPoint(x: midX, y: maxY))
    context.strokePath()
  }
  
}
