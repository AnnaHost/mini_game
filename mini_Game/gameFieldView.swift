//
//  gameFieldView.swift
//  mini_Game
//
//  Created by Анна Гареева on 16.05.2020.
//  Copyright © 2020 Anna Gareeva. All rights reserved.
//

import UIKit
@IBDesignable
class gameFieldView: UIView {
    
    @IBInspectable var shapeColor: UIColor = .red {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shapePosition: CGPoint = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shapeSize: CGSize = CGSize(width: 40, height: 40) {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var isShapeHidden: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
     
    private var currPath: UIBezierPath?
    
    var shapeHitHandler: (() -> Void)?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard !isShapeHidden else {
            currPath = nil
            return
        }
        shapeColor.setFill()
        let path = getTrianglePath(in: CGRect(origin: shapePosition, size: shapeSize))
        path.fill()
        currPath = path
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let currPath = currPath else {
            return
        }
        let hit = touches.contains { (touch) -> Bool in
            let touchPoint = touch.location(in: self)
            return currPath.contains(touchPoint)
        }
        if hit {
            shapeHitHandler?()
        }
    }
    
    
    private func getTrianglePath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 1
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.close()
        path.stroke()
        path.fill()
        return path
    }
    
    func randomizeShapes() {
        let maxX = bounds.maxX - shapeSize.width
        let maxY = bounds.maxY - shapeSize.height
        let x = CGFloat(arc4random_uniform(UInt32(maxX)))
        let y = CGFloat(arc4random_uniform(UInt32(maxY)))
        shapePosition = CGPoint(x: x, y: y)
    }
    
    
}
