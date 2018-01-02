//
//  UIStepper+Extension.swift
//  RxElegantReuse
//
//  Created by TStrawberry on 2017/12/1.
//  Copyright © 2017年 TStrawberry. All rights reserved.
//


#if (os(iOS) || os(tvOS))

#if !RxElegantReuseStepperDisable
    import UIKit
    
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif
    
    public extension Reactive where Base: UIScrollView & ReusableViewContainer {
        var stepperTriggered: ControlEvent<(String?, ViewLocation?, Double)> {
            return createControlEvent(action: TriggerAction)
        }
    }

    public extension UIStepper {
        @IBInspectable final var elegantValue: Bool {
            set {
                if elegantValue == false, newValue == true {
                    objc_setAssociatedObject(self, &Keys.value, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    _ = observe(obs: rx.value, TriggerAction) { [Keys.value: $0] }
                }
            }
            get {
                return objc_getAssociatedObject(self, &Keys.value) as? Bool ?? false
            }
        }
    }







    @objc fileprivate protocol StepperEventProtocol {
        @objc optional func elegantStepper(with identifier: String?, at indexPath: IndexPath, triggerTo: Double)
    }
    
    

    fileprivate struct Keys {
        static var value = "RxElegantReuse.Stepper.value"
    }

    fileprivate let TriggerAction = {
        ResponderAction<(String?, ViewLocation?, Double)>(
            selector: #selector(StepperEventProtocol.elegantStepper(with:at:triggerTo:)),
            toArguments: { (location, userInfo) -> [Any] in
                return [userInfo[UserInfoKeys.identifier] ?? (), location ?? (), userInfo[Keys.value]!]
            }) { (params) -> (String?, ViewLocation?, Double) in
                return (params[0] as? String, params[1] as? ViewLocation, params[2] as! Double)
            }
    }()

#endif
    
#endif

