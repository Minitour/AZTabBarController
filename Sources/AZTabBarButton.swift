//
//  AZTabBarButton.swift
//  AZTabBarController
//
//  Created by Antonio Zaitoun on 18/05/2017.
//  Copyright © 2017 Crofis. All rights reserved.
//

import EasyNotificationBadge
import UIKit

public class AZTabBarButton: UIButton{
    
    var longClickTimer: Timer?
    
    open weak var delegate: AZTabBarButtonDelegate!
    
    open var shouldAnimateInteraction:Bool {
        get{
            return delegate.shouldAnimate(self)
        }
    }
    
    open var beginAnimationDuration: TimeInterval{
        get{
            return delegate.beginAnimationDuration(self)
        }
    }
    
    open var endAnimationDuration: TimeInterval{
        get{
            return delegate.endAnimationDuration(self)
        }
    }
    
    open var initialSpringVelocity: CGFloat{
        get{
            return delegate.initialSpringVelocity(self)
        }
    }
    
    open var usingSpringWithDamping: CGFloat{
        get{
            return delegate.usingSpringWithDamping(self)
        }
    }
    
    open var longClickTriggerDuration: TimeInterval{
        get{
            return delegate.longClickTriggerDuration(self)
        }
    }
    
    open var isLongClickEnabled: Bool{
        get{
            return delegate.shouldLongClick(self)
        }
    }
    
    @objc func longClickPerformed(){
        if isLongClickEnabled{
            self.touchesCancelled(Set<UITouch>(), with: nil)
            self.delegate.longClickAction(self)
        }
    }
    
    override public func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let original = super.titleRect(forContentRect: contentRect)
        let image: CGFloat = self.imageRect(forContentRect: contentRect).minY / 2.0
        return CGRect(x: 0, y: contentRect.height - original.height - image, width: contentRect.width , height: original.height)
    }
    
    override public func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let labelHeight = super.titleRect(forContentRect: contentRect).height
        let original = super.imageRect(forContentRect: contentRect)
        let height = original.height
        
        let y = labelHeight > 0 ? (contentRect.height - labelHeight)/2.0 - height/2.0 : contentRect.height/2.0 - height/2.0
        
        return CGRect(x: contentRect.width/2.0 - height/2.0, y: y, width: height, height: height)
    }
    
    var didAddBadge = false
    
    func addBadge(text: String?, appearance: BadgeAppearance){
        didAddBadge = true
        badge(text: text, appearance: appearance)
    }
    
    
    override public func layoutSubviews() {
        
        if didAddBadge{
            super.layoutSubviews()
            didAddBadge = false
            return
        }
        
        let animate = delegate.shouldAnimate(self)
        
        if let titleLabel = titleLabel{
            titleLabel.frame = self.titleRect(forContentRect: self.frame)
        }
        
        self.imageView?.frame = self.imageRect(forContentRect: self.frame)
        
        if animate {
            super.layoutSubviews()
        }else{
            UIView.animate(withDuration: 0.1) {
                
                super.layoutSubviews()
            }
        }
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        centerTitleLabel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        centerTitleLabel()
    }
    
    private func centerTitleLabel() {
        self.titleLabel?.textAlignment = .center
    }
}

