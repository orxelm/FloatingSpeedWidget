# FloatingSpeedWidget

## Requirements
Swift 3.0

## Demo
https://www.dropbox.com/s/1sxiwg1ogqdcqpd/demo.mov?dl=0

## Installation
### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate FloatingSpeedWidget into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

pod 'FloatingSpeedWidget'
```

Then, run the following command:

```bash
$ pod install
```

## Usage
### Swift
```swift
let floatingWidgetManager = FloatingSpeedWidgetManager(withTargetViewController: self, anchorPoint: .bottomLeft, andWidgetSize: 70)
floatingWidgetManager.floatingWidgetView.speedNumberFont = UIFont(name: "customFont", size: 24)
floatingWidgetManager.floatingWidgetView.speedUnitFont = UIFont(name: "customFont", size: 15)
self.floatingWidgetManager = floatingWidgetManager
```

### Objecitve-C
```objective-c
FloatingSpeedWidgetManager *floatingWidgetManager = [[FloatingSpeedWidgetManager alloc] initWithTargetViewController:self
                                                                                                         anchorPoint:FloatingSpeedWidgetAnchorBottomLeft 
                                                                                                       andWidgetSize:70];
floatingWidgetManager.floatingWidgetView.speedNumberFont = [UIFont yourCustomFontOfSize:25];
floatingWidgetManager.floatingWidgetView.speedUnitFont = [UIFont yourCustomFontOfSize:14];
self.floatingWidgetManager = floatingWidgetManager; // Important keep a strong reference to the manager
```

##Author
FloatingSpeedWidget is owned and maintained by Or Elmaliah. You can follow me on Twitter [@OrElm](https://twitter.com/orelm).

## TO-DO
- [ ] Finish the readme file
- [ ] Add tests

## MIT License

Copyright (c) 2016 Or Elmaliah

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
