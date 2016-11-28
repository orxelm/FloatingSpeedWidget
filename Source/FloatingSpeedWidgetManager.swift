//
//  FloatingSpeedWidgetManager.swift
//  FloatingSpeedWidget
//
//  Created by Or Elmaliah on 28/11/2016.
//  Copyright © 2016 Or Elmaliah. All rights reserved.
//

import UIKit

open class FloatingSpeedWidgetManager: NSObject {

    open var speedNumberFont: UIFont?
    open var speedUnitFont: UIFont?
    
    private var floatingWidget: FloatingSpeedWidget!
    private var snapBehavior: UISnapBehavior!
    private var attachmentBehavior: UIAttachmentBehavior!
    private var collisionBehavior: UICollisionBehavior!
    private var animator: UIDynamicAnimator!
    private var targetViewController: UIViewController
    
    public init(withTargetViewController targetViewController: UIViewController, andWidgetSize widgetSize: CGFloat) {
        assert(targetViewController.view != nil, "FloatingSpeedWidgetManager must be initialized after targetViewController.view is loaded")

        self.targetViewController = targetViewController
        
        self.floatingWidget = FloatingSpeedWidget(size: CGSize(width: widgetSize, height: widgetSize), anchorPoint: .bottomLeft)
        self.floatingWidget.speedNumberFont = self.speedNumberFont
        self.floatingWidget.speedUnitFont = self.speedUnitFont
        
        targetViewController.view.addSubview(self.floatingWidget)
        
        self.animator = UIDynamicAnimator(referenceView: targetViewController.view)
        self.collisionBehavior = UICollisionBehavior(items: [self.floatingWidget])
        self.collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        self.animator.addBehavior(self.collisionBehavior)
        
        super.init()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        self.floatingWidget.addGestureRecognizer(panGestureRecognizer)
    }
    
    // MARK: - Public
    
    open func updateSpeed(speed: Double) {
        self.floatingWidget?.speed = speed
    }

    
    // MARK: - Actions
    
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: self.targetViewController.view)
        
        if recognizer.state == .began {
            self.animator.removeAllBehaviors()
            self.animator.addBehavior(self.collisionBehavior)
            
            self.attachmentBehavior = UIAttachmentBehavior(item: self.floatingWidget, attachedToAnchor: location)
            self.animator.addBehavior(self.attachmentBehavior)
        }
        
        if recognizer.state == .changed {
            self.attachmentBehavior.anchorPoint = location
        }
        
        if recognizer.state == .ended || recognizer.state == .cancelled {
            self.animator.removeAllBehaviors()
            self.animator.addBehavior(self.collisionBehavior)
            
            self.snapBehavior = UISnapBehavior(item: self.floatingWidget, snapTo: location)
            self.snapBehavior.damping = 0.4
            self.animator.addBehavior(self.snapBehavior)
        }
    }
}
