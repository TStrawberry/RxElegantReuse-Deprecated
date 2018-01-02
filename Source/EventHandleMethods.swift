//
//  EventHandleMethods.swift
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
    
    @objc protocol PPP {
        @objc optional func ttt()
    }
    
    extension RxTableViewDelegateProxy: PPP { }
    
    
    public class ElegantDelegateProxy {
        
        private var unexitSelectors: [Selector: PublishSubject<[Any]>] = [:]
        
        let delegateProxy: RxScrollViewDelegateProxy
        
        init(delegateProxy: RxScrollViewDelegateProxy) {
            self.delegateProxy = delegateProxy
        }
        
        
        static func elegentProxy(for scrollView: UIScrollView) -> ElegantDelegateProxy {
            
            MainScheduler.ensureExecutingOnScheduler()
            guard let eleDelegate = scrollView.rx.delegate as? RxScrollViewDelegateProxy else {
                fatalError("   ")
            }
            
            if let proxy = scrollView.elegantDelegate {
                return proxy
            } else {
                let proxy = ElegantDelegateProxy(delegateProxy: eleDelegate)
                scrollView.elegantDelegate = proxy
                return proxy
            }
        }
        
        
        func responds(to aSelector: Selector) -> Bool {
            if let _ = unexitSelectors[aSelector] { return true }
            return delegateProxy.responds(to: aSelector)
        }
        
        func methodInvoked(_ selector: Selector) -> Observable<[Any]> {
            if delegateProxy.responds(to: selector) == false {
                let publish = PublishSubject<[Any]>()
                unexitSelectors[selector] = publish
                return publish.share().subscribeOn(MainScheduler.instance)
            } else {
                return delegateProxy.methodInvoked(selector)
            }
        }
        
        func _methodInvoked(_ selector: Selector, withArguments arguments: [Any]) {
            if let dispatcher = unexitSelectors[selector] {
                dispatcher.onNext(arguments)
            } else {
                delegateProxy._methodInvoked(selector, withArguments: arguments)
            }
        }
    }
    
    extension Reactive where Base: UIScrollView {
        public var elegantDelegate: ElegantDelegateProxy {
            return ElegantDelegateProxy.elegentProxy(for: base)
        }
    }
    
    extension UIScrollView {
        private struct Keys {
            static var elegantDelegate: String = "RxElegantReuse.elegantDelegate"
        }
        
        public var elegantDelegate: ElegantDelegateProxy? {
            set {
                objc_setAssociatedObject(self, &Keys.elegantDelegate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            
            get {
                return objc_getAssociatedObject(self, &Keys.elegantDelegate) as? ElegantDelegateProxy
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    public struct UserInfoKeys {
        public static let action    : String = "UserInfoActionKey"        // ResponderAction
        static let identifier       : String = "UserInfoIdentifierKey"    // String
        static let reusableView     : String = "UserInforReusableViewKey" // Cell/ViewLocatable
    }

    public protocol ReusableViewContainer {
        associatedtype Cell
        
        var elegantDelegate: ElegantDelegateProxy? { get }
        func indexPath(for: Cell) -> IndexPath?
    }

    extension ReusableViewContainer where Self: UIResponder {
        fileprivate func routeEvent(with userInfo: [String : Any]) {
            let action = userInfo[UserInfoKeys.action] as! ResponderActionProtocol
            if let cell = userInfo[UserInfoKeys.reusableView] as? Cell,
                let indexPath = indexPath(for: cell) {
                elegantDelegate?._methodInvoked(action.selector, withArguments: action.toArguments(ViewLocation.indexPath(indexPath), userInfo))
            } else if
                let reusableView = userInfo[UserInfoKeys.reusableView] as? ViewLocatable,
                let location = reusableView.locate() {
                elegantDelegate?._methodInvoked(action.selector, withArguments: action.toArguments(location, userInfo))
            } else {
                #if DEBUG
                    print("RxElemenReuse - 👇👇👇")
                    print("RxElemenReuse can't get the view's location. Maybe your customized UITableViewHeaderFooterView/UICollectionReusableView did not override the methods in ViewLocatable. Make sure that you do not want the ViewLocation info. If yes, ignore this message please.")
                    print("RxElemenReuse - 👆👆👆")
                #endif
                elegantDelegate?._methodInvoked(action.selector, withArguments: action.toArguments(nil, userInfo))
            }
        }
    }

    
    extension UITableView: ReusableViewContainer {
        override open func elegantRouteEvent(with userInfo: [String : Any]) {
            routeEvent(with: userInfo)
        }
    }

    extension UICollectionView: ReusableViewContainer {
        override open func elegantRouteEvent(with userInfo: [String : Any]) {
            routeEvent(with: userInfo)
        }
    }


    
    
    extension UITableViewCell {
        override open func elegantRouteEvent(with userInfo: [String : Any]?) {
            next?.elegantRouteEvent(with: [UserInfoKeys.reusableView : self].merging(userInfo ?? [:]) { $1 })
        }
    }

    extension UITableViewHeaderFooterView {
        override open func elegantRouteEvent(with userInfo: [String : Any]?) {
            next?.elegantRouteEvent(with: [UserInfoKeys.reusableView : self].merging(userInfo ?? [:]) { $1 })
        }
    }

    extension UICollectionReusableView {
        override open func elegantRouteEvent(with userInfo: [String : Any]?) {
            next?.elegantRouteEvent(with: [UserInfoKeys.reusableView : self].merging(userInfo ?? [:]) { $1 })
        }
    }

    extension Reactive where Base: UIScrollView & ReusableViewContainer {
        public func createControlEvent<T>(action: ResponderAction<T>) -> ControlEvent<T> {
            let source = elegantDelegate.methodInvoked(action.selector)
                .map(action.toElements)
            return ControlEvent(events: source)
        }
        
        public func createObservableEvent<T>(action: ResponderAction<T>) -> Observable<T> {
            return elegantDelegate.methodInvoked(action.selector)
                .map(action.toElements)
        }
    }
    

#endif
