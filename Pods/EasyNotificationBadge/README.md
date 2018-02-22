
<img src="Screenshots/heading.gif"  height="100" />

[![CocoaPods](https://img.shields.io/cocoapods/v/EasyNotificationBadge.svg)]()
[![CocoaPods](https://img.shields.io/cocoapods/l/EasyNotificationBadge.svg)]()
[![CocoaPods](https://img.shields.io/cocoapods/p/EasyNotificationBadge.svg)]()

## Installation


```bash
pod 'EasyNotificationBadge'
```

Or simply drag and drop ```NSBadge.swift``` to your project.

## Usage

To add a badge with default settings use this (This also applies to updating an existing badge):
```swift
view.badge(text: "5")
```

To remove the badge:

```swift
view.badge(text: nil)
```

## Advanced Usage

```swift
var badgeAppearnce = BadgeAppearance()
badgeAppearance.backgroundColor = UIColor.blue //default is red
badgeAppearance.textColor = UIColor.white // default is white
badgeAppearance.textAlignment = .center //default is center
badgeAppearance.textSize = 15 //default is 12
badgeAppearance.distenceFromCenterX = 15 //default is 0
badgeAppearance.distenceFromCenterY = -10 //default is 0
badgeAppearance.allowShadow = true
badgeAppearance.borderColor = .blue
badgeAppearance.borderWidth = 1
view.badge(text: "Your text", appearnce: badgeAppearnce)
```

### Important
When calling `.badge` make sure that the view has already been loaded and has a superview. Setting a badge on a view that hasn't fully loaded can lead to unexpected results.

## Credit
Some of the code that was used in this extension was originally written by [mustafaibrahim989](https://github.com/mustafaibrahim989) in the library [MIBadgeButton-Swift](https://github.com/mustafaibrahim989/MIBadgeButton-Swift).