extension AZTabBarButton {
    // MARK: - Public methods
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        longClickTimer = Timer.scheduledTimer(timeInterval: self.longClickTriggerDuration,
                                              target: self,
                                              selector: #selector(longClickPerformed),
                                              userInfo: nil, repeats: false)
        if self.shouldAnimateInteraction{
            UIView.animate(withDuration: self.beginAnimationDuration, animations: {
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { (complete) in
            }
        }
        super.touchesBegan(touches, with: event)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let tap:UITouch = touches.first!
        let point = tap.location(in: self)
        //longClickTimer?.invalidate()
        if !self.bounds.contains(point){
            if self.shouldAnimateInteraction{
                UIView.animate(withDuration: self.beginAnimationDuration, animations: {
                    self.transform = .identity
                }) { (complete) in
                }
            }
        }else{
            if self.shouldAnimateInteraction{
                UIView.animate(withDuration: self.beginAnimationDuration, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }) { (complete) in
                }
            }
        }
        
        
        super.touchesMoved(touches, with: event)
        
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let tap:UITouch = touches.first!
        //let point = tap.location(in: self)
        longClickTimer?.invalidate()
        if self.shouldAnimateInteraction{
            UIView.animate(withDuration: self.endAnimationDuration,
                           delay: 0,
                           usingSpringWithDamping: self.usingSpringWithDamping,
                           initialSpringVelocity: self.initialSpringVelocity,
                           options: .allowUserInteraction,
                           animations: {
                            self.transform = .identity
            },
                           completion: nil)
        }
        super.touchesEnded(touches, with: event)
        
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        longClickTimer?.invalidate()
        if self.shouldAnimateInteraction{
            UIView.animate(withDuration: self.endAnimationDuration,
                           delay: 0,
                           usingSpringWithDamping: self.usingSpringWithDamping,
                           initialSpringVelocity: self.initialSpringVelocity,
                           options: .allowUserInteraction,
                           animations: {
                            self.transform = .identity
            },
                           completion: nil)
        }
        super.touchesCancelled(touches, with: event)
    }
    
    func customizeForTabBarWithImage(_ image: UIImage,
                                     highlightImage: UIImage? = nil,
                                     selectedColor: UIColor,
                                     highlighted: Bool,
                                     defaultColor: UIColor = UIColor.gray,
                                     highlightColor: UIColor = UIColor.white,
                                     ignoreColor: Bool = false) {
        if highlighted {
            self.customizeAsHighlighted(image: image, selectedColor: selectedColor, highlightedColor: highlightColor,ignoreColor: ignoreColor)
        }
        else {
            self.customizeAsNormal(image: image,highlightImage: highlightImage, selectedColor: selectedColor,defaultColor: defaultColor, ignoreColor: ignoreColor)
        }
    }
    // MARK: - Private methods
    
    private func customizeAsHighlighted(image: UIImage,selectedColor: UIColor,highlightedColor: UIColor,ignoreColor: Bool = false) {
        // We want the image to be always white in highlighted state.
        self.tintColor = highlightedColor
        self.setTitleColor(highlightedColor, for: [.highlighted])
        self.setTitleColor(highlightedColor, for: [.highlighted,.selected])
        self.setTitleColor(highlightedColor, for: [])
        self.setImage(ignoreColor ? image : image.withRenderingMode(.alwaysTemplate), for: .normal)
        // And its background color should always be the selected color.
        self.backgroundColor = selectedColor
    }
    
    private func customizeAsNormal(image: UIImage,highlightImage: UIImage? = nil,selectedColor: UIColor,defaultColor: UIColor = UIColor.gray,ignoreColor: Bool = false) {
        
        self.tintColor = selectedColor
        
        self.setImage(ignoreColor ? image : image.imageWithColor(color: defaultColor), for: [])
        self.setImage(ignoreColor ? image : image.imageWithColor(color: defaultColor), for: .highlighted)
        if let hImage = highlightImage {
            self.setImage(ignoreColor ? hImage : hImage.imageWithColor(color: selectedColor), for: .selected)
            self.setImage(ignoreColor ? hImage : hImage.imageWithColor(color: selectedColor), for: [.selected, .highlighted])
        }else{
            self.setImage(ignoreColor ? image : image.imageWithColor(color: selectedColor), for: .selected)
            self.setImage(ignoreColor ? image : image.imageWithColor(color: selectedColor), for: [.selected, .highlighted])
        }
        
        
        // We don't want a background color to use the one in the tab bar.
        self.backgroundColor = UIColor.clear
    }
    
    
    
}

fileprivate extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
