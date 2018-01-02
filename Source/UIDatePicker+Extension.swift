//
//  UIDatePicker+Extension.swift
//  RxElegantReuse
//
//  Created by TStrawberry on 2017/11/30.
//  Copyright © 2017年 TStrawberry. All rights reserved.
//

#if !RxElegantReuseDatePickerDisable
    
#if os(iOS) || os(tvOS)
    import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

    extension UIDatePicker {
        @IBInspectable final var elegantDate: Bool {
            set {
                if elegantDate == false, newValue == true {
                    objc_setAssociatedObject(self, &Keys.date, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    _ = observe(obs: rx.date, PickAction, { [Keys.date: $0] })
                }
            }
            get {
                return objc_getAssociatedObject(self, &Keys.date) as? Bool ?? false
            }
        }
    }
    
    
    extension Reactive where Base: UIScrollView & ReusableViewContainer {
        var datePicked: ControlEvent<(String?, ViewLocation?, Date)> {
            return createControlEvent(action: PickAction)
        }
    }
    

    @objc fileprivate protocol DatePickerEventProtocol {
        @objc optional func elegantPicker(with identifier: String?, at indexPath: IndexPath, pickTo date: Date)
    }

    extension RxTableViewDelegateProxy: DatePickerEventProtocol { }
    extension RxCollectionViewDelegateProxy: DatePickerEventProtocol { }

    fileprivate struct Keys {
        static var date    = "RxElegantReuse.DatePicker.date"
    }

    fileprivate let PickAction = {
        ResponderAction<(String?, ViewLocation?, Date)>(
            selector: #selector(DatePickerEventProtocol.elegantPicker(with:at:pickTo:)),
            toArguments: { (location, userInfo) -> [Any] in
                return [userInfo[UserInfoKeys.identifier] ?? (), location ?? (), userInfo[Keys.date]!]
            }) { (params) -> (String?, ViewLocation?, Date) in
                return (params[0] as? String, params[1] as? ViewLocation, params[2] as! Date)
            }
    }()

    
#endif
    
#endif
