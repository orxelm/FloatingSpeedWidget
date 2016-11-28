//
//  FloatingSpeedWidgetView.swift
//  FloatingSpeedWidget
//
//  Created by Or Elmaliah on 27/11/2016.
//  Copyright © 2016 Or Elmaliah. All rights reserved.
//

import UIKit
import FormatterKit

@objc public enum FloatingSpeedWidgetAnchor: Int {
    case bottomLeft, topLeft, bottomRight, topRight
}

private let MARGIN_FROM_BOUNDS: CGFloat = 50

public class FloatingSpeedWidgetView: UIView {
    
    /// The font for the (bigger) number label
    public var speedNumberFont: UIFont? {
        didSet {
            self.speedLable?.font = speedNumberFont
        }
    }
    
    /// The font for the unit label
    public var speedUnitFont: UIFont? {
        didSet {
            self.unitLable?.font = speedUnitFont
        }
    }
    
    var speed: Double = 0 {
        didSet {
            self.setFormattedSpeed()
        }
    }
    
    private var speedLable: UILabel!
    private var unitLable: UILabel!
    private var centerPoint: CGPoint {
        return CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
    }
    
    // MARK: - Init
    
    init(size: CGSize, anchorPoint: FloatingSpeedWidgetAnchor) {
        let size = min(size.width, size.height)
        let anchor = FloatingSpeedWidgetView.anchorPoint(fromFloatingSpeedWidgetAnchor: anchorPoint, andSize: size)
        
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
        
        self.createSpeedLables()
        self.setFormattedSpeed()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private helpers
    
    private func createSpeedLables() {
        // Number label
        let speedLable = UILabel()
        speedLable.font = self.speedUnitFont ?? UIFont.systemFont(ofSize: 24)
        speedLable.center = self.centerPoint
        speedLable.textColor = UIColor.white
        speedLable.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(speedLable)
        self.speedLable = speedLable
        
        let speedLableCenterxConstraint = NSLayoutConstraint(item: speedLable, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let speedLableCenteryConstraint = NSLayoutConstraint(item: speedLable, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -4)
        self.addConstraints([speedLableCenterxConstraint, speedLableCenteryConstraint])
        
        // Unit label
        let unitLable = UILabel()
        unitLable.font = self.speedUnitFont ?? UIFont.systemFont(ofSize: 13)
        unitLable.center = self.centerPoint
        unitLable.textColor = UIColor.white
        unitLable.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(unitLable)
        self.unitLable = unitLable
        
        let unitLableCenterxConstraint = NSLayoutConstraint(item: unitLable, attribute: .centerX, relatedBy: .equal, toItem: speedLable, attribute: .centerX, multiplier: 1, constant: 0)
        let unitLableTopConstraint = NSLayoutConstraint(item: unitLable, attribute: .top, relatedBy: .equal, toItem: speedLable, attribute: .bottom, multiplier: 1, constant: -4)
        self.addConstraints([unitLableCenterxConstraint, unitLableTopConstraint])
    }
    
    private func setFormattedSpeed() {
        guard self.speedLable != nil && self.unitLable != nil else { return }
        
        let locationFormatter = TTTLocationFormatter()
        locationFormatter.numberFormatter.maximumFractionDigits = 0
        
        if let speedString = locationFormatter.string(fromSpeed: self.speed) {
            let speedComponents = speedString.components(separatedBy: " ")
            self.speedLable.text = speedComponents.first
            self.unitLable.text = speedComponents.last
        }
    }
    
    private static func anchorPoint(fromFloatingSpeedWidgetAnchor floatingSpeedWidgetAnchor: FloatingSpeedWidgetAnchor, andSize size: CGFloat) -> CGPoint {
        let bounds = UIScreen.main.bounds
        var anchor = CGPoint(x: 0, y: 0)
        
        switch floatingSpeedWidgetAnchor {
        case .bottomLeft:
            anchor = CGPoint(x: MARGIN_FROM_BOUNDS, y: bounds.height-size-MARGIN_FROM_BOUNDS)
        case .topLeft:
            anchor = CGPoint(x: MARGIN_FROM_BOUNDS, y: MARGIN_FROM_BOUNDS)
        case .bottomRight:
            anchor = CGPoint(x: bounds.width-size-MARGIN_FROM_BOUNDS, y: bounds.height-size-MARGIN_FROM_BOUNDS)
        case .topRight:
            anchor = CGPoint(x: bounds.width-size-MARGIN_FROM_BOUNDS, y: MARGIN_FROM_BOUNDS)
        }
        
        return anchor
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
