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

    var resultArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioId = createAudio()

        
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
        
        
        
        tabController.setViewController(ColorSelectorController.instance(), atIndex: 0)

        let darkController = getNavigationController(root: LabelController.controller(text: "Search", title: "Recents"))
        darkController.navigationBar.barStyle = .black
        darkController.navigationBar.isTranslucent = false
        darkController.navigationBar.barTintColor = #colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)
        
        
        tabController.setViewController(UIViewController(), atIndex: 1)
      tabController.highlightButtonsOnTap = true

        tabController.setViewController(getNavigationController(root: LabelController.controller(text: "You should really focus on the tab bar.", title: "Chat")), atIndex: 3)
        
        let buttonController = ButtonController.controller(badgeCount: 0, currentIndex: 4)
        tabController.setViewController(getNavigationController(root: buttonController), atIndex: 4)
        
        
        //customize
        
        let color = UIColor(red: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
        
        tabController.selectedColor = color
        
        tabController.highlightColor = color
        
        tabController.highlightedBackgroundColor = #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
        
        tabController.defaultColor = .lightGray
        
        //tabController.highlightButton(atIndex: 2)
        
        tabController.buttonsBackgroundColor = UIColor(red: (247.0/255), green: (247.0/255), blue: (247.0/255), alpha: 1.0)//#colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)
        
        tabController.selectionIndicatorHeight = 0
        
        tabController.selectionIndicatorColor = color
        
        tabController.tabBarHeight = 60
        
        tabController.notificationBadgeAppearance.backgroundColor = .red
        tabController.notificationBadgeAppearance.textColor = .white
        tabController.notificationBadgeAppearance.borderColor = .clear
        tabController.notificationBadgeAppearance.borderWidth = 0.2
        
        
        tabController.setBadgeText("!", atIndex: 4)
        
        tabController.setIndex(10, animated: true)
        
        tabController.setAction(atIndex: 3){
            self.counter = 0
            self.tabController.setBadgeText(nil, atIndex: 3)
        }
        
        tabController.setAction(atIndex: 2) {
            self.tabController.onlyShowTextForSelectedButtons = !self.tabController.onlyShowTextForSelectedButtons
        }
        
        tabController.setAction(atIndex: 4) {
            //self.tabController.setBar(hidden: true, animated: true)
        }
        
        tabController.setIndex(1, animated: true)
        
        tabController.animateTabChange = false
        tabController.onlyShowTextForSelectedButtons = false
        tabController.setTitle("Home", atIndex: 0)
        tabController.setTitle("Search", atIndex: 1)
        tabController.setTitle("Camera", atIndex: 2)
        tabController.setTitle("Feed", atIndex: 3)
        tabController.setTitle("Profile", atIndex: 4)
        tabController.font = UIFont(name: "AvenirNext-Regular", size: 12)
        
        let container = tabController.buttonsContainer
        container?.layer.shadowOffset = CGSize(width: 0, height: -2)
        container?.layer.shadowRadius = 10
        container?.layer.shadowOpacity = 0.1
        container?.layer.shadowColor = UIColor.black.cgColor


        tabController.setButtonTintColor(color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), atIndex: 0)
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
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barStyle = .black
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = #colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)
        return navigationController
    }
    
    func createAudio()->SystemSoundID{
        var soundID: SystemSoundID = 0
        let soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "blop" as CFString!, "mp3" as CFString!, nil)
        AudioServicesCreateSystemSoundID(soundURL!, &soundID)
        return soundID
    }
    
    func actionLaunchCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        {
            let imagePicker:UIImagePickerController = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert:UIAlertController = UIAlertController(title: "Camera Unavailable", message: "Unable to find a camera on this device", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ViewController: AZTabBarDelegate{
    func tabBar(_ tabBar: AZTabBarController, statusBarStyleForIndex index: Int) -> UIStatusBarStyle {
        return (index % 2) == 0 ? .default : .lightContent
    }
    
    func tabBar(_ tabBar: AZTabBarController, shouldLongClickForIndex index: Int) -> Bool {
        return true//index != 2 && index != 3
    }
    
    func tabBar(_ tabBar: AZTabBarController, shouldAnimateButtonInteractionAtIndex index: Int) -> Bool {
        return false
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for view in view.subviews{
            if view is UIButton{
                view.badge(text: nil)
            }
        }
        
        currentTabBar?.setBadgeText(nil, atIndex: currentIndex)
    }
    
    @IBAction func didClickButton(_ sender: UIButton) {
        badgeCount += 1
        
        //currentTabBar?.removeAction(atIndex: 2)
        
        if let tabBar = currentTabBar{
            tabBar.setBadgeText("\(badgeCount)", atIndex: currentIndex)
            sender.badge(text: "\(badgeCount)")
        }
    }
    
    
}
