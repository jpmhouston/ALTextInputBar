//
//  ALTextInputBar.swift
//  ALTextInputBar
//
//  Created by Alex Littlejohn on 2015/04/24.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

public class ALTextInputBar: ALKeyboardObservingInputBar, ALTextViewDelegate {
    
    public weak var delegate: ALTextInputBarDelegate?
    
    /// Used for the intrinsic content size for autolayout
    public var defaultHeight: CGFloat = 44
    
    /// If true the right button will always be visible else it will only show when there is text in the text view
    public var alwaysShowRightButton = false
    
    /// The horizontal padding between the view edges and the side button views
    public var buttonEdgeSpacing: CGFloat = 0
    
    /// The horizontal padding between the side buttons and the text field / border
    public var textButtonSpacing: CGFloat = 0
    
    /// The horizontal padding between the view edges and the text field / border (if no button inbetween)
    public var textEdgeSpacing: CGFloat = 8
    
    /// The corner radius of the border, if shown
    public var fieldBorderRadius: CGFloat = 4
    
    /// The width of the border, if shown (0 means hairline, eg. 0.5 on 2x retina screens)
    public var fieldBorderWidth: CGFloat = 0
    
    /// The distance from the border, if shown, to the text field
    public var fieldBorderInset: CGFloat = 4
    
    /// The border color
    public var borderColor: UIColor? = UIColor.lightGrayColor()
    
    /// The color of the field within the border, not used if border not shown
    public var fieldBackgroundColor: UIColor? {
        get {
            return borderView.backgroundColor
        }
        set(newValue) {
            borderView.backgroundColor = newValue
        }
    }
    
    /// If true the text view will have a border
    public var showFieldBorder = false {
        willSet(newValue) {
            if newValue == true {
                borderView.layer.borderColor = borderColor?.CGColor
                borderView.layer.cornerRadius = fieldBorderRadius
                borderView.layer.borderWidth = fieldBorderWidth > 0 ? fieldBorderWidth : (1.0 / UIScreen.mainScreen().scale)
                borderView.setNeedsDisplay()
            }
            else {
                borderView.layer.borderWidth = 0
                borderView.layer.cornerRadius = 0
                borderView.setNeedsDisplay()
            }
        }
    }
    
    /// Convenience set and retrieve the text view text
    public var text: String! {
        get {
            return textView.text
        }
        set(newValue) {
            textView.text = newValue
            textView.delegate?.textViewDidChange?(textView)
        }
    }
    
    /**
    This view will be displayed on the left of the text view.
    
    If this view is nil nothing will be displayed, and the text view will fill the space
    */
    public var leftView: UIView? {
        willSet(newValue) {
            if newValue == nil {
                if let view = leftView {
                    view.removeFromSuperview()
                }
            }
        }
        didSet {
            if let view = leftView {
                addSubview(view)
            }
        }
    }
    
    /**
    This view will be displayed on the right of the text view.
    
    If this view is nil nothing will be displayed, and the text view will fill the space
    If alwaysShowRightButton is false this view will animate in from the right when the text view has content
    */
    public var rightView: UIView? {
        willSet(newValue) {
            if newValue == nil {
                if let view = rightView {
                    view.removeFromSuperview()
                }
            }
        }
        didSet {
            if let view = rightView {
                addSubview(view)
            }
        }
    }
    
    /// The text view instance
    public let textView: ALTextView = {
        
        let _textView = ALTextView()
        
        _textView.textContainerInset = UIEdgeInsetsMake(1, 0, 1, 0);
        _textView.textContainer.lineFragmentPadding = 0
        
        _textView.maxNumberOfLines = defaultNumberOfLines()
        
        _textView.placeholder = "Type here"
        _textView.placeholderColor = UIColor.lightGrayColor()
        
        _textView.font = UIFont.systemFontOfSize(14)
        _textView.textColor = UIColor.darkGrayColor()
        
        _textView.backgroundColor = UIColor.clearColor()
        
        // This changes the caret color
        _textView.tintColor = UIColor.lightGrayColor()
        
        return _textView
        }()
    
    private let borderView: UIView = {
        
        let _borderView = UIView()
        
        _borderView.backgroundColor = UIColor.clearColor()
        
        _borderView.layer.borderColor = UIColor.lightGrayColor().CGColor
        _borderView.layer.borderWidth = 0;
        _borderView.layer.masksToBounds = true
        
        return _borderView
        }()
    
    private var showRightButton = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(borderView)
        borderView.addSubview(textView)
        
        textView.textViewDelegate = self
        
        backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
    
    // MARK: - View positioning and layout -
    
