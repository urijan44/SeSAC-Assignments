//
//  LineView.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/17.
//

import UIKit

class LineView: UIView {
  
  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else { return }
    
    let midY = bounds.midY
    let minX = bounds.minX
    let maxX = bounds.maxX
    
    context.setStrokeColor(UIColor.gray.cgColor)
    context.setLineWidth(1)
    context.move(to: CGPoint(x: minX, y: midY))
    context.addLine(to: CGPoint(x: maxX, y: midY))
    context.strokePath()
  }
}
