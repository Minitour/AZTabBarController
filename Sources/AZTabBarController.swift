//
//  ViewController.swift
//  AZTabBarController
//
//  Created by Antonio Zaitoun on 9/13/16.
//  Copyright © 2016 Crofis. All rights reserved.
//

import UIKit

typealias AZTabBarAction = () -> Void
class AZTabBarController: UIViewController {
    
    /*
     *  MARK: - Static instance methods
     */
    
    class func insert(into parent:UIViewController, withTabIconNames: [String])->AZTabBarController {
        let controller = AZTabBarController(withTabIconNames: withTabIconNames)
        parent.addChildViewController(controller)
        parent.view.addSubview(controller.view)
        controller.view.frame = parent.view.bounds
        controller.didMove(toParentViewController: parent)
        
        return controller
    }
    
    class func insert(into parent:UIViewController, withTabIcons: [AnyObject])->AZTabBarController {
        let controller = AZTabBarController(withTabIcons: withTabIcons)
        parent.addChildViewController(controller)
        parent.view.addSubview(controller.view)
        controller.view.frame = parent.view.bounds
        controller.didMove(toParentViewController: parent)
        
        return controller
    }

    /*
     * MARK: - Public Properties
     */
    
    public var selectedColor:UIColor! {
        didSet{
            self.updateInterfaceIfNeeded()
            if selectedIndex >= 0 , let button = (buttons[self.selectedIndex] as? UIButton) {
                button.isSelected = true
            }
        }
    }
    
    public var defaultColor:UIColor! {
        didSet{
            self.updateInterfaceIfNeeded()
            if selectedIndex >= 0 , let button = (buttons[self.selectedIndex] as? UIButton) {
                button.isSelected = true
            }
        }
    }
    
    public var buttonsBackgroundColor:UIColor!{
        didSet{
            if buttonsBackgroundColor != oldValue {
                self.updateInterfaceIfNeeded()
            }
            
        }
    }
    
    public var selectedIndex:Int!
    
    public var separatorLineVisible:Bool = true{
        didSet{
            if separatorLineVisible != oldValue {
                self.setupSeparatorLine()
            }
        }
    }
    
    public var separatorLineColor:UIColor!{
        didSet{
            if self.separatorLine != nil {
                self.separatorLine.backgroundColor = separatorLineColor
            }
        }
    }
    
    public var highlightsSelectedButton:Bool = false
    
    public var selectionIndicatorHeight:CGFloat = 3.0{
        didSet{
            updateInterfaceIfNeeded()
        }
    }
    
    /*
     * MARK: - Internal Properties
     */
    
    @IBOutlet weak var controllersContainer:UIView!
    
    @IBOutlet weak var buttonsContainer:UIView!
    
    @IBOutlet weak var separatorLine:UIView!
    
    @IBOutlet weak var separatorLineHeightConstraint:NSLayoutConstraint!
    
    @IBOutlet weak var buttonsContainerHeightConstraint:NSLayoutConstraint!
    
    internal var buttons:NSMutableArray!
    
    internal var tabIcons:[AnyObject]!
    
    internal var selectionIndicator:UIView!
    
    internal var selectionIndicatorLeadingConstraint:NSLayoutConstraint!
    
    internal var buttonsContainerHeightConstraintInitialConstant:CGFloat!
    
    internal var selectionIndicatorHeightConstraint:NSLayoutConstraint!
    
    /*
     * MARK: - Private Properties
     */
    
    
    
    private var controllers:NSMutableDictionary!
    
    private var actions:NSMutableDictionary!
    
    private var didSetupInterface:Bool = false
    
    private var highlightedButtonIndexes:NSMutableSet!
    
    /*
     * MARK: - Init
     */
    
    init(withTabIcons tabIcons: [AnyObject]) {
        let bundle = Bundle(for: AZTabBarController.self)
        super.init(nibName: "AZTabBarController", bundle: bundle)
        self.initialize(withTabIcons: tabIcons)
        
    
    }
    
