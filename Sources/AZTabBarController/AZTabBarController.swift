//
//  ViewController.swift
//  AZTabBarController
//
//  Created by Antonio Zaitoun on 9/13/16.
//  Copyright © 2016 Crofis. All rights reserved.
//

import UIKit
import AVFoundation

#if canImport(EasyNotificationBadge)
import EasyNotificationBadge
#endif

public typealias AZTabBarAction = (() -> Void)

open class AZTabBarController: UIViewController {
    
    /*
     *  MARK: - Static instance methods
     */
    
    /// This function creates an instance of AZTabBarController using the specifed icons and inserts it into the provided view controller.
    ///
    /// - Parameters:
    ///   - parent: The controller which we are inserting our Tab Bar controller into.
    ///   - names: An array which contains the names of the icons that will be displayed as default.
    ///   - sNames: An optional array which contains the names of the icons that will be displayed when the menu is selected.
    /// - Returns: The instance of AZTabBarController which was created.
    open class func insert(into parent:UIViewController, withTabIconNames names: [String],andSelectedIconNames sNames: [String]? = nil)->AZTabBarController {
        let controller = AZTabBarController(withTabIconNames: names,highlightedIcons: sNames)
        parent.addChild(controller)
        parent.view.addSubview(controller.view)
        controller.view.frame = parent.view.bounds
        controller.didMove(toParent: parent)
        
        return controller
    }
    
    
    /// This function creates an instance of AZTabBarController using the specifed icons and inserts it into the provided view controller.
    ///
    /// - Parameters:
    ///   - parent: The controller which we are inserting our Tab Bar controller into.
    ///   - icons: An array which contains the images of the icons that will be displayed as default.
    ///   - sIcons: An optional array which contains the images of the icons that will be displayed when the menu is selected.
    /// - Returns: The instance of AZTabBarController which was created.
    open class func insert(into parent:UIViewController, withTabIcons icons: [UIImage],andSelectedIcons sIcons: [UIImage]? = nil)->AZTabBarController {
        let controller = AZTabBarController(withTabIcons: icons,highlightedIcons: sIcons)
        parent.addChild(controller)
        parent.view.addSubview(controller.view)
        controller.view.frame = parent.view.bounds
        controller.didMove(toParent: parent)
        return controller
    }
    
    /*
     * MARK: - Public Properties
     */
    
