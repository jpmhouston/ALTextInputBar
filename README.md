# ALTextInputBar
An auto growing text input bar for messaging apps. Written in Swift.
ALTextInputBar is designed to solve a few issues that folks usually encounter when building messaging apps.

> *This fork adds an optional outline drawn around text field within the bar, and other minor layout tweaks.*

![With some text](https://cloud.githubusercontent.com/assets/932822/7333301/a510aa22-eb6a-11e4-988b-ac12e4e6c363.png)
![With lots of text](https://cloud.githubusercontent.com/assets/932822/7333307/cf101c04-eb6a-11e4-9a80-799cf3353a70.png)

### Features
- Supports iOS 7
- Simple to use and configure
- Automatic resizing based on content
- Interactive dismiss gesture support

### Installation & Requirements

This project requires Xcode 6.3 to run and compiles with swift 1.2

#### iOS 8
ALTextInputBar is available on [CocoaPods](http://cocoapods.org).  Add the following to your Podfile:

```ruby
pod 'ALTextInputBar'
```

#### iOS 7

Drag `ALTextInputBar.swift` and `ALTextView.swift` into your project

### Usage

This is the minimum configuration required to attach an input bar to the keyboard.
```swift
class ViewController: UIViewController {

    let textInputBar = ALTextInputBar()
    
    // The magic sauce
    // This is how we attach the input bar to the keyboard
    override var inputAccessoryView: UIView? {
        get {
            return textInputBar
        }
    }
    
    // Another ingredient in the magic sauce
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
}
```
#### ALTextInputBar Configuration

Used for vertical padding and such.  
Also used for the intrinsic content size when using autolayout.
```swift
public var defaultHeight: CGFloat = 44
```
If true the right button will always be visible else it will only show when there is text in the text view.
```swift
public var alwaysShowRightButton = false
```
The horizontal padding between the input bar edges and its subviews.
```swift
public var horizontalPadding: CGFloat = 0
```
The horizontal spacing between subviews.
```swift
public var horizontalSpacing: CGFloat = 5
```
This view will be displayed on the left of the text view.  
If this view is nil nothing will be displayed, and the text view will fill the space.
```swift
public var leftView: UIView?
```
This view will be displayed on the right of the text view.  
If this view is nil nothing will be displayed, and the text view will fill the space.  
If alwaysShowRightButton is false this view will animate in from the right when the text view has content.
```swift
public var rightView: UIView?
```
The input bar's text view instance.
```swift
public let textView: ALTextView
```

#### ALTextView Configuration

The delegate object to be notified if the content size will change.   
The delegate should update handle text view layout.
```swift
public weak var textViewDelegate: ALTextViewDelegate?
```
The text that appears as a placeholder when the text view is empty.
```swift
public var placeholder: String = ""
```
The color of the placeholder text.
```swift
public var placeholderColor: UIColor!
```
The maximum number of lines that will be shown before the text view will scroll. 0 = no limit
```swift
public var maxNumberOfLines: CGFloat = 0
```
## License
ALTextInputBar is available under the MIT license. See the LICENSE file for more info.