    override public func intrinsicContentSize() -> CGSize {
        return CGSizeMake(UIViewNoIntrinsicMetric, defaultHeight)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        let size = frame.size
        let height = floor(size.height)
        
        var leftViewSize = CGSizeZero
        var rightViewSize = CGSizeZero
        
        if let view = leftView {
            leftViewSize = view.bounds.size
            
            let leftViewX: CGFloat = buttonEdgeSpacing
            let leftViewVerticalPadding = (defaultHeight - leftViewSize.height) / 2
            let leftViewY: CGFloat = height - (leftViewSize.height + leftViewVerticalPadding)
            view.frame = CGRectMake(leftViewX, leftViewY, leftViewSize.width, leftViewSize.height)
        }
        
        if let view = rightView {
            rightViewSize = view.bounds.size
            
            let rightViewVerticalPadding = (defaultHeight - rightViewSize.height) / 2
            var rightViewX = size.width
            let rightViewY = height - (rightViewSize.height + rightViewVerticalPadding)
            
            if showRightButton || alwaysShowRightButton {
                rightViewX -= (rightViewSize.width + buttonEdgeSpacing)
            }
            
            view.frame = CGRectMake(rightViewX, rightViewY, rightViewSize.width, rightViewSize.height)
        }
        
        var dxLeft = textEdgeSpacing
        var dxRight = textEdgeSpacing
        if (leftViewSize.width > 0) {
            dxLeft = buttonEdgeSpacing + leftViewSize.width + textButtonSpacing
        }
        if (showRightButton || alwaysShowRightButton) && rightViewSize.width > 0 {
            dxRight = textButtonSpacing + rightViewSize.width + buttonEdgeSpacing
        }
        
        let textViewX = dxLeft
        let textViewWidth = size.width - dxLeft - dxRight
        
        let textViewPadding = (defaultHeight - textView.minimumHeight) / 2
        let textViewY = textViewPadding
        let textViewHeight = textView.expectedHeight
        
        if showFieldBorder {
            // inset the field horizontally from textViewX/textViewWidth, but outset the border vertically from textViewY/textViewHeight
            borderView.frame = CGRectMake(textViewX, textViewY - fieldBorderInset, textViewWidth, textViewHeight + fieldBorderInset + fieldBorderInset)
            textView.frame = CGRectMake(fieldBorderInset, fieldBorderInset, textViewWidth - fieldBorderInset - fieldBorderInset, textViewHeight)
        }
        else {
            borderView.frame = CGRectMake(textViewX, textViewY, textViewWidth, textViewHeight)
            textView.frame = CGRectMake(0, 0, textViewWidth, textViewHeight)
        }
    }
    
    public func updateViews(animated: Bool) {
        if animated {
            // :discussion: Honestly not sure about the best way to calculated the ideal spring animation duration
            // however these values seem to work for Slack
            // possibly replace with facebook/pop but that opens another can of worms
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .CurveEaseInOut, animations: {
                self.setNeedsLayout()
                self.layoutIfNeeded()
                }, completion: nil)
            
        } else {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    // MARK: - ALTextViewDelegate -
    
    public final func textViewHeightChanged(textView: ALTextView, newHeight: CGFloat) {
        
        let padding = defaultHeight - textView.minimumHeight
        let height = padding + newHeight
        
        if UIDevice.floatVersion() < 8.0 {
            frame.size.height = height
            
            setNeedsLayout()
            layoutIfNeeded()
        }
        
        for c in constraints() {
            var constraint = c as! NSLayoutConstraint
            if constraint.firstAttribute == NSLayoutAttribute.Height && constraint.firstItem as! NSObject == self {
                constraint.constant = height < defaultHeight ? defaultHeight : height
            }
        }
    }
    
    public final func textViewDidChange(textView: UITextView) {
        var shouldShowButton = textView.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
        
        if showRightButton != shouldShowButton && !alwaysShowRightButton {
            showRightButton = shouldShowButton
            updateViews(true)
        }
        
        if let d = delegate, m = d.textViewDidChange {
            m(self.textView)
        }
    }
    
    public func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        var beginEditing: Bool = true
        if let d = delegate, m = d.textViewShouldEndEditing {
            beginEditing = m(self.textView)
        }
        return beginEditing
    }
    
    public func textViewShouldEndEditing(textView: UITextView) -> Bool {
        var endEditing = true
        if let d = delegate, m = d.textViewShouldEndEditing {
            endEditing = m(self.textView)
        }
        return endEditing
    }
    
    public func textViewDidBeginEditing(textView: UITextView) {
        if let d = delegate, m = d.textViewDidBeginEditing {
            m(self.textView)
        }
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        if let d = delegate, m = d.textViewDidEndEditing {
            m(self.textView)
        }
    }
    
    public func textViewDidChangeSelection(textView: UITextView) {
        if let d = delegate, m = d.textViewDidChangeSelection {
            m(self.textView)
        }
    }
    
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        var shouldChange = true
        if text == "\n" {
            if let d = delegate, m = d.textViewShouldReturn {
                shouldChange = m(self.textView)
            }
        }
        return shouldChange
    }
}