    /// The color of icon in the tab bar when the menu is selected.
    open var selectedColor:UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) {
        didSet{
            updateInterfaceIfNeeded()
            if didSetUpInterface {
                buttons[self.selectedIndex].isSelected = true
            }
        }
    }
    
    
    /// The default icon color of the buttons in the tab bar.
    open var defaultColor:UIColor = .lightGray {
        didSet{
            updateInterfaceIfNeeded()
            if didSetUpInterface {
                buttons[self.selectedIndex].isSelected = true
            }
        }
    }

    /// The tint color of the button when highlighted.
    open var highlightColor: UIColor = .white {
        didSet{
            updateInterfaceIfNeeded()
            if didSetUpInterface {
                buttons[self.selectedIndex].isSelected = true
            }
        }
    }
    
    /// The background color of a highlighted button.
    open var highlightedBackgroundColor: UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) {
        didSet{
            updateInterfaceIfNeeded()
            if didSetUpInterface {
                buttons[self.selectedIndex].isSelected = true
            }
        }
    }
    
    /// The color of the selection indicator.
    open var selectionIndicatorColor: UIColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1) {
        didSet{
            self.updateInterfaceIfNeeded()
            if didSetUpInterface {
                buttons[self.selectedIndex].isSelected = true
            }
        }
    }
    
    /// The background color of the buttons in the tab bar.
    open var buttonsBackgroundColor:UIColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1) {
        didSet{
            if buttonsBackgroundColor != oldValue {
                self.updateInterfaceIfNeeded()
            }
            
        }
    }
    
    /// When setting this to true, The tab bar will display the icons with their orignal colors instead of template color.
    open var ignoreIconColors: Bool = false {
        didSet{
            updateInterfaceIfNeeded()
            if didSetUpInterface {
                buttons[self.selectedIndex].isSelected = true
            }
        }
    }
    
    /// Should the tab bar have animated transitions enabled?
    open var animateTabChange: Bool = false
    
    /// The current selected index.
    fileprivate (set) open var selectedIndex:Int!
    
    /// Is the tab bar in the middle of an animation.
    fileprivate (set) open var isAnimating: Bool = false
    
    /// If the separator line view that is between the buttons container and the primary view container is visable.
    open var separatorLineVisible:Bool = true{
        didSet{
            if separatorLineVisible != oldValue {
                self.setupSeparatorLine()
            }
        }
    }
    
    /// The color of the separator.
    open var separatorLineColor:UIColor!{
        didSet{
            if self.separatorLine != nil {
                self.separatorLine.backgroundColor = separatorLineColor
            }
        }
    }
    
    /// Change the alpha of the deselected menus that do not have actions set on them to 0.5
    open var highlightsSelectedButton:Bool = false
    
    /// The appearance of the notification badge.
    open var notificationBadgeAppearance: BadgeAppearance = BadgeAppearance()
    
    /// The height of the selection indicator.
    open var selectionIndicatorHeight:CGFloat = 1.0{
        didSet{
            updateInterfaceIfNeeded()
        }
    }
    
    /// Set the tab bar height.
    open var tabBarHeight: CGFloat{
        get{
            return self.buttonsContainerHeightConstraintInitialConstant
        }set{
            let safeAreaBottom: CGFloat
            if #available(iOS 11.0, *){
                safeAreaBottom = view.safeAreaInsets.bottom
            }else{
                safeAreaBottom = 0.0
            }

            self.buttonsContainerHeightConstraintInitialConstant = newValue
            self.buttonsContainerHeightConstraint.constant = newValue + safeAreaBottom
        }
    }
    
    /// If you are setting a text for each menu using the function `setTitle(_:_:)`, you can decide how the text will be presented. When the value of this variable is false, then all titles will be visable. However if it is true, then only the title of the selected index is visale.
    open var onlyShowTextForSelectedButtons: Bool = false{
        didSet{
            updateInterfaceIfNeeded()
        }
    }
    
    /// The UIFont for the buttons.
    open var font: UIFont? = UIFont.systemFont(ofSize: 12){
        didSet{
            updateInterfaceIfNeeded()
        }
    }

    /// Returns the current controller if exists.
    public var currentTab: UIViewController? {
        if selectedIndex >= 0,selectedIndex < tabCount, let controller = controllers[selectedIndex] { return controller }
        return nil
    }
    
    /// The duration that is needed to invoke a long click.
    open var longClickTriggerDuration: TimeInterval = 0.5
    
    /// The duration of the starting animation.
    open var iconStartAnimationDuration: TimeInterval = 0.2
    
    /// The duration of the ending (spring) animation.
    open var iconEndAnimationDuration: TimeInterval = 0.25
    
    /// The duration of the animation of the selection indicator's movement.
    open var selectionIndicatorAnimationDuration: TimeInterval = 0.25
    
    /// Spring damping.
    open var iconSpringWithDamping: CGFloat = 0.2
    
    /// Initial spring velocity.
    open var iconInitialSpringVelocity: CGFloat = 6.0
    
    /// The AZTabBar Delegate
    open weak var delegate: AZTabBarDelegate?
    
    
    /*
     * MARK: - Internal Properties
     */
    
    override open var preferredStatusBarStyle: UIStatusBarStyle{
        return self.statusBarStyle
    }
    
    override open var childForStatusBarStyle: UIViewController?{
        return nil
    }
    
    /// A var to change the status bar appearnce
    internal var statusBarStyle: UIStatusBarStyle = .default{
        didSet{
            if oldValue != statusBarStyle {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    /// The view that holds the views of the controllers.
    fileprivate (set) public var controllersContainer:UIView!
    
    /// The view that holds the stack and selection indicator
    fileprivate (set) public var buttonsContainer:UIView!
    
    /// The stack view that holds the buttons
    fileprivate var buttonsStackView: UIStackView!
    
    /// The separator line between the controllers container and the buttons container.
    fileprivate var separatorLine:UIView!
    
    /// NSLayoutConstraint of the height of the seperator line.
    fileprivate var separatorLineHeightConstraint:NSLayoutConstraint!
    
    /// NSLayoutConstraint of the height of the button container.
    fileprivate var buttonsContainerHeightConstraint:NSLayoutConstraint!
    
    /// Array which holds the buttons.
    internal var buttons: [UIButton]!
    
    /// Array which holds the default tab icons.
    internal var tabIcons: [UIImage]!
    
    /// Optional Array which holds the highlighted tab icons.
    internal var selectedTabIcons: [UIImage]?
    
    /// The view that goes inside the buttons container and indicates which menu is selected.
    internal (set) public var selectionIndicator:UIView!
    
    internal var selectionIndicatorLeadingConstraint:NSLayoutConstraint!
    
    internal var buttonsContainerHeightConstraintInitialConstant:CGFloat!
    
    internal var selectionIndicatorHeightConstraint:NSLayoutConstraint!
    
    /*
     * MARK: - Private Properties
     */
    
    /// Array which holds the controllers.
    fileprivate var controllers: [UIViewController?]!

    /// Array which holds the actions.
    fileprivate var actions: [AZTabBarAction?]!
    

    
    /// An array which keeps track of the highlighted menus.
    fileprivate var highlightedButtonIndexes:NSMutableSet!
    
    /// Array that holds the badge values. it is used only before the controller is displayed.
    fileprivate var badgeValues: [String?]!
    
    /// Computed var that returns the amount of tabs.
    fileprivate var tabCount: Int { return tabIcons.count }
    
    /// A flag that marks if the interface was setup or not.
    fileprivate var didSetUpInterface = false
    
    /// An array that holds text values before controller is displayed.
    fileprivate lazy var buttonsText: [String?] = Array<String?>(repeating: nil, count: self.tabCount)

    fileprivate lazy var buttonsColors: [UIColor?] = Array<UIColor?>(repeating: nil,count: self.tabCount)

    fileprivate var isRTL: Bool {
        return UIApplication.shared.userInterfaceLayoutDirection == UIUserInterfaceLayoutDirection.rightToLeft
    }
    
    /*
     * MARK: - Init
     */
    
    override open func loadView() {
        super.loadView()
        
        //init primary views
        controllersContainer = UIView()
        buttonsContainer = UIView()
        buttonsStackView = UIStackView()
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillEqually
        separatorLine = UIView()
        
        
        //add in correct hierachy
        view.addSubview(controllersContainer)
        view.addSubview(buttonsContainer)
        view.addSubview(separatorLine)
        buttonsContainer.addSubview(buttonsStackView)
        
        //disable autoresizing mask
        controllersContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        //setup constraints
        buttonsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        buttonsContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        buttonsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        buttonsContainer.topAnchor.constraint(equalTo: self.controllersContainer.bottomAnchor).isActive = true
        buttonsContainer.topAnchor.constraint(equalTo: self.separatorLine.topAnchor).isActive = true
        buttonsContainerHeightConstraint = self.buttonsContainer.heightAnchor.constraint(equalToConstant: 50)
        buttonsContainerHeightConstraint.isActive = true
        
        separatorLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        separatorLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        separatorLineHeightConstraint = separatorLine.heightAnchor.constraint(equalToConstant: 1)
        separatorLineHeightConstraint.isActive = true
        
        controllersContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        controllersContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        controllersContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    /// Public initializer that creates a controller using tabIcons and (optional) highlightedIcons.
    ///
    /// - Parameters:
    ///   - tabIcons: The default icons of the tabs.
    ///   - highlightedIcons: The icons of the tabs when selected.
    public init(withTabIcons tabIcons: [UIImage],highlightedIcons: [UIImage]? = nil) {
        super.init(nibName: nil,bundle: nil)
        self.initialize(withTabIcons: tabIcons,highlightedIcons: highlightedIcons)
    }
    
    
    /// Public initializer that creates a controller using tabIcons and (optional) highlightedIcon names.
    ///
    /// - Parameters:
    ///   - iconNames: The names of the icons.
    ///   - highlightedIcons: The names of the highlighted icons.
    public convenience init(withTabIconNames iconNames: [String],highlightedIcons: [String]? = nil) {
        var icons = [UIImage]()
        for name in iconNames {
            icons.append(UIImage(named: name)!)
        }
        
        var highlighted: [UIImage]?
        if let imageNames = highlightedIcons{
            highlighted = [UIImage]()
            for name in imageNames{
                highlighted?.append(UIImage(named: name)!)
            }
        }
        
        self.init(withTabIcons: icons,highlightedIcons: highlighted)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     * MARK: - UIViewController
     */
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.buttonsContainerHeightConstraintInitialConstant = self.buttonsContainerHeightConstraint.constant
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Setup interface if didn't already
        if !didSetUpInterface {
            self.setupInterface()
            self.moveToController(at: selectedIndex, animated: false)
            
            //add badges if needed
            if let badgeValues = badgeValues {
                for i in 0..<badgeValues.count{
                    if let value = badgeValues[i]{
                        self.setBadgeText(value, atIndex: i)
                    }
                }
                self.badgeValues = nil
            }
            
            for i in 0..<buttonsText.count{
                setTitle(buttonsText[i], atIndex: i)
            }
            
            //mark interface as ready
            didSetUpInterface = true
        }
    }
    
    override open func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        let selectedButtonX: CGFloat = self.buttons[self.selectedIndex].frame.origin.x
        self.selectionIndicatorLeadingConstraint.constant = selectedButtonX
    }

    override open func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
            tabBarHeight = buttonsContainerHeightConstraintInitialConstant
        }
    }
    
    /*
     * MARK: - AZTabBarController
     */
    
    /// Set a UIViewController at an index.
    ///
    /// - Parameters:
    ///   - controller: The view controller which you wish to display at a certain index.
    ///   - index: The index of the menu.
    open func setViewController(_ controller: UIViewController, atIndex index: Int) {
        
        if index >= tabCount { return }
        
        if let currentViewController = self.controllers[index]{
            currentViewController.removeFromParent()
            if index == selectedIndex {
                currentViewController.view.removeFromSuperview()
            }
        }
        self.controllers[index] = controller
        self.addChild(controller)
        if index == self.selectedIndex {
            // If the index is the selected one, we have to update the view
            // controller at that index so that the change is reflected.
            self.moveToController(at: index, animated: false)
        }
    }
    
    
    /// Remove view controller at a given index. This won't work if you are trying to remove a view controller at a current index.
    ///
    /// - Parameter index: The index of which you want to remove the view controller
    open func removeViewController(atIndex index: Int){
        //possible exceptions: IOOBException, removing current view
        if index >= tabCount { return }
        
        if selectedIndex == index { return }
        
        if let currentVC = controllers[index] {
            currentVC.removeFromParent()
        }
        
        controllers[index] = nil
    }
    
    
    /// Change the current menu programatically.
    ///
    /// - Parameters:
    ///   - index: The index of the menu.
    ///   - animated: animate the selection indicator or not.
    open func setIndex(_ index:Int,animated: Bool = true){
        
        if index >= tabCount { return }
        
        if self.selectedIndex != index { moveToController(at: index, animated: animated) }
        
        if let action = actions[index] { action() }
    }
    
    
    /// Set an action at a certain index.
    ///
    /// - Parameters:
    ///   - action: A closure which contains the action that will be executed when clicking the menu at a certain index.
    ///   - index: The index of the menu of which you would like to add an action to.
    open func setAction(atIndex index: Int, action: @escaping AZTabBarAction) {
        
        if index >= tabCount { return }
        
        self.actions[(index)] = action
    }
    
    
    /// Remove an action from an index.
    ///
    /// - Parameter index: The index at which you wish to remove the action.
    open func removeAction(atIndex index: Int){
        
        if index >= tabCount { return }
        
        self.actions[index] = nil
    }
    
    
    /// Set a badge with a text on a menu at a certain index. In order to remove an existing badge use `nil` for the `text` parameter.
    ///
    /// - Parameters:
    ///   - text: The text you wish to set.
    ///   - index: The index of the menu in which you would like to add the badge.
    open func setBadgeText(_ text: String?, atIndex index:Int){
        if let buttons = buttons{
            if index < buttons.count{
                self.notificationBadgeAppearance.distanceFromCenterX = 15
                self.notificationBadgeAppearance.distanceFromCenterY = -10
                let button = buttons[index] as! AZTabBarButton
                button.addBadge(text: text, appearance: notificationBadgeAppearance)
            }
        }else{
            self.badgeValues[index] = text
        }
    }
    
    
    /// Add text
    ///
    /// - Parameters:
    ///   - text: The text to set.
    ///   - index: The index at which you would like to set the title.
    open func setTitle(_ text: String?, atIndex index: Int, titleColor: UIColor? = nil){

        // unwarp buttons
        guard let buttons = buttons else {
            self.buttonsText[index] = text
            return
        }

        // check if index is in bounds
        guard index < buttons.count, index >= 0 else { return }

        // get button
        let button = buttons[index]
        
        let color: UIColor

        if let titleColor = titleColor { color = titleColor }
        else { color = selectedColor }


        // case `selected` use buttonsColors[index] or `color` if not found.
        button.setTitleColor(buttonsColors[index] ?? color, for: .selected)

        // case `selected` and `highlighted` use buttonsColors[index] or `color` if not found.
        button.setTitleColor(buttonsColors[index] ?? color, for: [.selected,.highlighted])

        // any other case use `self.defaultColor`.
        button.setTitleColor(defaultColor, for: [])

        if onlyShowTextForSelectedButtons {
            button.setTitle(nil, for: .normal)
            button.setTitle(nil, for: .highlighted)
            button.setTitle(text, for: .selected)
            button.setTitle(text, for: [.selected,.highlighted])

        }else{
            button.setTitle(text, for: [])
        }

        if self.highlightedButtonIndexes.contains(index) {
            button.setTitleColor(titleColor ?? highlightColor, for: .selected)
            button.setTitleColor(titleColor ?? highlightColor, for: [.selected,.highlighted])
            button.setTitleColor(titleColor ?? highlightColor, for: [])
        }
    }
    
    
    /// Get the title at a certain index
    ///
    /// - Parameter index: The index of which you would like to get the title.
    /// - Returns: The title.
    open func getTitle(atIndex index: Int)-> String?{
        if let buttons = buttons{
            if index < buttons.count{
                let button = buttons[index]
                return button.title(for: []) ?? button.title(for: .selected)
            }else{
                return nil
            }
        }else{
            if index < buttonsText.count {
                return self.buttonsText[index]
            }else{
                return nil
            }
            
        }
    }

    
    /// Make a button look highlighted.
    ///
    /// - Parameter index: The index of the button which you would like to highlight.
    open func highlightButton(atIndex index: Int) {
        self.highlightedButtonIndexes.add(index)
        self.updateInterfaceIfNeeded()
    }
    
    
    /// Make button normal again.
    ///
    /// - Parameter index: The index of the button which you would like to un-highlight.
    open func removeHighlight(atIndex index: Int) {
        self.highlightedButtonIndexes.remove(index)
        self.updateInterfaceIfNeeded()
    }
    
    
    /// Set a tint color for a button at a certain index.
    ///
    /// - Parameters:
    ///   - color: The color which you would like to set as tint color for the button at a certain index.
    ///   - index: The index of the button.
    open func setButtonTintColor(color: UIColor, atIndex index: Int) {
        buttonsColors[index] = color
        updateInterfaceIfNeeded()
    }
    
    
    /// Show and hide the tab bar.
    ///
    /// - Parameters:
    ///   - hidden: To hide or show.
    ///   - animated: To animate or not.
    ///   - duration: The duration of the animation.
    ///   - completion: The completion handler that is called once the animation is completed.
    open func setBar(hidden: Bool, animated: Bool,duration: TimeInterval = 0.3, completion: ((Bool)->Void)? = nil) {
        let animations = {() -> Void in
            let safeAreaBottom: CGFloat

            if #available(iOS 11.0, *){
                safeAreaBottom = self.view.safeAreaInsets.bottom
            }else{
                safeAreaBottom = 0.0
            }

            self.buttonsContainerHeightConstraint.constant = hidden ? 0.0 : self.buttonsContainerHeightConstraintInitialConstant + safeAreaBottom
            self.view.layoutIfNeeded()
        }
        if animated {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: duration, animations: animations, completion: completion)
        }
        else {
            animations()
        }
    }
    
    
    /// Insert a tab at a certain index
    ///
    /// - Parameters:
    ///   - index: The index of the new tab.
    ///   - icon: The default icon of the tab
    ///   - selectedIcon: The highlighted (selected) icon of the tab
    ///   - animated: Add the button with animation.
    ///   - duration: The duration of the animation, default is 0.2
    ///   - completion: The completion block of the animation.
    open func insertTab(atIndex index: Int,icon: UIImage, selectedIcon: UIImage? = nil,
                        animated: Bool = false, duration: TimeInterval = 0.2, completion: ((Bool)->Void)? = nil){
        //create button
        let button = createButton(forIndex: index)
        button.setTitle(nil, for: [])
        if buttons != nil{
            buttons.insert(button, at: index)
            //sync buttons tag
            for i in 0..<buttons.count{ buttons[i].tag = i }
        }
        
        if index <= buttonsStackView.arrangedSubviews.count {
            
            button.isHidden = true
            let animations: ()->Void = { [weak self] in
                self?.buttonsStackView.insertArrangedSubview(button, at: index)
                button.isHidden = false
            }
            
            if animated {
                UIView.animate(withDuration: duration, animations: animations, completion: completion)
            }else{
                animations()
                completion?(false)
            }
            
        }
        
        if selectedIndex >= index {
            selectedIndex! += 1
        }
        
        //shift icons array
        self.tabIcons.insert(icon, at: index)
        
        //shift selected icons array
        self.selectedTabIcons?.insert(selectedIcon ?? icon, at: index)
        
        //shift controllers array
        self.controllers.insert(nil, at: index)
        
        //shift actions array
        self.actions.insert(nil, at: index)
        
        moveSelectionIndicator(toIndex: selectedIndex, animated: false)
        
        updateInterfaceIfNeeded()
    }
    
    
    /// Remove a tab at a certain index. This will not work if attempted to remove at index that equals to the selected index.
    ///
    /// - Parameter index: The index of the tab to remove.
    open func removeTab(atIndex index: Int,animated: Bool = false, duration: TimeInterval = 0.2, completion: ((Bool)->Void)? = nil){
        
        if selectedIndex == index || index >= buttons.count {
            return
        }
        
        if buttons != nil {
            let button = buttons.remove(at: index)
            
            let aCompletion: (Bool)->Void = { (bool) in
                button.removeFromSuperview()
                completion?(bool)
            }
            
            if animated {
                UIView.animate(withDuration: duration, animations: {
                    button.isHidden = true
                },completion: completion)
            }else{
                aCompletion(false)
            }
            
            for i in 0..<buttons.count{ buttons[i].tag = i }
        }
        
        if selectedIndex >= index {
            selectedIndex! -= 1
        }
        
        tabIcons.remove(at: index)
        selectedTabIcons?.remove(at: index)
        controllers.remove(at: index)
        actions.remove(at: index)
        
        moveSelectionIndicator(toIndex: selectedIndex, animated: false)
        
        updateInterfaceIfNeeded()
    }
    
    
    /// Change the tab icon at a certain index.
    ///
    /// - Parameters:
    ///   - index: The index of which you would like to change the icon image.
    ///   - normal: The default icon.
    ///   - selected: The highlighted (selected) icon.
    open func setTabIcon(forIndex index: Int, normal: UIImage,selected: UIImage? = nil){
        self.tabIcons?[index] = normal
        self.selectedTabIcons?[index] = selected ?? normal
        updateInterfaceIfNeeded()
    }
    
    /*
     * MARK: - Actions
     */
    
    @objc func tabButtonAction(button:UIButton){
        if let index = self.buttons.firstIndex(of: button){
        	delegate?.tabBar(self, didSelectTabAtIndex: index)
        
            if let id = delegate?.tabBar(self, systemSoundIdForButtonAtIndex: index), !isAnimating{
                AudioServicesPlaySystemSound(id)
            }
        
            if index != NSNotFound {
                self.setIndex(index, animated: true)
            }
        }
    }
    
    func longClick(sender:AnyObject?){
        let button = sender as! UIButton
        if let index = self.buttons.firstIndex(of: button){
        
            if let delegate = delegate{
                if !delegate.tabBar(self, shouldLongClickForIndex: index) {
                    return
                }
            }
        
            delegate?.tabBar(self, didLongClickTabAtIndex: index)
        
        
            if selectedIndex != index {
                tabButtonAction(button: button)
            }
        }
        
    }
    
    /*
     * MARK: - Private methods
     */
    
    private func initialize(withTabIcons tabIcons:[UIImage],highlightedIcons: [UIImage]? = nil){
        assert(tabIcons.count > 0, "The array of tab icons shouldn't be empty.")
        
        if let highlightedIcons = highlightedIcons {
            assert(tabIcons.count == highlightedIcons.count,"Default and highlighted icons must come in pairs.")
        }
        
        self.badgeValues = [String?](repeating: nil, count: tabIcons.count)
        
        self.tabIcons = tabIcons
        
        self.selectedTabIcons = highlightedIcons
        
        self.controllers = [UIViewController?](repeating: nil, count: tabIcons.count)
        
        self.actions = [AZTabBarAction?](repeating: nil, count: tabIcons.count)
        
        self.highlightedButtonIndexes = NSMutableSet()
        
        self.selectedIndex = 0
        
        self.separatorLineColor = UIColor.lightGray
        
        self.modalPresentationCapturesStatusBarAppearance = true
        
    }
    
    private func updateInterfaceIfNeeded() {
        if self.didSetUpInterface {
            // If the UI was already setup, it's necessary to update it.
            self.setupInterface()
        }
    }
    
    private func setupInterface(){
        self.setupButtons()
        self.setupSelectionIndicator()
        self.setupSeparatorLine()
        self.didSetUpInterface = true
    }
    
    private func setupButtons(){
        
        if self.buttons == nil {
            self.buttons = [UIButton]()//NSMutableArray(capacity: self.tabIcons.count)
            
            for i in 0 ..< self.tabIcons.count {
                
                let button:UIButton = self.createButton(forIndex: i)
                
                self.buttonsStackView.addArrangedSubview(button)
                
                //self.buttons[i] = button
                buttons.append(button)
            }
            //self.setupButtonsConstraints()
            setupStackConstraints()
        }
        self.customizeButtons()
        
        self.buttonsContainer.backgroundColor = self.buttonsBackgroundColor
    }
    
    private func customizeButtons(){
        for i in 0 ..< self.tabIcons.count {
            let button:AZTabBarButton = self.buttons[i] as! AZTabBarButton
            
            
            let isHighlighted = self.highlightedButtonIndexes.contains(i)
            
            var highlightedImage: UIImage?
            if let selectedImages = self.selectedTabIcons {
                highlightedImage = selectedImages[i]
            }
            
            var color: UIColor!
            
            if isHighlighted{
                color = self.highlightedBackgroundColor
            }else{
                color = buttonsColors[i] ?? self.selectedColor
            }
            
            button.titleLabel?.font = font
            
            button.setTitleColor(buttonsColors[i] ?? selectedColor, for: .selected)
            button.setTitleColor(buttonsColors[i] ?? selectedColor, for: [.selected,.highlighted])
            button.setTitleColor(defaultColor, for: [])
            
            let title: String? = button.title(for: []) ?? button.title(for: .selected)
            
            if onlyShowTextForSelectedButtons {
                button.setTitle(nil, for: .normal)
                button.setTitle(nil, for: .highlighted)
                button.setTitle(title, for: .selected)
                button.setTitle(title, for: [.selected,.highlighted])
                
            }else{
                button.setTitle(title, for: [])
            }
            
            button.customizeForTabBarWithImage(self.tabIcons[i],
                                               highlightImage: highlightedImage,
                                               selectedColor: color,
                                               highlighted: isHighlighted,
                                               defaultColor: self.defaultColor,
                                               highlightColor: buttonsColors[i] ?? self.highlightColor,
                                               ignoreColor: ignoreIconColors)
        }
    }
    
    private func createButton(forIndex index:Int)-> UIButton{
        let button = AZTabBarButton(type: .custom)
        button.setTitle(" ", for: [])
        button.delegate = self
        button.tag = index
        button.isExclusiveTouch = true
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(self.tabButtonAction(button:)), for: .touchUpInside)
        return button
    }
    
    private func moveToController(at index:Int,animated:Bool){
        
        if let controller = controllers[index], !(animated && isAnimating) {
            
            if let shouldMove = delegate?.tabBar(self, shouldMoveToTabAtIndex: index), shouldMove == false{
                return
            }
            
            if buttons == nil{
                selectedIndex = index
                return
            }
            
            // Deselect all the buttons excepting the selected one.
            for i in 0 ..< self.tabIcons.count{
                
                let button:UIButton = self.buttons[i]
                
                let selected:Bool = i == index
                
                button.isSelected = selected
                
                if self.highlightsSelectedButton && !(self.actions[i] != nil && self.controllers[i] != nil){
                    button.alpha = selected ? 1.0 : 0.5
                }
                
            }
            
            delegate?.tabBar(self, willMoveToTabAtIndex: index)
            
            
            var currentViewControllerView: UIView?
            
            if self.selectedIndex >= 0 {
                if let currentController:UIViewController = self.controllers[selectedIndex] {
                    currentViewControllerView = currentController.view
                    if !animateTabChange {
                        currentController.view.removeFromSuperview()
                    }
                }
            }
            
            controller.willMove(toParent: self)
            
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            self.controllersContainer.addSubview(controller.view)
            self.setupConstraints(forChildController: controller)
            
            controller.didMove(toParent: self)
            
            if let currentViewControllerView = currentViewControllerView, animated, animateTabChange {
                //animate
                    
                let offset: CGFloat = self.view.frame.size.width / 5
                let startX = (index > selectedIndex ? offset : -offset) * (isRTL ? -1 : 1)

                controller.view.transform = CGAffineTransform(translationX: startX, y: 0)
                controller.view.alpha = 0
                    
                UIView.animate(withDuration: 0.2, animations: {
                    self.isAnimating = true
                    controller.view.transform = .identity
                    controller.view.alpha = 1
                    currentViewControllerView.transform = CGAffineTransform(translationX: -startX, y: 0)
                }, completion: { (bool) in
                    self.isAnimating = false
                    currentViewControllerView.removeFromSuperview()
                })
                self.moveSelectionIndicator(toIndex: index,animated: animated)
            }else{
                self.moveSelectionIndicator(toIndex: index,animated: false)
            }

            self.selectedIndex = index
            delegate?.tabBar(self, didMoveToTabAtIndex: index)
            self.statusBarStyle = delegate?.tabBar(self, statusBarStyleForIndex: index) ?? .default
        }
        
    }
    
    private func setupSelectionIndicator() {
        if self.selectionIndicator == nil {
            self.selectionIndicator = UIView()
            self.selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
            self.buttonsContainer.addSubview(self.selectionIndicator)
            self.setupSelectionIndicatorConstraints()
        }
        self.selectionIndicatorHeightConstraint.constant = self.selectionIndicatorHeight
        self.selectionIndicator.backgroundColor = self.selectionIndicatorColor
    }
    
    private func setupSeparatorLine() {
        self.separatorLine.backgroundColor = self.separatorLineColor
        self.separatorLine.isHidden = !self.separatorLineVisible
        self.separatorLineHeightConstraint.constant = 0.5
    }
    
    private func moveSelectionIndicator(toIndex index: Int,animated:Bool){
        
        if selectionIndicatorLeadingConstraint == nil{
            return
        }
        
        //let constant:CGFloat = (self.buttons[index] as! UIButton).frame.origin.x
        let constant: CGFloat = ((buttonsContainer.frame.size.width / CGFloat(tabCount)) * CGFloat(index))
        
        self.buttonsContainer.layoutIfNeeded()
        
        let animations = {() -> Void in
            self.selectionIndicatorLeadingConstraint.constant = constant
            self.buttonsContainer.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: animations, completion: { _ in })
        }
        else {
            animations()
        }
    }
}

