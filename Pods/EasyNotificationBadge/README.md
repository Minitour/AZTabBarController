# EasyNotificationBadge
UIView extension that adds a notification badge.

The code that was used in this extension was originally written by [mustafaibrahim989](https://github.com/mustafaibrahim989) in the library [MIBadgeButton-Swift](https://github.com/mustafaibrahim989/MIBadgeButton-Swift).

##Screenshots
<img src="Screenshots/ss6.PNG"  height="400" />

##Installation


```bash
pod 'EasyNotificationBadge'
```

Or simply drag and drop ```NSBadge.swift``` to your project.

##Usage

To add a badge with default settings use this (This also applies to updating an existing badge):
```swift
view.badge(text: "5")
```
```swift
barButtonItem.badge(text: "7")
```

To remove the badge:

```swift
view.badge(text: nil)
```

```swift
barButtonItem.badge(text: nil)
```

##Advanced Usage

```swift
let badgeAppearnce = BadgeAppearnce()
appearnce.backgroundColor = UIColor.blue //default is red
appearnce.textColor = UIColor.white // default is white
appearnce.alignment = .center //default is center
appearnce.textSize = 15 //default is 12
appearnce.distenceFromCenterX = 15 //default is 0
appearnce.distenceFromCenterY = -10 //default is 0
appearnce.allowShadow = true
appearnce.borderColor = .blue
appearnce.borderWidth = 1
view.badge(text: "Your text", appearnce: badgeAppearnce)
```
