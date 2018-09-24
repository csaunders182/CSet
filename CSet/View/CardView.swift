//
//  SetCardView.swift
//  CSet
//
//  Created by Cole Saunders on 1/11/18.
//  Copyright © 2018 Cole Saunders. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    var shapeColor: UIColor = .red
        {didSet{setNeedsDisplay()}}
    
    var shape: Shapes = .squiggle
        {didSet{setNeedsDisplay()}}
    
    var shapeQuantity: NumbersOfShapes = .three
        {didSet{setNeedsDisplay()}}
    
    var fillPattern: FillPatterns = .striped
        {didSet{setNeedsDisplay()}}
    
    var borderColor: UIColor = .darkGray
    
    var showingCardBack = true
        {didSet{setNeedsDisplay()}}
    
    let cardBackColor = UIColor.red
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        setEdgesOfCard()
        
        let shapePoints = getCenterPointsForShapes()
        
        if !showingCardBack {
            addBorder()
            context?.saveGState()
            for shape in 0..<shapeQuantity.rawValue {
                context?.saveGState()
                let shapePath = getShapePath(origin: shapePoints[shape])
                let outlineColor = getOutlineColor()
                let fillColor = getFillColor()
                outlineColor.setStroke()
                shapePath.stroke()
                fillColor.setFill()
                shapePath.addClip()
                shapePath.fill()
                if fillPattern == .striped {
                    stripeDrawing()
                }
                context?.restoreGState()
            }
        }
        
    }
    
    func makeCopy() -> CardView {
        let cardView = CardView(frame: self.frame)
        cardView.shapeColor = self.shapeColor
        cardView.shape = self.shape
        cardView.shapeQuantity = self.shapeQuantity
        cardView.fillPattern = self.fillPattern
        cardView.borderColor = self.borderColor
        cardView.showingCardBack = self.showingCardBack
        return cardView
    }
    
    private func stripeDrawing() {
        let size = shapeSizeToBounds
        let startPoint = CGPoint(x: bounds.midX, y: 0).offsetBy(dx: -size.width/2 , dy: 0)
        let stripePath = UIBezierPath()
        for lineSpacing in stride(from: 0, to: size.width, by: CGFloat(3.0)) {
        stripePath.move(to: startPoint.offsetBy(dx: lineSpacing, dy: 0))
        shapeColor.setStroke()
        stripePath.addLine(to: startPoint.offsetBy(dx: lineSpacing, dy: bounds.height))
        stripePath.stroke()
        }
        
    }
    
    private func addBorder() {
        let borderPath = UIBezierPath(roundedRect: bounds.inset(by: CGSize(width: 2.0, height: 2.0)), cornerRadius: cornerRadius)
        borderColor.setStroke()
        borderPath.lineWidth = 10.0
        borderPath.stroke()
    }
    
    private func getShapePath(origin: CGPoint) -> UIBezierPath {
        let size = shapeSizeToBounds
        switch shape {
        case .oval:
            return UIBezierPath(ovalIn: CGRect(origin: origin, size: shapeSizeToBounds))
        case .diamond:
            let diamondPath = UIBezierPath()
            diamondPath.move(to: origin.offsetBy(dx: 0, dy: size.height/2))
            diamondPath.addLine(to: origin.offsetBy(dx: size.width/2, dy: 0))
            diamondPath.addLine(to: origin.offsetBy(dx: size.width, dy: size.height/2))
            diamondPath.addLine(to: origin.offsetBy(dx: size.width/2, dy: size.height))
            diamondPath.close()
            return diamondPath
        case .squiggle:
            let squigglePath = UIBezierPath()
            squigglePath.move(to: origin.offsetBy(dx: 0, dy: size.height))
            squigglePath.addCurve(to: origin.offsetBy(dx: size.width, dy: 0), controlPoint1: origin.offsetBy(dx: size.width/3, dy: -size.height), controlPoint2: origin.offsetBy(dx: size.width * 0.66, dy: size.height))
            squigglePath.addCurve(to: origin.offsetBy(dx: 0, dy: size.height), controlPoint1: origin.offsetBy(dx: size.width * 0.66, dy: size.height * 2), controlPoint2: origin.offsetBy(dx: size.width/2, dy: -size.height * 0.6))
            return squigglePath

        }
    }
    
    private func getFillColor() -> UIColor {
        switch fillPattern {
        case .solid:
            return shapeColor
        default:
            return UIColor.clear
        }
    }
    
    private func getOutlineColor() -> UIColor {
        switch fillPattern {
        case .outline:
            return shapeColor
        case .striped:
            return shapeColor
        default:
            return UIColor.clear
        }
    }
    
    private func setEdgesOfCard() {
        let roundedRect = UIBezierPath(roundedRect: bounds.inset(by: CGSize(width: 2.0, height: 2.0)), cornerRadius: cornerRadius)
        roundedRect.addClip()
        if showingCardBack {
            cardBackColor.setFill()
        } else {
           UIColor.white.setFill()
        }
        roundedRect.addClip()
        roundedRect.fill()
    }
    
    private struct SizeRatio {
        static let cornerFrontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let shapeSizeToBoundsHeight: CGFloat = 0.25
        static let shapeSizeToBoundsWidth: CGFloat = 0.80
        static let shapeSpacing: CGFloat = 5
        static let threeCardSpacingMultiplier: CGFloat = 1.5
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var cornerOffset:CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    private var shapeSizeToBounds: CGSize {
        return CGSize(width: bounds.width * SizeRatio.shapeSizeToBoundsWidth, height: bounds.height * SizeRatio.shapeSizeToBoundsHeight)
    }
    
    private var shapeCenterOrigin: CGPoint {
        let size = shapeSizeToBounds
        return CGPoint(x: bounds.midX, y: bounds.midY).offsetBy(dx: -size.width/2, dy: -size.height/2)
    }
    
    private func getCenterPointsForShapes() -> [CGPoint] {
        let size = shapeSizeToBounds
        let boundsCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        switch shapeQuantity {
        case .one:
            let point = boundsCenter.offsetBy(dx: -size.width/2, dy: -size.height/2)
            return [point]
        case .two:
            let firstPoint = boundsCenter.offsetBy(dx: -size.width/2, dy: -size.height + -SizeRatio.shapeSpacing/2)
            let secondPoint = boundsCenter.offsetBy(dx: -size.width/2, dy: SizeRatio.shapeSpacing/2)
            return [firstPoint, secondPoint]
        case .three:
            let firstPoint = boundsCenter.offsetBy(dx: -size.width/2, dy: -size.height/2)
            let secondPoint = boundsCenter.offsetBy(dx: -size.width/2, dy: size.height/2 * SizeRatio.threeCardSpacingMultiplier - SizeRatio.shapeSpacing)
            let thirdPoint = boundsCenter.offsetBy(dx: -size.width/2, dy: -size.height * SizeRatio.threeCardSpacingMultiplier - SizeRatio.shapeSpacing)
            return [firstPoint, secondPoint, thirdPoint]
        }
    }
}


