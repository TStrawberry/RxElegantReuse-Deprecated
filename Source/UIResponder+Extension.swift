//
//  UIResponder+Extension.swift
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
    
    
    /// The protocol should be used on subclass of built-in UIResponder type to control the event's frequency of events.
    /// like UIButton:
    ///     class CustomButton: UIButton, EventLimitable {
    ///         func limit<E>(o: Observable<E>) -> Observable<E> {
    ///             return o.throttle(2.0, scheduler: MainScheduler.instance)
    ///         }
    ///     }
    public protocol EventLimitable: class {
        
        /// Transform a Observable<E> to another and you shouldn't change the value's type.
        ///
        /// - Parameter o: Original Observable.
        /// - Returns: Transformed Observable.
        func limit<E>(o: Observable<E>) -> Observable<E>
    }
    
    
    
    extension UIResponder {
        
        @IBInspectable final var elegantIdentifier: String? {
            set {
                objc_setAssociatedObject(self, &Keys.identifier, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            get {
                return objc_getAssociatedObject(self, &Keys.identifier) as? String
            }
        }
        
        
        
        /// Route event to next responder.
        ///
        /// - Parameter userInfo: It must contain a pair of UserInfoKeys.action key and ResponderAction value.
        @objc open dynamic func elegantRouteEvent(with userInfo: [String: Any]) {
            #if DEBUG
                guard let _ = userInfo[UserInfoKeys.action] as? ResponderActionProtocol else {
                    fatalError("The userInfo must contain a pair of UserInfoKeys.action as key and ResponderAction as value.")
                }
            #endif
            next?.elegantRouteEvent(with: userInfo)
        }
        
        
        /// Bind event to next responder.
        ///
        /// - Parameters:
        ///   - obs: The event squence you want to observe outside.
        ///   - action: A ResponderAction instance for the event.
        ///   - identifier: Just the elegantidentifier.
        ///   - userInfo: Your custom infomation included in final userInfo.
        /// - Returns: Just a Disposable instance from subscribing obs.
        public func observe<O: ObservableType, E>(obs: O, _ action: ResponderAction<E>, _ userInfo: ((O.E) -> [String: Any]?)? = nil) -> Disposable {
            
            var `obs`: Observable<O.E> = obs.asObservable()
            if let control = self as? EventLimitable {
                `obs` = control.limit(o: `obs`)
            }
            
            return `obs`
                .map({ [weak self] (value) -> [String: Any] in
                    var `userInfo`: [String: Any] = userInfo?(value) ?? [:]
                    `userInfo`[UserInfoKeys.action] = action
                    if let identifer = self?.elegantIdentifier {
                        `userInfo`[UserInfoKeys.identifier] = identifer
                    }
                    return `userInfo`
                })
                .bind(onNext: elegantRouteEvent)
        }
        
        
        public func elegantRouteEvent<E>(action: ResponderAction<E>, otherInfo: [String: Any]? = nil) {
            var userInfo = otherInfo ?? [:]
            userInfo[UserInfoKeys.action] = action
            if let `identifer` = elegantIdentifier {
                userInfo[UserInfoKeys.identifier] = `identifer`
            }
            elegantRouteEvent(with: userInfo)
        }
        
    }
    
    
    fileprivate struct Keys {
        static var identifier    = "RxElegantReuse.View.identifier"
    }
    
    
#endif




