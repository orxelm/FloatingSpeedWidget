//
//  FloatingSpeedWidgetViewController.swift
//  FloatingSpeedWidget
//
//  Created by Or Elmaliah on 27/11/2016.
//  Copyright © 2016 Or Elmaliah. All rights reserved.
//

import UIKit

protocol FloatingSpeedWidgetDelegate {
    func floatingSpeedWidgetShouldChangeSpeed(speed: Double)
}

class FloatingSpeedWidgetViewController: UIViewController {

    private var floatingWidget: FloatingSpeedWidget!
    private var snapBehavior: UISnapBehavior!
    private var attachmentBehavior: UIAttachmentBehavior!
    private var collisionBehavior: UICollisionBehavior!
    private var animator: UIDynamicAnimator!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.floatingWidget = FloatingSpeedWidget(size: CGSize(width: 80, height: 80), anchorPoint: .bottomLeft)
        self.view.addSubview(self.floatingWidget)

        self.animator = UIDynamicAnimator(referenceView: self.view)
        
        self.collisionBehavior = UICollisionBehavior(items: [self.floatingWidget])
        self.collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        self.animator.addBehavior(self.collisionBehavior)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        self.floatingWidget.addGestureRecognizer(panGestureRecognizer)
        
        self.view.backgroundColor = UIColor.clear
    }
    
    // MARK: - Public
    
    func updateSpeed(speed: Double) {
        self.floatingWidget?.speed = speed
    }
    
    // MARK: - Actions
    
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: self.view)
        
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

