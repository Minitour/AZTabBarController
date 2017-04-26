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
import AZSearchView

class ViewController: UIViewController {
    
    
    var counter = 0
    var tabController:AZTabBarController!
    
    var audioId: SystemSoundID!
    
    var searchController: AZSearchViewController!
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
        
        
        
        //tabController.setViewController(ColorSelectorController.instance(), atIndex: 0)
        
        let darkController = getNavigationController(root: LabelController.controller(text: "Search", title: "Recents"))
        darkController.navigationBar.barStyle = .black
        darkController.navigationBar.isTranslucent = false
        darkController.navigationBar.barTintColor = #colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)
        
        
        tabController.setViewController(SearchController.instance(), atIndex: 1)

        tabController.setViewController(getNavigationController(root: LabelController.controller(text: "You should really focus on the tab bar.", title: "Chat")), atIndex: 3)
        
        let buttonController = ButtonController.controller(badgeCount: 0, currentIndex: 4)
        tabController.setViewController(getNavigationController(root: buttonController), atIndex: 4)
        
        
        //customize
        
        tabController.selectedColor = #colorLiteral(red: 0.09048881881, green: 0.09048881881, blue: 0.09048881881, alpha: 1) //UIColor(colorLiteralRed: 14.0/255, green: 122.0/255, blue: 254.0/255, alpha: 1.0)
        
        tabController.highlightColor = #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
        
        //tabController.highlightedBackgroundColor
        
        tabController.defaultColor = #colorLiteral(red: 0.09048881881, green: 0.09048881881, blue: 0.09048881881, alpha: 1)
        
        //tabController.highlightButton(atIndex: 2)
        
        tabController.buttonsBackgroundColor = UIColor(colorLiteralRed: (247.0/255), green: (247.0/255), blue: (247.0/255), alpha: 1.0)//#colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1)
        
        tabController.selectionIndicatorHeight = 3
        
        tabController.selectionIndicatorColor = #colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1)
        
        tabController.tabBarHeight = 60
        
        tabController.notificationBadgeAppearance.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tabController.notificationBadgeAppearance.textColor = .red
        tabController.notificationBadgeAppearance.borderColor = .black
        tabController.notificationBadgeAppearance.borderWidth = 0.2
        
        
        tabController.setBadgeText("!", atIndex: 4)
        
        tabController.setIndex(10, animated: true)
        
        tabController.setAction(atIndex: 3){
            self.counter = 0
            self.tabController.setBadgeText(nil, atIndex: 3)
        }
        
        tabController.setAction(atIndex: 2) {
            //self.counter += 1
            //self.tabController.set(badgeText: "\(self.counter)", atIndex: 3)
            self.actionLaunchCamera()
        }
        
        tabController.setAction(atIndex: 4) {
            //self.tabController.setBar(hidden: true, animated: true)
        }
        
        tabController.setIndex(3, animated: true)
        
        tabController.animateTabChange = true
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
            imagePicker.delegate = self
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
        return false//index != 2 && index != 3
    }
    
    func tabBar(_ tabBar: AZTabBarController, shouldAnimateButtonInteractionAtIndex index: Int) -> Bool {
        return !(index == 3 || index == 2)
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

extension ViewController: AZSearchViewDelegate{
    
    func searchView(_ searchView: AZSearchViewController, didSearchForText text: String) {
        searchView.dismiss(animated: false, completion: nil)
    }
    
    func searchView(_ searchView: AZSearchViewController, didTextChangeTo text: String, textLength: Int) {
        self.resultArray.removeAll()
        if textLength > 3 {
            for i in 0..<arc4random_uniform(10)+1 {self.resultArray.append("\(text) \(i+1)")}
        }
        
        searchView.reloadData()
    }
    
    func searchView(_ searchView: AZSearchViewController, didSelectResultAt index: Int, text: String) {
        searchView.dismiss(animated: true, completion: {
        })
    }
}

extension ViewController: AZSearchViewDataSource{
    
    func results() -> [String] {
        return self.resultArray
    }
}

extension ViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
        currentTabBar?.removeViewController(atIndex: 0)
        
        if let tabBar = currentTabBar{
            tabBar.setBadgeText("\(badgeCount)", atIndex: currentIndex)
            sender.badge(text: "\(badgeCount)")
        }
    }
    
    
}