    convenience init(withTabIconNames iconNames: [String]) {
        var icons = [AnyObject]()
        for name in iconNames {
            icons.append(UIImage(named: name)!)
        }
        self.init(withTabIcons: icons)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /*
     * MARK: - UIViewController
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonsContainerHeightConstraintInitialConstant = self.buttonsContainerHeightConstraint.constant
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.selectedIndex == -1 {
            // We only setup everything if there isn't any selected index.
            self.setupInterface()
            self.moveToController(at: 0, animated: false)
        }
        
        
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        // When rotating, have to update the selection indicator leading to match
        // the selected button x, that might have changed because of the rotation.
        
        let selectedButtonX: CGFloat = (self.buttons[self.selectedIndex] as! UIButton).frame.origin.x
        if self.selectionIndicatorLeadingConstraint.constant != selectedButtonX {
            UIView.animate(withDuration: 0.1, animations: {() -> Void in
                self.selectionIndicatorLeadingConstraint.constant = selectedButtonX
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    /*
     * MARK: - AZTabBarController
     */
    
    
    public func set(viewController controller: UIViewController, atIndex index: Int) {
        if let currentViewController:UIViewController = (self.controllers[index] as? UIViewController){
            currentViewController.removeFromParentViewController()
        }
        self.controllers[index] = controller
        if index == self.selectedIndex {
            // If the index is the selected one, we have to update the view
            // controller at that index so that the change is reflected.
            self.moveToController(at: index, animated: false)
        }
    }
    
    public func set(selectedIndex index:Int,animated:Bool){
        if self.selectedIndex != index {
            moveToController(at: index, animated: animated)
        }
        
        if let action:AZTabBarAction = actions[index] as? AZTabBarAction {
            action()
        }
    }
    
    public func set(action: AZTabBarAction, atIndex index: Int) {
        self.actions[(index)] = action
    }
    
    public func set(badge: String?, atIndex index:Int){
        if let button = buttons[index] as? UIButton {
            //button.badge(text: badge, badgeEdgeInsets: UIEdgeInsets(top: 5 , left: 15, bottom: 0, right: 0))
            var appearnce = BadgeAppearnce()
            appearnce.distenceFromCenterX = 15
            appearnce.distenceFromCenterY = -10
            
            button.badge(text: badge, appearnce:appearnce)
        }
    }
    
    public func highlightButton(atIndex index: Int) {
        self.highlightedButtonIndexes.add(index)
        self.updateInterfaceIfNeeded()
    }
    
    public func setButtonTintColor(color: UIColor, atIndex index: Int) {
        if !self.highlightedButtonIndexes.contains((index)) {
            let button:UIButton = self.buttons[index] as! UIButton
            button.tintColor! = color
            let buttonImage = button.image(for: .normal)!
            button.setImage(buttonImage.withRenderingMode(.alwaysTemplate), for: .normal)
            button.setImage(buttonImage.withRenderingMode(.alwaysTemplate), for: .selected)
        }
    }
    
    public func setBar(hidden: Bool, animated: Bool) {
        let animations = {() -> Void in
            self.buttonsContainerHeightConstraint.constant = hidden ? 0 : self.buttonsContainerHeightConstraintInitialConstant
            self.view.layoutIfNeeded()
        }
        if animated {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, animations: animations)
        }
        else {
            animations()
        }
    }
    
    
    /*
     * MARK: - Actions
     */

    func tabButtonAction(button:UIButton){
        let index = self.buttons.index(of: button)
        
        if index != NSNotFound {
            self.set(selectedIndex: index, animated: true)
        }
    }
    
    
    /*
     * MARK: - Private methods
     */

    private func initialize(withTabIcons tabIcons:[AnyObject]){
        assert(tabIcons.count > 0, "The array of tab icons shouldn't be empty.")
        
        self.tabIcons = tabIcons
        
        self.controllers = NSMutableDictionary(capacity: tabIcons.count)
        
        self.actions = NSMutableDictionary(capacity: tabIcons.count)
        
        self.highlightedButtonIndexes = NSMutableSet()
        
        self.selectedIndex = -1
        
        self.separatorLineColor = UIColor.lightGray
        
    }
    
    private func updateInterfaceIfNeeded() {
        if self.didSetupInterface {
            // If the UI was already setup, it's necessary to update it.
            self.setupInterface()
        }
    }
    
    private func setupInterface(){
        self.setupButtons()
        self.setupSelectionIndicator()
        self.setupSeparatorLine()
        self.didSetupInterface = true
    }
    
    private func setupButtons(){
        
        if self.buttons == nil {
            self.buttons = NSMutableArray(capacity: self.tabIcons.count)
            
            for i in 0 ..< self.tabIcons.count {
                
                let button:UIButton = self.createButton(forIndex: i)
                
                self.buttonsContainer.addSubview(button)
                
                self.buttons[i] = button
            }
            self.setupButtonsConstraints()
        }
        self.customizeButtons()
        
        self.buttonsContainer.backgroundColor = self.buttonsBackgroundColor != nil ? self.buttonsBackgroundColor : UIColor.lightGray
    }
    