extension AZTabBarController: AZTabBarButtonDelegate{
    
    public func beginAnimationDuration(_ tabBarButton: AZTabBarButton) -> TimeInterval {
        return self.iconStartAnimationDuration
    }
    
    public func endAnimationDuration(_ tabBarButton: AZTabBarButton) -> TimeInterval {
        return self.iconEndAnimationDuration
    }

    public func usingSpringWithDamping(_ tabBarButton: AZTabBarButton) -> CGFloat {
        return self.iconSpringWithDamping
    }

    public func initialSpringVelocity(_ tabBarButton: AZTabBarButton) -> CGFloat {
        return self.iconInitialSpringVelocity
    }
    
    public func longClickTriggerDuration(_ tabBarButton: AZTabBarButton) -> TimeInterval {
        return self.longClickTriggerDuration
    }

    public func longClickAction(_ tabBarButton: AZTabBarButton) {
        self.longClick(sender: tabBarButton)
    }

    public func shouldLongClick(_ tabBarButton: AZTabBarButton) -> Bool {
        return delegate?.tabBar(self, shouldLongClickForIndex: tabBarButton.tag) ?? false
    }

    public func shouldAnimate(_ tabBarButton: AZTabBarButton) -> Bool {
        if tabBarButton.tag == selectedIndex || self.highlightedButtonIndexes.contains(tabBarButton.tag) || isAnimating{
            return false
        }
        return delegate?.tabBar(self, shouldAnimateButtonInteractionAtIndex: tabBarButton.tag) ?? false
    }
}

