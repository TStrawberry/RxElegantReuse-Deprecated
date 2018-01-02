//
//  UISlider+Extension.swift
//  RxElegantReuse
//
//  Created by TStrawberry on 2017/11/30.
//  Copyright © 2017年 TStrawberry. All rights reserved.
//

#if !RxElegantReuseSliderDisable

#if os(iOS) || os(tvOS)
    import UIKit

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif
    
    extension UISlider {
        @IBInspectable final var elegantValue: Bool {
            set {
                if elegantValue == false, newValue == true {
                    objc_setAssociatedObject(self, &Keys.value, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    _ = observe(obs: rx.value, SlideAction, { [Keys.value: $0] })
                }
            }
            get {
                return objc_getAssociatedObject(self, &Keys.value) as? Bool ?? false
            }
        }
    }


    public extension Reactive where Base: UIScrollView & ReusableViewContainer {
        var slided: ControlEvent<(String?, ViewLocation?, Float)> {
            return createControlEvent(action: SlideAction)
        }
    }


    @objc private protocol SliderEventProtocol {
        @objc optional func elegantSlider(with identifier: String?, at indexPath: IndexPath, slideTo: Float)
    }

    fileprivate struct Keys {
        static var value = "RxElegantReuse.Slider.value"
    }

    fileprivate let SlideAction = {
        ResponderAction<(String?, ViewLocation?, Float)>(
            selector: #selector(SliderEventProtocol.elegantSlider(with:at:slideTo:)),
            toArguments: { (location, userInfo) -> [Any] in
                return [userInfo[UserInfoKeys.identifier] as? String ?? (), location ?? (), userInfo[Keys.value]!]
        }) { (params) -> (String?, ViewLocation?, Float) in
            return (params[0] as? String, params[1] as? ViewLocation, params[2] as! Float)
        }
    }()


#endif
    
#endif
