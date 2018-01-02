//
//  UITextView+Extension.swift
//  RxElegantReuse
//
//  Created by TStrawberry on 2017/12/4.
//  Copyright © 2017年 TStrawberry. All rights reserved.
//


#if !RxElegantReuseTextViewDisable
#if os(iOS) || os(tvOS)
    import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

    public extension UITextView {
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
    }
    
    
    
    
    
    
    
    
    @objc fileprivate protocol TextViewEventProtocol: TextEventProtocol { }
    

    fileprivate struct Keys {
        static var text             = "RxElegantReuse.TextView.text"
        static var attributedText   = "RxElegantReuse.TextView.attributedText"
    }

    fileprivate let TextAction = {
        ResponderAction<(String?, ViewLocation?, String?)>(
            selector: #selector(TextViewEventProtocol.elegantText(with:at:changeTo:)),
            toArguments: { (location, userInfo) -> [Any] in
                return [userInfo[UserInfoKeys.identifier] ?? (), location ?? (), userInfo[Keys.text] ?? ()]
            }) { (params) -> (String?, ViewLocation?, String?) in
                return (params[0] as? String, params[1] as? ViewLocation, params[2] as? String)
            }
    }()

    
    fileprivate let AttributedTextAction = {
        ResponderAction<(String?, ViewLocation?, NSAttributedString?)>(
            selector: #selector(TextViewEventProtocol.elegantAttributedText(with:at:changeTo:)),
            toArguments: { (location, userInfo) -> [Any] in
                return [userInfo[UserInfoKeys.identifier] ?? (), location ?? (), userInfo[Keys.attributedText] ?? ()]
            }) { (params) -> (String?, ViewLocation?, NSAttributedString?) in
                return (params[0] as? String, params[1] as? ViewLocation, params[2] as? NSAttributedString)
            }
    }()
    
#endif

    
#endif


