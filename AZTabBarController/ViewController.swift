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
    var tabController:AZTabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var icons = [String]()
        icons.append("ic_star")
        icons.append("ic_history")
        icons.append("ic_phone")
        icons.append("ic_chat")
        icons.append("ic_settings")
        
        var sIcons = [String]()
        sIcons.append("ic_settings")
        sIcons.append("ic_star")
        sIcons.append("ic_history")
        sIcons.append("ic_phone")
        sIcons.append("ic_chat")
        
        
        //init
        tabController = AZTabBarController.insert(into: self, withTabIconNames: icons)
        
        
        //set delegate
        tabController.delegate = self
        
        //set child controllers
        tabController.set(viewController: UINavigationController(rootViewController: LabelController.controller(text: "No Favorites", title: "Favorites")), atIndex: 0)
        
        let darkController = getNavigationController(root: LabelController.controller(text: "No Recents", title: "Recents"))
        darkController.navigationBar.barStyle = .black
        darkController.navigationBar.isTranslucent = false
        darkController.navigationBar.barTintColor = #colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)
        
        tabController.set(viewController: darkController, atIndex: 1)
        //tabController.set(viewController: getNavigationController(root: LabelController.controller(text: "Did you expect me to make an actual keypad?", title: "Phone")), atIndex: 2)
        tabController.set(viewController: getNavigationController(root: LabelController.controller(text: "You should really focus on the tab bar.", title: "Chat")), atIndex: 3)
        tabController.set(viewController: getNavigationController(root: LabelController.controller(text: "...", title: "Settings")), atIndex: 4)
        
        
        //customize
        
        tabController.selectedColor = .white //UIColor(colorLiteralRed: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
        
        tabController.highlightedColor = #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
        
        tabController.defaultColor = .white
        
        tabController.highlightButton(atIndex: 2)
        
        tabController.buttonsBackgroundColor = #colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)//UIColor(colorLiteralRed: (247.0/255), green: (247.0/255), blue: (247.0/255), alpha: 1.0)
        
        tabController.selectionIndicatorHeight = 3
        
        tabController.selectionIndicatorColor = #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
        
        tabController.tabBarHeight = 60
        
        //tabController.highlightsSelectedButton = true
        
        tabController.set(badgeText: "!", atIndex: 4)
        
        tabController.set(action: { 
            self.counter = 0
            self.tabController.set(badgeText: nil, atIndex: 3)
            }, atIndex: 3)
        
        tabController.set(action: {
            self.counter += 1
            self.tabController.set(badgeText: "\(self.counter)", atIndex: 3)
            }, atIndex: 2)
        
        tabController.set(action: { 
            //self.tabController.setBar(hidden: true, animated: true)
            
        }, atIndex: 4)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var childViewControllerForStatusBarStyle: UIViewController?{
        return tabController
    }
    
    func getNavigationController(root: UIViewController)->UINavigationController{
        let navigationController = UINavigationController(rootViewController: root)
        navigationController.title = title
        return navigationController
    }
}

extension ViewController: AZTabBarDelegate{
    func tabBar(_ tabBar: AZTabBarController, statusBarStyleForIndex index: Int) -> UIStatusBarStyle {
        return (index % 2) == 0 ? .default : .lightContent
    }
    
    func tabBar(_ tabBar: AZTabBarController, shouldLongClickForIndex index: Int) -> Bool {
        return false//index != 2 && index != 3
    }
    
    func tabBar(_ tabBar: AZTabBarController, shouldAnimateButtonInteractionAtIndex index: Int) -> Bool {
        return index != 2
    }
    
    func tabBar(_ tabBar: AZTabBarController, didMoveToTabAtIndex index: Int) {
        print("didMoveToTabAtIndex \(index)")
    }
    
    func tabBar(_ tabBar: AZTabBarController, didSelectTabAtIndex index: Int) {
        print("didSelectTabAtIndex \(index)")
    }
    
    func tabBar(_ tabBar: AZTabBarController, willMoveToTabAtIndex index: Int) {
        print("willMoveToTabAtIndex \(index)")
    }
    
    func tabBar(_ tabBar: AZTabBarController, didLongClickTabAtIndex index: Int) {
        print("didLongClickTabAtIndex \(index)")
    }
}

class LabelController: UIViewController {
    
    class func controller(text:String, title: String)-> LabelController{
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LabelController") as! LabelController
        controller.title = title
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