    private func customizeButtons(){
        for i in 0 ..< self.tabIcons.count {
            let button:UIButton = self.buttons[i] as! UIButton
            
            let isHighlighted = self.highlightedButtonIndexes.contains(i)
            
            button.customizeForTabBarWithImage(image: self.tabIcons[i] as! UIImage, selectedColor: self.selectedColor ?? UIColor.black, highlighted: isHighlighted,defaultColor: self.defaultColor ?? UIColor.gray)
        }
    }
    
    private func createButton(forIndex index:Int)-> UIButton{
        let button = UIButton(type: .custom)
        
        button.addTarget(self, action: #selector(AZTabBarController.tabButtonAction(button:)), for: .touchUpInside)
        
        return button
    }
    
    private func moveToController(at index:Int,animated:Bool){
        let subController:UIViewController? = controllers[index] as? UIViewController
        if let controller = subController {
            
            // Deselect all the buttons excepting the selected one.
            for i in 0 ..< self.tabIcons.count{
                
                let button:UIButton = self.buttons[i] as! UIButton
                
                let selected:Bool = i == index
                
                button.isSelected = selected
                
                if self.highlightsSelectedButton && !(self.actions[i] != nil && self.controllers[i] != nil){
                    button.alpha = selected ? 1.0 : 0.5
                }
                
            }
            
            if self.selectedIndex >= 0 {
                let currentController:UIViewController = self.controllers[selectedIndex] as! UIViewController
                currentController.view.removeFromSuperview()
            }
            
            if !self.childViewControllers.contains(controller){
                controller.didMove(toParentViewController: self)
            }
            
            if NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1 {
                // Table views have an issue when disabling autoresizing
                // constraints in iOS 7.
                // Their width is set to zero initially and then it's not able to
                // adjust it again, causing constraint conflicts with the cells
                // inside the table.
                // For this reason, we just adjust the frame to the container
                // bounds leaving the autoresizing constraints enabled.
                
                self.controllersContainer.addSubview(controller.view)
                controller.view.frame = self.controllersContainer.bounds
            }else{
                
                controller.view.translatesAutoresizingMaskIntoConstraints = false
                
                self.controllersContainer.addSubview(controller.view)
                
                
                self.setupConstraints(forChildController: controller)
                
            }
            
            self.moveSelectionIndicator(toIndex: index,animated:animated)
            
            self.selectedIndex = index
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
        self.selectionIndicator.backgroundColor = self.selectedColor ?? UIColor.black
    }
    
    private func setupSeparatorLine() {
        self.separatorLine.backgroundColor = self.separatorLineColor
        self.separatorLine.isHidden = !self.separatorLineVisible
        self.separatorLineHeightConstraint.constant = 0.5
    }
    
    private func moveSelectionIndicator(toIndex index: Int,animated:Bool){
        let constant:CGFloat = (self.buttons[index] as! UIButton).frame.origin.x
        
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


/*
 * MARK: - AutoLayout
 */

fileprivate extension AZTabBarController {
    
    
    /*
     * MARK: - Public Methods
     */
    
    func setupButtonsConstraints(){
        for i in 0 ..< self.tabIcons.count {
            let button:UIButton = self.buttons[i] as! UIButton
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addConstraints(self.leftLayoutConstraintsForButtonAtIndex(index: i))
            self.view.addConstraints(self.verticalLayoutConstraintsForButtonAtIndex(index: i))
            self.view.addConstraint(self.widthLayoutConstraintForButtonAtIndex(index: i))
            self.view.addConstraint(self.heightLayoutConstraintForButtonAtIndex(index: i))
        }
    }
    
    func setupSelectionIndicatorConstraints(){
        self.selectionIndicatorLeadingConstraint = self.leadingLayoutConstraintForIndicator()
        
        self.buttonsContainer.addConstraint(self.selectionIndicatorLeadingConstraint)
        self.buttonsContainer.addConstraints(self.widthLayoutConstraintsForIndicator())
        self.buttonsContainer.addConstraints(self.heightLayoutConstraintsForIndicator())
        self.buttonsContainer.addConstraints(self.bottomLayoutConstraintsForIndicator())
    }
    

    
    func setupConstraints(forChildController controller: UIViewController) {
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": controller.view])
        self.controllersContainer.addConstraints(horizontalConstraints)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": controller.view])
        self.controllersContainer.addConstraints(verticalConstraints)
    }
    
    /*
     * MARK: - Private Methods
     */
    private func leftLayoutConstraintsForButtonAtIndex(index: Int)-> [NSLayoutConstraint]{
        let button:UIButton = self.buttons[index] as! UIButton
        
        var leftConstraints:[NSLayoutConstraint]!
        
        if index == 0 {
            leftConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[button]", options: [], metrics: nil, views: ["button": button])
        }else {
            
            let views = ["previousButton": self.buttons[index - 1], "button": button]
            
            leftConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[previousButton]-(0)-[button]", options: [], metrics: nil, views: views)
            
        }
        return leftConstraints
    }
    
    private func verticalLayoutConstraintsForButtonAtIndex(index: Int)-> [NSLayoutConstraint]{
        let button:UIButton = self.buttons[index] as! UIButton
        
        return NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[button]", options: [], metrics: nil, views: ["button": button])
        
    }
    
    private func widthLayoutConstraintForButtonAtIndex(index: Int)->NSLayoutConstraint {
        let button:UIButton = self.buttons[index] as! UIButton
        
        return NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: self.buttonsContainer, attribute: .width, multiplier: 1.0 / CGFloat(self.buttons.count), constant: 0.0)
    }
    
    private func heightLayoutConstraintForButtonAtIndex(index: Int)-> NSLayoutConstraint {
        let button:UIButton = self.buttons[index] as! UIButton
        
        return NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.buttonsContainerHeightConstraintInitialConstant)
    }
    
    private func leadingLayoutConstraintForIndicator()->NSLayoutConstraint {
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[selectionIndicator]", options: [], metrics: nil, views: ["selectionIndicator": self.selectionIndicator])
        
        return constraints.first!
    }
    
    private func widthLayoutConstraintsForIndicator()-> [NSLayoutConstraint]{
        let views = ["button": self.buttons[0], "selectionIndicator": self.selectionIndicator]
        
        return NSLayoutConstraint.constraints(withVisualFormat: "[selectionIndicator(==button)]", options: [], metrics: nil, views: views)
    }
    
    private func heightLayoutConstraintsForIndicator()-> [NSLayoutConstraint] {
        let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[selectionIndicator(==3)]", options: [], metrics: nil, views: ["selectionIndicator": self.selectionIndicator])
        
        self.selectionIndicatorHeightConstraint = heightConstraints.first!
        
        return heightConstraints
    }
    
    private func bottomLayoutConstraintsForIndicator()-> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: "V:[selectionIndicator]-(0)-|", options: [], metrics: nil, views: ["selectionIndicator": self.selectionIndicator])
    }
}