/*
 * MARK: - AutoLayout
 */

fileprivate extension AZTabBarController {
    
    func setupStackConstraints(){
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.heightAnchor.constraint(equalToConstant: buttonsContainerHeightConstraintInitialConstant).isActive = true
        buttonsStackView.rightAnchor.constraint(equalTo: buttonsContainer.rightAnchor).isActive = true
        buttonsStackView.leftAnchor.constraint(equalTo: buttonsContainer.leftAnchor).isActive = true
        buttonsStackView.topAnchor.constraint(equalTo: buttonsContainer.topAnchor).isActive = true
    }
    
    func setupSelectionIndicatorConstraints(){
        selectionIndicatorLeadingConstraint = selectionIndicator.leadingAnchor.constraint(equalTo: buttonsContainer.leadingAnchor)
        selectionIndicatorHeightConstraint = selectionIndicator.heightAnchor.constraint(equalToConstant: 3)
        selectionIndicatorLeadingConstraint.isActive = true
        selectionIndicator.widthAnchor.constraint(equalTo: buttons[0].widthAnchor, multiplier: 1.0).isActive = true
        selectionIndicatorHeightConstraint.isActive = true
        selectionIndicator.bottomAnchor.constraint(equalTo: buttonsStackView.bottomAnchor).isActive = true
    }
    
    func setupConstraints(forChildController controller: UIViewController) {
        let subView = controller.view
        subView?.translatesAutoresizingMaskIntoConstraints = false
        subView?.topAnchor.constraint(equalTo: controllersContainer.topAnchor).isActive = true
        subView?.leftAnchor.constraint(equalTo: controllersContainer.leftAnchor).isActive = true
        subView?.bottomAnchor.constraint(equalTo: controllersContainer.bottomAnchor).isActive = true
        subView?.rightAnchor.constraint(equalTo: controllersContainer.rightAnchor).isActive = true
    }
}


public extension UIViewController{

    /// The current tab bar in which this controller is a child of.
    var currentTabBar: AZTabBarController?{
        var current: UIViewController? = parent
        
        repeat{
            if current is AZTabBarController { return current as? AZTabBarController }
            current = current?.parent
        }while current != nil
        
        return nil
    }
}



