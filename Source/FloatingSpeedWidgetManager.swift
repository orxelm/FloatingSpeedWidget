//
//  FloatingSpeedWidgetManager.swift
//  FloatingSpeedWidget
//
//  Created by Or Elmaliah on 28/11/2016.
//  Copyright © 2016 Or Elmaliah. All rights reserved.
//

import UIKit

public class FloatingSpeedWidgetManager: NSObject {
    
    /// The circular widget view
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
        self.floatingWidgetView.alpha = 0
        self.floatingWidgetView.transform = CGAffineTransform(scaleX: 0, y: 0)
        targetViewController.view.addSubview(self.floatingWidgetView)
        
        self.animator = UIDynamicAnimator(referenceView: targetViewController.view)
        self.collisionBehavior = UICollisionBehavior(items: [self.floatingWidgetView])
        self.collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        self.animator.addBehavior(self.collisionBehavior)
        
        super.init()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        self.floatingWidgetView.addGestureRecognizer(panGestureRecognizer)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.floatingWidgetView.alpha = 1
            self.floatingWidgetView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
    // MARK: - Public
    
    public func updateSpeed(speed: Double) {
        guard speed >= 0 else { return }
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
