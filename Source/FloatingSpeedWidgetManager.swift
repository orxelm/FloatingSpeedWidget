//
//  FloatingSpeedWidgetManager.swift
//  FloatingSpeedWidget
//
//  Created by Or Elmaliah on 28/11/2016.
//  Copyright © 2016 Or Elmaliah. All rights reserved.
//

import UIKit

public class FloatingSpeedWidgetManager: NSObject {
    
    public private(set) var floatingWidgetView: FloatingSpeedWidgetView!
    private var snapBehavior: UISnapBehavior!
    private var attachmentBehavior: UIAttachmentBehavior!
    private var collisionBehavior: UICollisionBehavior!
    private var animator: UIDynamicAnimator!
    private weak var targetViewController: UIViewController?
    
    // MARK: - NSObject
    
    deinit {
        self.targetViewController = nil
        self.floatingWidgetView = nil
    }
    
    public init(withTargetViewController targetViewController: UIViewController, anchorPoint: FloatingSpeedWidgetAnchor = .bottomLeft, andWidgetSize widgetSize: CGFloat) {
        assert(targetViewController.view != nil, "FloatingSpeedWidgetManager must be initialized after targetViewController.view is loaded")

        self.targetViewController = targetViewController
        
        self.floatingWidgetView = FloatingSpeedWidgetView(size: CGSize(width: widgetSize, height: widgetSize), anchorPoint: anchorPoint)
        
        targetViewController.view.addSubview(self.floatingWidgetView)
        
        self.animator = UIDynamicAnimator(referenceView: targetViewController.view)
        self.collisionBehavior = UICollisionBehavior(items: [self.floatingWidgetView])
        self.collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        self.animator.addBehavior(self.collisionBehavior)
        
        super.init()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        self.floatingWidgetView.addGestureRecognizer(panGestureRecognizer)
    }
    
    // MARK: - Public
    
    public func updateSpeed(speed: Double) {
        self.floatingWidgetView?.speed = speed
    }

    public func removeWidget() {
        self.animator.removeAllBehaviors()
        self.floatingWidgetView.removeFromSuperview()
        self.floatingWidgetView = nil
        self.targetViewController = nil
    }
    
    // MARK: - Actions
    
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        guard let targetViewController = self.targetViewController else { return }
        
        let location = recognizer.location(in: targetViewController.view)
        
        if recognizer.state == .began {
            self.animator.removeAllBehaviors()
            self.animator.addBehavior(self.collisionBehavior)
            
            self.attachmentBehavior = UIAttachmentBehavior(item: self.floatingWidgetView, attachedToAnchor: location)
            self.animator.addBehavior(self.attachmentBehavior)
        }
        
        if recognizer.state == .changed {
            self.attachmentBehavior.anchorPoint = location
        }
        
        if recognizer.state == .ended || recognizer.state == .cancelled {
            self.animator.removeAllBehaviors()
            self.animator.addBehavior(self.collisionBehavior)
            
            self.snapBehavior = UISnapBehavior(item: self.floatingWidgetView, snapTo: location)
            self.snapBehavior.damping = 0.4
            self.animator.addBehavior(self.snapBehavior)
        }
    }
}
