//
//  UIButton+Extension.swift
//  RxElegantReuse
//
//  Created by TStrawberry on 2017/11/30.
//  Copyright © 2017年 TStrawberry. All rights reserved.
//


#if !RxElegantReuseButtonDisable
    
#if os(iOS) || os(tvOS)
    import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif
    
    
    public extension UIButton {
        @IBInspectable final var elegantTap: Bool {
            set {
                if elegantTap == false, newValue == true {
                    objc_setAssociatedObject(self, &Keys.tap, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    _ = observe(obs: rx.tap, TapAction, nil)
                }
            }
            get {
                return objc_getAssociatedObject(self, &Keys.tap) as? Bool ?? false
            }
        }
    }
    
    public extension Reactive where Base: UIScrollView & ReusableViewContainer {
        var buttonTapped:  ControlEvent<(String?, ViewLocation?)> {
            return createControlEvent(action: TapAction)
        }
    }
    

    
    @objc fileprivate protocol ButtonEventProtocol {
        @objc optional func elegantButtonTapped(with identifier: String?, at indexPath: IndexPath?)
    }
    
    fileprivate struct Keys {
        static var tap = "RxElegantReuse.Button.tap"
    }

    fileprivate let TapAction = {
        ResponderAction<(String?, ViewLocation?)>(
            selector: #selector(ButtonEventProtocol.elegantButtonTapped(with:at:)),
            toArguments: { (location, userInfo) -> [Any] in
                return [userInfo[UserInfoKeys.identifier] ?? (), location ?? ()]
            }) { (params) -> (String?, ViewLocation?) in
                return (params[0] as? String, params[1] as? ViewLocation)
            }
    }()
    

#endif
    
#endif
