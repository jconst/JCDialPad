# JCDialPad
JCDialPad is a customizable view which allows you to create button menus in the style of the iOS 7/8 keypad and pin pad views. Here are some examples of views created using JCDialPad:

<img src="ss1.png" width=60%></img>
<img src="ss2.png" width=60%></img>
<img src="ss3.png" width=60%></img>


## Features
- Fully customizable buttons with useful defaults
- Automatically format phone numbers as you type
- Set a background image with a frosted overlay
- Handle button presses in multiple different ways using one simple delegate method
- Buttons are automatically laid out in centered rows of three
- Most colors and fonts can be customized using UIAppearance, or set directly

## Installation
[CocoaPods](http://cocoapods.org) is the easiest way to manage your iOS/OSX dependencies. Check out their getting started guide to see how to set it up.
If you have cocoapods setup on your machine, simply set the spec like this:

#### Podfile
```ruby
platform :ios, '6.0'
pod "JCDialPad", "~> 0.1.0"
```

## Usage

Creating a standard keypad view with buttons 1-9, *, and # is as simple as this:

```objectivec
JCDialPad *pad = [[JCDialPad alloc] initWithFrame:self.view.bounds];
pad.buttons = [JCDialPad defaultButtons];
pad.delegate = self;
[self.view addSubview:pad];
```

Check out the Demo project to get a sense of how to create more complex views, add a background image, and create your own buttons using images or iconic fonts.

### Customising the Appearance
The module is entirely customisable through UIAppearance. Most colours and fonts used within the module can be set using the UIAppearance proxy. The example project shows how to do this, but for a more in depth look at UIAppearance check out the docs [check out the docs](https://developer.apple.com/library/ios/documentation/uikit/reference/UIAppearance_Protocol/Reference/Reference.html) or check out [Matt Thompson’s article on NSHipster](http://nshipster.com/uiappearance/)

## License
JCDialPad is available under the MIT license. See the LICENSE file for more info.
