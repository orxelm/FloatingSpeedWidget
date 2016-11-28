//
//  DemoViewController.swift
//  FloatingSpeedWidget
//
//  Created by Or Elmaliah on 27/11/2016.
//  Copyright © 2016 Or Elmaliah. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    private var floatingSpeedWidgetManager: FloatingSpeedWidgetManager!
    
    // MARK: - UIViewController
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.floatingSpeedWidgetManager = FloatingSpeedWidgetManager(withTargetViewController: self, andWidgetSize: 80)
    }
}

