//
//  ViewController.swift
//  AZTabBarController
//
//  Created by Antonio Zaitoun on 9/13/16.
//  Copyright © 2016 Crofis. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var icons = [String]()
        icons.append("ic_star")
        icons.append("ic_history")
        icons.append("ic_phone")
        icons.append("ic_chat")
        icons.append("ic_settings")
        
        let tabController = AZTabBarController.insert(into: self, withTabIconNames: icons)
        
        tabController.set(viewController: LabelController.controller(text: "Test 1"), atIndex: 0)
        tabController.set(viewController: LabelController.controller(text: "Test 2"), atIndex: 1)
        tabController.set(viewController: LabelController.controller(text: "Test 3"), atIndex: 2)
        tabController.set(viewController: LabelController.controller(text: "Test 4"), atIndex: 3)
        tabController.set(viewController: LabelController.controller(text: "Test 5"), atIndex: 4)
        
        
//        tabController.defaultColor = UIColor.white
//        
//        tabController.selectedColor = UIColor.orange
//        
//        tabController.buttonsBackgroundColor = UIColor.black
        
        tabController.selectedColor = UIColor(colorLiteralRed: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
        
        tabController.buttonsBackgroundColor = UIColor(colorLiteralRed: (247.0/255), green: (247.0/255), blue: (247.0/255), alpha: 1.0)
        
        
        //tabController.highlightButton(atIndex: 2)
        
        tabController.selectionIndicatorHeight = 0
        
        
        tabController.set(action: { 
            self.counter = 0
            tabController.set(badge: nil, atIndex: 3)
            }, atIndex: 3)
        
        tabController.set(action: {
            self.counter += 1
            tabController.set(badge: "\(self.counter)", atIndex: 3)
            }, atIndex: 2)
        
        
    }
    
    
    
}

class LabelController: UIViewController {
    
    class func controller(text:String)-> LabelController{
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LabelController") as! LabelController
        
        controller.text = text
        return controller
    }
    
    var text:String!
    
    @IBOutlet weak private var labelView:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelView.text = text
    }
    
}
