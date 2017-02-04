# AZTabBarController
A custom tab bar controller for iOS written in Swift 3.0

##Live Demo
Checkout the live demo on [Appetize](https://appetize.io/app/dmbky73efrt5uvkh4xfdaz5axr?device=iphone6s&scale=75&orientation=portrait&osVersion=9.2)

##Screenshots

<img src="Screenshots/aztabbar.gif" height="100" />

##Installation


###Cocoa Pods:

```bash
pod 'AZTabBar'
```

###Manual:

Simply drag and drop the ```Sources``` folder to your project.

##Usage

Create an array of String/UIImage:
```swift
//The icons that will be displayed on the tabs that are not currently selected
var icons = [String]()
icons.append("ic_star_outline")
icons.append("ic_history_outline")
icons.append("ic_phone_outline")
icons.append("ic_chat_outline")
icons.append("ic_settings_outline")

//The icons that will be displayed for each tab once they are selected.
var selectedIcons = [String]()
icons.append("ic_star_filled")
icons.append("ic_history_filled")
icons.append("ic_phone_filled")
icons.append("ic_chat_filled")
icons.append("ic_settings_filled")
```

Now initialize the controller object through the following methods:
```swift
let tabController = AZTabBarController.insert(into: self, withTabIconNames: icons)

//Or

let tabController = AZTabBarController.insert(into: self, withTabIconNames: icons, andSelectedIconNames: selectedIcons)

```


Or the old fashion way:
```swift
let tabController = AZTabBarController(withTabIconNames: icons)
self.addChildViewController(controller)
self.view.addSubview(controller.view)
tabController.view.frame = parent.view.bounds
tabController.didMove(toParentViewController: parent)
```

Add optional controllers:
```swift
tabController.set(viewController: myChildViewController, atIndex: 0)
tabController.set(viewController: myOtherChildViewController, atIndex: 1)
tabController.set(viewController: settingsController, atIndex: 2)
```

Add optional actions:
```swift
tabController.set(action: { 

    //Your statments
    print("Hello World")

}, atIndex: 3)
```

Note that you can add both actions and view controllers at a certain index.

##Customizations

```swift

tabController.defaultColor = UIColor.white //default color of the icons on the buttons

//the color of the icon when a menu is selected
tabController.selectedColor = UIColor.orange 

//The background color of the tab bar in a nutshell
tabController.buttonsBackgroundColor = UIColor.black 

// default is 3.0
tabController.selectionIndicatorHeight = 0 

//make this button look highlighted.
tabController.highlightButton(atIndex: 2) 

// change the seperator line color (I recommened to leave this untouched or simply hide the seperator)
tabController.separatorLineColor = UIColor.black 

//hide or show the seperator line
tabController.separatorLineVisible = false 
```

##Extras

Hide/Show the tab bar:
```swift
tabController.setBar(hidden: true, animated: true)
```

Add badge to menu (use nil value to remove existing badges): 
```swift
tabController.set(badge: "5", atIndex: 3)
```

switch programmatically to a certain tab: 
```swift
tabController.set(selectedIndex: 2, animated: true)
```

##Delegate Methods

These are the functions of the AZTabBarDelegate:

```swift
/// This function is called after `didMoveToTabAtIndex` is called. In order for this function to work you must override the var `childViewControllerForStatusBarStyle` in the root controller to return this instance of AZTabBarController.
///
/// - Parameters:
///   - tabBar: The current instance of AZTabBarController.
///   - index: The index of the child view controller which you wish to set a status bar style for.
/// - Returns: The status bar style.
func tabBar(_ tabBar: AZTabBarController, statusBarStyleForIndex index: Int)-> UIStatusBarStyle
```

```swift
/// This function is called whenever user clicks the menu a long click. If returned false, the action will be ignored.
///
/// - Parameters:
///   - tabBar: The current instance of AZTabBarController.
///   - index: The index of the child view controller which you wish to disable the long menu click for.
/// - Returns: true if you wish to allow long-click interaction for a specific tab, false otherwise.
func tabBar(_ tabBar: AZTabBarController, shouldLongClickForIndex index: Int)-> Bool
```

```swift
/// This function is used to enable/disable animation for a certian tab.
///
/// - Parameters:
///   - tabBar: The current instance of AZTabBarController.
///   - index: The index of the tab.
/// - Returns: true if you wish to enable the animation, false otherwise.
func tabBar(_ tabBar: AZTabBarController, shouldAnimateButtonInteractionAtIndex index:Int)->Bool
```

```swift
/// This function is called whenever user taps one of the menu buttons.
///
/// - Parameters:
///   - tabBar: The current instance of AZTabBarController.
///   - index: The index of the menu the user tapped.
func tabBar(_ tabBar: AZTabBarController, didSelectTabAtIndex index: Int)
```

```swift
/// This function is called whenever user taps and hold one of the menu buttons. Note that this function will not be called for a certain index if `shouldLongClickForIndex` is implemented and returns false for that very same index.
///
/// - Parameters:
///   - tabBar: The current instance of AZTabBarController.
///   - index: The index of the menu the user long clicked.
func tabBar(_ tabBar: AZTabBarController, didLongClickTabAtIndex index:Int)
```

```swift
/// This function is called before the child view controllers are switched.
///
/// - Parameters:
///   - tabBar: The current instance of AZTabBarController.
///   - index: The index of the controller which the tab bar will be switching to.
func tabBar(_ tabBar: AZTabBarController, willMoveToTabAtIndex index:Int)
```

```swift
/// This function is called after the child view controllers are switched.
///
/// - Parameters:
///   - tabBar: The current instance of AZTabBarController.
///   - index: The index of the controller which the tab bar had switched to.
func tabBar(_ tabBar: AZTabBarController, didMoveToTabAtIndex index: Int)
```

##Credit

AZTabBarController is a converted and modified version of [ESTabBarController](https://github.com/ezescaruli/ESTabBarController) that is written in Objective-C by [ezescaruli](https://github.com/ezescaruli).






