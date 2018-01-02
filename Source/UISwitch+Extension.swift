//
//  UISwitch+Extension.swift
//  RxElegantReuse
//
//  Created by TStrawberry on 2017/11/30.
//  Copyright © 2017年 TStrawberry. All rights reserved.
//

#if !RxElegantReuseSwitchDisable

#if os(iOS) || os(tvOS)
    import UIKit

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif
    
    extension UISwitch {
        @IBInspectable final var elegantIsOn: Bool {
            set {
                if elegantIsOn == false, newValue == true {
                    objc_setAssociatedObject(self, &Keys.isOn, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    _ = observe(obs: rx.isOn, SwicthAction, { [Keys.isOn: $0] })
                }
            }
            
            get {
                return objc_getAssociatedObject(self, &Keys.isOn) as? Bool ?? false
            }
        }
    }

    public extension Reactive where Base: UIScrollView & ReusableViewContainer {
        var switched: ControlEvent<(String?, ViewLocation?, Bool)> {
            return createControlEvent(action: SwicthAction)
        }
    }

    
    @objc fileprivate protocol SwitchEventProtocol {
        @objc optional func elegantSwitch(with identifier: String?, at indexPath: IndexPath, siwtchTo isOn: Bool)
    }
    

    fileprivate struct Keys {
        static var isOn    = "RxElegantReuse.Switch.ecOn"
    }

    fileprivate let SwicthAction = {
        ResponderAction<(String?, ViewLocation?, Bool)>(
            selector: #selector(SwitchEventProtocol.elegantSwitch(with:at:siwtchTo:)),
            toArguments: { (location, userInfo) -> [Any] in
                return [userInfo[UserInfoKeys.identifier] ?? (), location ?? (), userInfo[Keys.isOn]!]
            }) { (params) -> (String?, ViewLocation?, Bool) in
                return (params[0] as? String, params[1] as? ViewLocation, params[2] as! Bool)
            }
    }()

#endif

#endif
