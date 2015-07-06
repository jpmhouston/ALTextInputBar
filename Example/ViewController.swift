//
//  ViewController.swift
//  ALTextInputBar
//
//  Created by Alex Littlejohn on 2015/04/24.
//  Copyright (c) 2015 zero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let textInputBar = ALTextInputBar()
    
    let scrollView = UIScrollView()
    
#if !TEST_AS_SUBVIEW
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
#endif
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScrollView()
        configureInputBar()
        
        // not needed:
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardFrameChanged:", name: InputAccessoryViewKeyboardFrameDidChangeNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.frame = view.bounds
    }

#if TEST_AS_SUBVIEW
    override func viewDidLayoutSubviews() { // debugging view heirarchy easier if added as a plain subview instead the magic sauce above
        //textInputBar.layoutIfNeeded()
        //let barHeight = textInputBar.frame.height // why does this get 0 instead of the correct height?
        let barHeight = textInputBar.defaultHeight
        
        var barFrame = view.bounds
        barFrame.size.height = barHeight
        barFrame.origin.y = view.bounds.height - barHeight
        textInputBar.frame = barFrame
        
        var scrollViewFrame = view.bounds
        scrollViewFrame.size.height = scrollViewFrame.height - textInputBar.frame.height
        scrollView.frame = scrollViewFrame
    }
#endif
    
    func configureScrollView() {
        view.addSubview(scrollView)
        
        let contentView = UIView(frame: CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height * 2))
        contentView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        scrollView.addSubview(contentView)
        scrollView.contentSize = contentView.bounds.size
        scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
        scrollView.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
    
    func configureInputBar() {
#if TEST_AS_SUBVIEW
        view.addSubview(textInputBar) // debugging view heirarchy easier if added as a plain subview instead the magic sauce above
#endif
        
        let leftButton = UIButton(frame: CGRectMake(0, 0, 44, 44))
        let rightButton = UIButton(frame: CGRectMake(0, 0, 44, 44))
        
        leftButton.setImage(UIImage(named: "leftIcon"), forState: UIControlState.Normal)
        rightButton.setImage(UIImage(named: "rightIcon"), forState: UIControlState.Normal)
        
        textInputBar.leftView = leftButton
        textInputBar.rightView = rightButton
        
        textInputBar.fieldBackgroundColor = UIColor.whiteColor()
        textInputBar.showFieldBorder = true
    }

    // not needed:
//    func keyboardFrameChanged(notification: NSNotification) {
//        println("keyboardFrameChanged")
//        if let userInfo = notification.userInfo {
//            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
//            
//            
//        }
//    }
//    
//    func keyboardWillShow(notification: NSNotification) {
//        println("keyboardWillShow")
//    }
//    
//    func keyboardWillHide(notification: NSNotification) {
//        println("keyboardWillHide")
//    }
    
}