/*
 * MARK: - Button Extension
 */

fileprivate extension UIButton {
    // MARK: - Public methods
    
    func customizeForTabBarWithImage(image: UIImage, selectedColor: UIColor, highlighted: Bool,defaultColor: UIColor? = UIColor.gray) {
        if highlighted {
            self.customizeAsHighlightedButtonForTabBarWithImage(image: image, selectedColor: selectedColor)
        }
        else {
            self.customizeAsNormalButtonForTabBarWithImage(image: image, selectedColor: selectedColor,defaultColor: defaultColor)
        }
    }
    // MARK: - Private methods
    
    private func customizeAsHighlightedButtonForTabBarWithImage(image: UIImage, selectedColor: UIColor) {
        // We want the image to be always white in highlighted state.
        self.tintColor = UIColor.white
        self.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        // And its background color should always be the selected color.
        self.backgroundColor = selectedColor
    }
    
    private func customizeAsNormalButtonForTabBarWithImage(image: UIImage, selectedColor: UIColor, defaultColor: UIColor? = UIColor.gray) {
        // The tint color is the one used for selected state.
        self.tintColor = selectedColor
        // When the button is not selected, we show the image always with its
        // original color.
        self.setImage(image.imageWithColor(color: defaultColor!), for: .normal)
        
        
        // When the button is selected, we apply the tint color using the
        // always template mode.
        self.setImage(image.imageWithColor(color: selectedColor), for: .selected)
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

/*
 * MARK: - Badge
 */
fileprivate extension UIView {
    
    /*
     * Assign badge with only text.
     */
    func badge(text badgeText: String!) {
        badge(text: badgeText, badgeEdgeInsets: nil,appearnce: BadgeAppearnce())
    }
    
    func badge(text badgeText: String!, appearnce:BadgeAppearnce){
        badge(text: badgeText, badgeEdgeInsets: nil,appearnce: appearnce)
    }
    
    /*
     * Assign badge with text and edge insets.
     */
    func badge(text badgeText:String!,badgeEdgeInsets:UIEdgeInsets){
        badge(text: badgeText, badgeEdgeInsets: badgeEdgeInsets, appearnce: BadgeAppearnce())
    }
    
    /*
     * Assign badge with text,insets, and appearnce.
     */
    func badge(text badgeText:String!,badgeEdgeInsets:UIEdgeInsets!,appearnce:BadgeAppearnce){
        
        //Create badge label
        var badgeLabel:BadgeLabel!
        
        var doesBadgeExist = false
        
        //Find badge in subviews if exists
        for view in self.subviews {
            if view.tag == 1 && view is BadgeLabel{
                badgeLabel = view as! BadgeLabel
            }
        }
        
        //If assigned text is nil (request to remove badge) and badge label is not nil:
        if badgeText == nil && !(badgeLabel == nil){
            
            if appearnce.animate{
                UIView.animate(withDuration: appearnce.duration, animations: {
                    badgeLabel.alpha = 0.0
                    badgeLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    
                    }, completion: { (Bool) in
                        
                        badgeLabel.removeFromSuperview()
                })
            }else{
                badgeLabel.removeFromSuperview()
            }
            return
        }else if badgeText == nil && badgeLabel == nil {
            return
        }
        
        //Badge label is nil (There was no previous badge)
        if (badgeLabel == nil){
            
            //init badge label variable
            badgeLabel = BadgeLabel()
            
            //assign tag to badge label
            badgeLabel.tag = 1
        }else{
            doesBadgeExist = true
        }
        
        //Clip to bounds
        badgeLabel.clipsToBounds = true
        
        //Set the text on the badge label
        badgeLabel.text = badgeText
        
        //Set font size
        badgeLabel.font = UIFont.systemFont(ofSize: appearnce.textSize)
        
        badgeLabel.sizeToFit()
        
        //set the allignment
        badgeLabel.textAlignment = appearnce.textAlignment
        
        //set background color
        badgeLabel.backgroundColor = appearnce.backgroundColor
        
        //set text color
        badgeLabel.textColor = appearnce.textColor
        
        //get current badge size
        let badgeSize = badgeLabel.frame.size
        
        //calculate width and height with minimum height and width of 20
        let height = max(18, Double(badgeSize.height) + 5.0)
        let width = max(height, Double(badgeSize.width) + 10.0)
        
        badgeLabel.frame.size = CGSize(width: width, height: height)
        
        
        //add to subview
        
        if doesBadgeExist {
            //remove view to delete constraints
           badgeLabel.removeFromSuperview()
        }
        addSubview(badgeLabel)
        
        //The distance from the center of the view (vertically)
        let centerY = appearnce.distenceFromCenterY
        
        //The distance from the center of the view (horizontally)
        let centerX = appearnce.distenceFromCenterX
        
        //disable auto resizing mask
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //add height constraint
        self.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(height)))
        
        //add width constraint
        self.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(width)))
        
        //add vertical constraint
        self.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: centerX))
        
        //add horizontal constraint
        self.addConstraint(NSLayoutConstraint(item: badgeLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: centerY))
        
        
        //corner radius
        badgeLabel.layer.cornerRadius = badgeLabel.frame.size.height / 2
        
        //badge does not exist, meaning we are adding a new one
        if !doesBadgeExist {
            
            //should it animate?
            if appearnce.animate {
                UIView.animate(withDuration: appearnce.duration/2, animations: { () -> Void in
                    badgeLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
                }) { (finished: Bool) -> Void in
                    UIView.animate(withDuration: appearnce.duration/2, animations: { () -> Void in
                        badgeLabel.transform = CGAffineTransform.identity
                    })}
            }
        }
    }
    
}

/*
 * BadgeLabel - This class is made to avoid confusion with other subviews that might be of type UILabel.
 */
fileprivate class BadgeLabel:UILabel{
}

/*
 * BadgeAppearnce - This struct is used to design the badge.
 */
fileprivate struct BadgeAppearnce {
    var textSize:CGFloat = 12
    var textAlignment:NSTextAlignment = .center
    var backgroundColor = UIColor.red
    var textColor = UIColor.white
    var animate = true
    var duration = 0.2
    var distenceFromCenterY:CGFloat = 0
    var distenceFromCenterX:CGFloat = 0
    
}















