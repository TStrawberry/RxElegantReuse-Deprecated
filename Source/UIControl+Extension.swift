//
//  UIControl+Extension.swift
//  RxElegantReuse
//
//  Created by TStrawberry on 2017/11/30.
//  Copyright © 2017年 TStrawberry. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

    extension UIControl {
        @IBInspectable final var elegantEvents: String? {
            set {
                if let _ = elegantEvents {
                    #if DEBUG
                        print("RxElemenReuse - 👇👇👇")
                        print("It seems that you have set UIControl.elegantEvents more than once, and that will produce the same events many times. That goes against the RxElemenReuse's meaning and so the second or more value will be ignored.")
                        print("RxElemenReuse - 👆👆👆")
                    #endif
                } else if let eventsStr = newValue  {
                    objc_setAssociatedObject(self, &Keys.event, eventsStr, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    apply(eventsStr.components(separatedBy: ","))
                }
            }
            get {
                return objc_getAssociatedObject(self, &Keys.event) as? String
            }
        }
    }

    public extension Reactive where Base: UIScrollView & ReusableViewContainer {
        var controlEvent: ControlEvent<(String?, ViewLocation?, UIControlEvents)> {
            return createControlEvent(action: ControlEventAction)
        }
    }
    
    
    
    
    
    
    

    @objc fileprivate protocol ControlEventProtocol {
        @objc optional func elegantControl(with identifier: String?, at indexPath: IndexPath, changeTo state: UIControlEvents)
    }
    

    fileprivate let ControlEventAction = {
        ResponderAction<(String?, ViewLocation?, UIControlEvents)>(
            selector: #selector(ControlEventProtocol.elegantControl(with:at:changeTo:)),
            toArguments: { (location, userInfo) -> [Any] in
                return [userInfo[UserInfoKeys.identifier] ?? (), location ?? (), userInfo[Keys.event] ?? ()]
            }) { (params) -> (String?, ViewLocation?, UIControlEvents) in
                return (params[0] as? String, params[1] as? ViewLocation, params[2] as! UIControlEvents)
            }
    }()
    

    fileprivate extension UIControlEvents {
        
        /// The following options can be used to set elegantEvents.
        /// You should ensure that the options are separated by commas and not include other special characters such as Spaces.
        /// eg: touchDown,touchUpInside,touchUpOutside
        init?(event name: String) {
            switch name {
            case "touchDown":
                self = .touchDown
            case "touchDownRepeat":
                self = .touchDownRepeat
            case "touchDragInside":
                self = .touchDragInside
            case "touchDragOutside":
                self = .touchDragOutside
            case "touchDragEnter":
                self = .touchDragEnter
            case "touchDragExit":
                self = .touchDragExit
            case "touchUpInside":
                self = .touchUpInside
            case "touchUpOutside":
                self = .touchUpOutside
            case "touchCancel":
                self = .touchCancel
            case "valueChanged":
                self = .valueChanged
            case "primaryActionTriggered":
                if #available(iOS 9.0, *) {
                    self = .primaryActionTriggered
                } else {
                    #if DEBUG
                        print("RxElemenReuse - 👇👇👇")
                        print("You are trying to use a UIControl event which is available in iOS 9.0 at least, so it will be ignored in the current system.")
                        print("RxElemenReuse - 👆👆👆")
                    #endif
                    return nil
                }
            case "editingDidBegin":
                self = .editingDidBegin
            case "editingChanged":
                self = .editingChanged
            case "editingDidEnd":
                self = .editingDidEnd
            case "editingDidEndOnExit":
                self = .editingDidEndOnExit
            case "allTouchEvents":
                self = .allTouchEvents
            case "allEditingEvents":
                self = .allEditingEvents
            case "applicationReserved":
                self = .applicationReserved
            case "systemReserved":
                self = .systemReserved
            case "allEvents":
                self = .allEvents
            default:
                return nil
            }
        }
    }

    
    fileprivate struct Keys {
        static var event: String = "RxElegantReuse.Control.event"
    }


    fileprivate extension UIControl {
        func apply( _ events: Array<String>) {
            let observables = events
                .flatMap { (eventName) -> (UIControlEvents, String)? in
                    if let event = UIControlEvents(event: eventName) {
                        return (event, "UIControl."+eventName)
                    } else {
                        #if DEBUG
                            print("RxElemenReuse - 👇👇👇")
                            print("Please check whether the elegantEvents contains a wrong event name, you can find all options in UIControl's initialize method in UIControl+Extension.swift.")
                            print("RxElemenReuse - 👆👆👆")
                        #endif
                        return nil
                    }
                }
                .flatMap { [weak self] (eventInfo) -> Observable<(String, UIControlEvents)>? in
                    return self?.rx.controlEvent(eventInfo.0)
                        .map{ (eventInfo.1, eventInfo.0) }
                }
            
            _ = observe(obs: Observable.merge(observables), ControlEventAction) { [Keys.event: $0.1] }
            
        }
        
    }

#endif



