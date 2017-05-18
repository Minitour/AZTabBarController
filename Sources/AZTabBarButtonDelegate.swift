//
//  AZTabBarButtonDelegate.swift
//  AZTabBarController
//
//  Created by Antonio Zaitoun on 18/05/2017.
//  Copyright © 2017 Crofis. All rights reserved.
//

import Foundation
import UIKit

public protocol AZTabBarButtonDelegate: class {
    
    
    /// Function used to decide if the TabBarButton should animate upon interaction.
    ///
    /// - Parameter tabBarButton: The sender.
    func shouldAnimate(_ tabBarButton: AZTabBarButton)->Bool
    
    
    /// The start animation duration.
    ///
    /// - Parameter tabBarButton: The sender.
    func beginAnimationDuration(_ tabBarButton: AZTabBarButton)->TimeInterval
    
    
    /// The ending animation duration.
    ///
    /// - Parameter tabBarButton: The sender.
    func endAnimationDuration(_ tabBarButton: AZTabBarButton)->TimeInterval
    
    
    /// The initial Spring Velocity for the ending animation.
    ///
    /// - Parameter tabBarButton: The sender.
    func initialSpringVelocity(_ tabBarButton: AZTabBarButton)->CGFloat
    
    
    /// The Spring Damping value.
    ///
    /// - Parameter tabBarButton: The sender.
    /// - Returns: The value of the damping
    func usingSpringWithDamping(_ tabBarButton: AZTabBarButton)->CGFloat
    
    
    /// Function used to decide if the action of the button can be triggered using a long click gesture.
    ///
    /// - Parameter tabBarButton: The sender.
    /// - Returns: True if you wish to enable long-click-gesture for the button.
    func shouldLongClick(_ tabBarButton: AZTabBarButton)->Bool
    
    
    /// Set the duration that takes for the long click gesture to be triggered.
    ///
    /// - Parameter tabBarButton: The sender.
    /// - Returns: The duration that takes for the long click gesture to be triggered.
    func longClickTriggerDuration(_ tabBarButton: AZTabBarButton)-> TimeInterval
    
    
    /// A function that is invoked when long-click gesture occurs.
    ///
    /// - Parameter tabBarButton: The sender.
    func longClickAction(_ tabBarButton: AZTabBarButton)
}
