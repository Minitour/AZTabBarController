Pod::Spec.new do |s|
  s.name         = "AZTabBar"
  s.version      = "1.4.2"
  s.summary      = "A custom tab bar controller for iOS written in Swift 3.0"
  s.homepage     = "https://github.com/Minitour/AZTabBarController"
  s.license      = "MIT"
  s.author       = { "Antonio Zaitoun" => "tony.z.1711@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/Minitour/AZTabBarController.git", :tag => "#{s.version}" }
  s.source_files  = "Sources/*.swift"
  #s.resources  = "Sources/*.xib"
  s.dependency "EasyNotificationBadge"
end
