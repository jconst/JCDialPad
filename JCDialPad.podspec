Pod::Spec.new do |s|
  s.name         = "JCDialPad"
  s.version      = "0.1.1"
  s.summary      = "A customizable phone dial pad view similar to the iOS 7 Phone app's Keypad view."

  s.description  = "<<-DESC
                     A customizable phone dial pad view similar to the iOS 7 Phone app's Keypad view.
  
                     Based on ABPadLockScreen by Aron Bury.
                     DESC"

  s.homepage     = "https://github.com/jconst/JCDialPad"

  s.license      = 'MIT'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "Joseph Constantakis" => "jcon5294@gmail.com" }

  s.platform     = :ios, '5.0'
  s.ios.deployment_target = '5.0'

  s.source       = { :git => "https://github.com/jconst/JCDialPad.git", :tag => s.version.to_s }
  s.source_files  = 'JCDialPad/*.{h,m}'

  s.dependency 'libPhoneNumber-iOS'

  s.requires_arc = true  
end
