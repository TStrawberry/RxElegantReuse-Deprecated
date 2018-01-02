//
//  UIGestureRecognizer+Extension.swift
//  RxElegantReuse
//
//  Created by TStrawberry on 2017/12/4.
//  Copyright © 2017年 TStrawberry. All rights reserved.
//

#if !RxElegantReuseGestureRecognizerDisable
#if os(iOS) || os(tvOS)
    import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

    extension UIGestureRecognizer {
        
        @IBInspectable var elegantIdentifier: String? {
            set {
                objc_setAssociatedObject(self, &Keys.identifier, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            get {
                return objc_getAssociatedObject(self, &Keys.identifier) as? String
            }
        }
        
        @IBInspectable final var elegantEvent: Bool {
            set {
                if elegantEvent == false, newValue == true {
                    objc_setAssociatedObject(self, &Keys.event, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    _ = view?.observe(obs: rx.event, GestureTriggerAction, { [Keys.state: $0.state] })
                }
            }
            get {
                return objc_getAssociatedObject(self, &Keys.event) as? Bool ?? false
            }
        }
    }


    extension Reactive where Base: UIScrollView & ReusableViewContainer {
        var gestureTriggered: ControlEvent<(String?, ViewLocation?, UIGestureRecognizerState)> {
            return createControlEvent(action: GestureTriggerAction)
        }
    }

    
    
    
    
    
    
    
    
    
    
    

    @objc fileprivate protocol GestureEventProtocol {
        @objc optional func elegantGesture(with identifier: String?, at indexPath: IndexPath, triggerTo value: String?)
    }

    fileprivate struct Keys {
        static var event        = "RxElegantReuse.GestureRecognizer.event"
        static var state        = "RxElegantReuse.GestureRecognizer.state"
        static var identifier   = "RxElegantReuse.GestureRecognizer.identifier"
        static var recognizer   = "RxElegantReuse.GestureRecognizer.recognizer"
    }

    fileprivate let GestureTriggerAction = ResponderAction<(String?, ViewLocation?, UIGestureRecognizerState)>(
        selector: #selector(GestureEventProtocol.elegantGesture(with:at:triggerTo:)),
        toArguments: { (location, userInfo) -> [Any] in
            return [userInfo[UserInfoKeys.identifier] ?? (), location ?? (), userInfo[Keys.state] as! UIGestureRecognizerState]
        }) { (params) -> (String?, ViewLocation?, UIGestureRecognizerState) in
            return (params[0] as? String, params[1] as? ViewLocation, params[2] as! UIGestureRecognizerState)
        }

    
#endif
    
#endif

