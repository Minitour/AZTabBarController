//
//  ViewController.swift
//  AZTabBarController
//
//  Created by Antonio Zaitoun on 9/13/16.
//  Copyright © 2016 Crofis. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class ViewController: UIViewController {
    
    
    var counter = 0
    var tabController:AZTabBarController!
    
    var audioId: SystemSoundID!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioId = createAudio()
        
//        var icons = [String]()
//        icons.append("ic_star")
//        icons.append("ic_history")
//        icons.append("ic_phone")
//        icons.append("ic_chat")
//        icons.append("ic_settings")
//        
//        var sIcons = [String]()
//        sIcons.append("ic_settings")
//        sIcons.append("ic_star")
//        sIcons.append("ic_history")
//        sIcons.append("ic_phone")
//        sIcons.append("ic_chat")
        
        var icons = [UIImage]()
        icons.append(#imageLiteral(resourceName: "ic_home_outline"))
        icons.append(#imageLiteral(resourceName: "ic_search_outline"))
        icons.append(#imageLiteral(resourceName: "ic_camera_outline"))
        icons.append(#imageLiteral(resourceName: "ic_heart_outline"))
        icons.append(#imageLiteral(resourceName: "ic_account_outline"))
        
        var sIcons = [UIImage]()
        sIcons.append(#imageLiteral(resourceName: "ic_home"))
        sIcons.append(#imageLiteral(resourceName: "ic_search"))
        sIcons.append(#imageLiteral(resourceName: "ic_camera"))
        sIcons.append(#imageLiteral(resourceName: "ic_heart"))
        sIcons.append(#imageLiteral(resourceName: "ic_account"))
        
        
        //init
        //tabController = AZTabBarController.insert(into: self, withTabIconNames: icons)
        tabController = AZTabBarController.insert(into: self, withTabIcons: icons, andSelectedIcons: sIcons)
        
        //set delegate
        tabController.delegate = self
        
        //set child controllers
        
        let buttonController = ButtonController.controller(badgeCount: 0, currentIndex: 0)
        
        tabController.set(viewController: UINavigationController(rootViewController: buttonController), atIndex: 0)
        
        let darkController = getNavigationController(root: LabelController.controller(text: "No Recents", title: "Recents"))
        darkController.navigationBar.barStyle = .black
        darkController.navigationBar.isTranslucent = false
        darkController.navigationBar.barTintColor = #colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)
        
        tabController.set(viewController: darkController, atIndex: 1)
        tabController.set(viewController: getNavigationController(root: LabelController.controller(text: "Did you expect me to make an actual keypad?", title: "Phone")), atIndex: 2)
        tabController.set(viewController: getNavigationController(root: LabelController.controller(text: "You should really focus on the tab bar.", title: "Chat")), atIndex: 3)
        tabController.set(viewController: getNavigationController(root: LabelController.controller(text: "...", title: "Settings")), atIndex: 4)
        
        
        //customize
        
        tabController.selectedColor = #colorLiteral(red: 0.09048881881, green: 0.09048881881, blue: 0.09048881881, alpha: 1) //UIColor(colorLiteralRed: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
        
        tabController.highlightColor = #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
        
        tabController.defaultColor = #colorLiteral(red: 0.09048881881, green: 0.09048881881, blue: 0.09048881881, alpha: 1)
        
        //tabController.highlightButton(atIndex: 2)
        
        tabController.buttonsBackgroundColor = UIColor(colorLiteralRed: (247.0/255), green: (247.0/255), blue: (247.0/255), alpha: 1.0)//#colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)
        
        tabController.selectionIndicatorHeight = 0
        
        tabController.selectionIndicatorColor = #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
        
        tabController.tabBarHeight = 60
        
        tabController.notificationBadgeAppearance.backgroundColor = #colorLiteral(red: 1, green: 0.3094263673, blue: 0.4742257595, alpha: 1)
        
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
    
    func createAudio()->SystemSoundID{
        var soundID: SystemSoundID = 0
        let soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "blop" as CFString!, "mp3" as CFString!, nil)
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        return soundID
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
        return true //index != 2
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
    
    func tabBar(_ tabBar: AZTabBarController, systemSoundIdForButtonAtIndex index: Int) -> SystemSoundID? {
        return tabBar.selectedIndex == index ? nil : audioId
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

class ButtonController: UIViewController{
    class func controller(badgeCount:Int, currentIndex: Int )-> ButtonController{
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ButtonController") as! ButtonController
        controller.badgeCount = badgeCount
        controller.currentIndex = currentIndex
        return controller
    }
    
    var badgeCount: Int = 0
    var currentIndex: Int = 0
    
    @IBAction func didClickButton(_ sender: UIButton) {
        badgeCount += 1
        
        
        if let tabBar = currentTabBar{
            tabBar.set(badgeText: "\(badgeCount)", atIndex: currentIndex)
        }
    }
    
    
}
