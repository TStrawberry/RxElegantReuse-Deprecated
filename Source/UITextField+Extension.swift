//
//  UITextField+Extension.swift
//  RxElegantReuse
//
//  Created by TStrawberry on 2017/12/1.
//  Copyright © 2017年 TStrawberry. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif
    
#if !RxElegantReuseTextFieldDisable
    
    
    public extension UITextField {
        
        @IBInspectable final var elegantText: Bool {
            set {
                if elegantText == false, newValue == true {
                    objc_setAssociatedObject(self, &Keys.text, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    _ = observe(obs: rx.text, TextAction) { [Keys.text: $0 ?? ()] }
                }
            }
            get {
                return objc_getAssociatedObject(self, &Keys.text) as? Bool ?? false
            }
        }
        
        
        @IBInspectable final var elegantAttributedText: Bool {
            set {
                if elegantAttributedText == false, newValue == true {
                    objc_setAssociatedObject(self, &Keys.attributedText, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    _ = observe(obs: rx.attributedText, AttributedTextAction) { [Keys.text: $0 ?? ()] }
                }
            }
            get {
                return objc_getAssociatedObject(self, &Keys.attributedText) as? Bool ?? false
            }
        }
    }
    
    
    
    
    /// ⚠️⚠️⚠️ The following two attributes are suitable for UITextField and UITextView's text event.
    public extension Reactive where Base: UIScrollView & ReusableViewContainer {
        
        var textChanged: ControlEvent<(String?, ViewLocation?, String?)> {
            return createControlEvent(action: TextAction)
        }
        
        var attributedTextChanged: ControlEvent<(String?, ViewLocation?, NSAttributedString?)> {
            return createControlEvent(action: AttributedTextAction)
        }
    }


    
    
    
    
    
    
    
    fileprivate struct Keys {
        static var text             = "RxElegantReuse.TextField.text"
        static var attributedText   = "RxElegantReuse.TextField.attributedText"
    }


    fileprivate let TextAction = {
        ResponderAction<(String?, ViewLocation?, String?)>(
            selector: #selector(TextEventProtocol.elegantText(with:at:changeTo:)),
            toArguments: { (location, userInfo) -> [Any] in
                return [userInfo[UserInfoKeys.identifier] ?? (), location ?? (), userInfo[Keys.text] ?? ()]
            }) { (params) -> (String?, ViewLocation?, String?) in
                return (params[0] as? String, params[1] as? ViewLocation, params[2] as? String)
            }
    }()


    fileprivate let AttributedTextAction = {
        ResponderAction<(String?, ViewLocation?, NSAttributedString?)>(
            selector: #selector(TextEventProtocol.elegantAttributedText(with:at:changeTo:)),
            toArguments: { (location, userInfo) -> [Any] in
                return [userInfo[UserInfoKeys.identifier] ?? (), location ?? (), userInfo[Keys.attributedText] ?? ()]
            }) { (params) -> (String?, ViewLocation?, NSAttributedString?) in
                return (params[0] as? String, params[1] as? ViewLocation, params[2] as? NSAttributedString)
            }
    }()
    
#endif
    
    
    
#if !RxElegantReuseTextFieldDisable || !RxElegantReuseTextViewDisable
    @objc protocol TextEventProtocol {
        @objc optional func elegantText(with identifier: String?, at indexPath: IndexPath, changeTo value: String?)
        @objc optional func elegantAttributedText(with identifier: String?, at indexPath: IndexPath, changeTo value: NSAttributedString?)
    }
#endif
    

#endif

