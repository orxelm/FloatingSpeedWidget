//
//  FloatingSpeedWidget.swift
//  FloatingSpeedWidget
//
//  Created by Or Elmaliah on 27/11/2016.
//  Copyright © 2016 Or Elmaliah. All rights reserved.
//

import UIKit

enum FloatingSpeedWidgetAnchor {
    case bottomLeft, topLeft, bottomRight, topRight
}

private let MARGIN_FROM_BOUNDS: CGFloat = 50

class FloatingSpeedWidget: UIView {
    
    private var centerPoint: CGPoint {
        return CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
    }
    
    // MARK: - Init
    
    init(size: CGSize, anchorPoint: FloatingSpeedWidgetAnchor) {
        let bounds = UIScreen.main.bounds
        var anchor = CGPoint(x: 0, y: 0)
        
        let size = min(size.width, size.height)
        
        switch anchorPoint {
        case .bottomLeft:
            anchor = CGPoint(x: MARGIN_FROM_BOUNDS, y: bounds.height-size-MARGIN_FROM_BOUNDS)
        case .topLeft:
            anchor = CGPoint(x: MARGIN_FROM_BOUNDS, y: MARGIN_FROM_BOUNDS)
        case .bottomRight:
            anchor = CGPoint(x: bounds.width-size-MARGIN_FROM_BOUNDS, y: bounds.height-size-MARGIN_FROM_BOUNDS)
        case .topRight:
            anchor = CGPoint(x: bounds.width-size-MARGIN_FROM_BOUNDS, y: MARGIN_FROM_BOUNDS)
        }
        
        super.init(frame: CGRect(x: anchor.x, y: anchor.y, width: size, height: size))

        // Big Circle
        let borderWidth: CGFloat = 2
        let circlePath = UIBezierPath.circlePath(withCenter: self.centerPoint, diameter: size - 2*borderWidth, borderWidth: borderWidth)
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        circleShape.fillColor = UIColor.black.withAlphaComponent(0.7).cgColor
        circleShape.lineWidth = borderWidth
        circleShape.strokeColor = UIColor.white.cgColor
        self.layer.addSublayer(circleShape)
        
        // Shadow
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        // Number label
        let numLable = UILabel()
        numLable.font = UIFont.systemFont(ofSize: 24)
        numLable.text = "35"
        numLable.sizeToFit()
        numLable.center = self.centerPoint
        numLable.textColor = UIColor.white
        self.addSubview(numLable)
        
        // Unit label
        let unitLable = UILabel()
        unitLable.font = UIFont.systemFont(ofSize: 13)
        unitLable.text = "mph"
        numLable.sizeToFit()
        numLable.center = self.centerPoint
        numLable.textColor = UIColor.white
        self.addSubview(unitLable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension

extension UIBezierPath {
    class func circlePath(withCenter center: CGPoint, diameter: CGFloat, borderWidth: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: center, radius: diameter/2, startAngle: 0, endAngle: 2*CGFloat(M_PI), clockwise: true)
        path.lineWidth = borderWidth
        return path
    }
}
