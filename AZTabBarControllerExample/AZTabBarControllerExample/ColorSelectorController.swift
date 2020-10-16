//
//  ColorSelectorController.swift
//  AZTabBarController
//
//  Created by Antonio Zaitoun on 13/04/2017.
//  Copyright © 2017 Crofis. All rights reserved.
//

import Foundation
import UIKit

class ColorSelectorController: UIViewController{
    class func instance()->UIViewController{
        let colorController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ColorSelectorController")
        let nav = UINavigationController(rootViewController: colorController)
        nav.navigationBar.isTranslucent = false
        return nav
    }
    
    var isTabBarHidden = false
    
    @IBAction func didClick(_ sender: UIBarButtonItem) {
        if isTabBarHidden {
            isTabBarHidden = false
            
            //show the tab bar
            currentTabBar?.setBar(hidden: false, animated: true)
            
            //change text to "Hide Tab Bar"
            sender.title = "Hide Tab Bar"
            
        }else{
            isTabBarHidden = true
            
            //hide the tab bar
            currentTabBar?.setBar(hidden: true, animated: true)
            
            //Change text to "Show Tab Bar"
            sender.title = "Show Tab Bar"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...10 {
            colors.append(ColorSet(randomColor(), randomColor(), randomColor(), randomColor()))
        }
    }
    
    struct ColorSet{
        var defaultColor: UIColor
        var selectedColor: UIColor
        var buttonsBackgroundColor: UIColor
        var separatorLineColor: UIColor
        
        init(_ defaultCol: UIColor,
             _ selected: UIColor,
             _ buttons: UIColor,
             _ seperator: UIColor){
            defaultColor = defaultCol
            selectedColor = selected
            buttonsBackgroundColor = buttons
            separatorLineColor = seperator
        }
    }
    
    var colors: [ColorSet] = [
        ColorSet(#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),#colorLiteral(red: 0.9029021069, green: 0.9029021069, blue: 0.9029021069, alpha: 1)),
        ColorSet(#colorLiteral(red: 1, green: 0.6773071226, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5662180265, blue: 0.08396953645, alpha: 1), #colorLiteral(red: 0.1724842317, green: 0.1724842317, blue: 0.1724842317, alpha: 1), #colorLiteral(red: 1, green: 0.5843137255, blue: 0.01960784314, alpha: 1)),
        ColorSet(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 0.1724842317, green: 0.1724842317, blue: 0.1724842317, alpha: 1)),
        ColorSet(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),#colorLiteral(red: 0.2039215686, green: 0.2862745098, blue: 0.368627451, alpha: 1),.clear),
        ColorSet(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)),
        ColorSet(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 1, green: 0.1568113565, blue: 0.2567096651, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    ]
    
    func randomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        
        let randomGreen:CGFloat = CGFloat(drand48())
        
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
}

extension ColorSelectorController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let bar = currentTabBar {
            bar.defaultColor = colors[indexPath.item].defaultColor
            bar.selectedColor = colors[indexPath.item].selectedColor
            bar.buttonsBackgroundColor = colors[indexPath.item].buttonsBackgroundColor
            bar.separatorLineColor = colors[indexPath.item].separatorLineColor
            
            self.navigationController?.navigationBar.barTintColor = colors[indexPath.item].buttonsBackgroundColor
            self.navigationItem.rightBarButtonItem?.tintColor = colors[indexPath.item].selectedColor
            self.navigationController?.navigationBar.isTranslucent = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 20)/2, height: collectionView.frame.height / 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorfulCell", for: indexPath) as! ColorfulCell
        cell.setup(colors[indexPath.item])
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
}

class ColorfulCell: UICollectionViewCell{
    
    @IBOutlet weak var color1: UIView!
    @IBOutlet weak var color2: UIView!
    @IBOutlet weak var color3: UIView!
    @IBOutlet weak var color4: UIView!
    
    func setup(_ set: ColorSelectorController.ColorSet){
        color1.backgroundColor = set.defaultColor
        color2.backgroundColor = set.selectedColor
        color3.backgroundColor = set.buttonsBackgroundColor
        color4.backgroundColor = set.separatorLineColor
        
        color1.layer.cornerRadius = 5
        color1.layer.masksToBounds = true
        color1.layer.borderColor = UIColor.black.cgColor
        color1.layer.borderWidth = 0.2
        color2.layer.cornerRadius = 5
        color2.layer.masksToBounds = true
        color2.layer.borderColor = UIColor.black.cgColor
        color2.layer.borderWidth = 0.2
        color3.layer.cornerRadius = 5
        color3.layer.masksToBounds = true
        color3.layer.borderColor = UIColor.black.cgColor
        color3.layer.borderWidth = 0.2
        color4.layer.cornerRadius = 5
        color4.layer.masksToBounds = true
        color4.layer.borderColor = UIColor.black.cgColor
        color4.layer.borderWidth = 0.2
    }
}
