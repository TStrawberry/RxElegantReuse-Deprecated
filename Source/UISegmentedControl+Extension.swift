//
//  UISegmentedControl+Extension.swift
//  RxElegantReuse
//
//  Created by TStrawberry on 2017/12/5.
//  Copyright © 2017年 TStrawberry. All rights reserved.
//

#if !RxElegantReuseSegmentedControlDisable

#if os(iOS) || os(tvOS)
    import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif
    
    
    
    public extension UISegmentedControl {
        @IBInspectable final var elegantSegmentIndex: Bool {
            set {
                
                
                if elegantSegmentIndex == false, newValue == true {
                    objc_setAssociatedObject(self, &Keys.index, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                    _ = observe(obs: rx.selectedSegmentIndex, SegmentAction) { [Keys.index: $0] }
                }
            }
            get {
                return objc_getAssociatedObject(self, &Keys.index) as? Bool ?? false
            }
        }
    }


    public extension Reactive where Base: UIScrollView & ReusableViewContainer {
        var segmentSelected: ControlEvent<(String?, ViewLocation?, Int)> {
            return createControlEvent(action: SegmentAction)
        }
    }
    
    
    
    

    
    
    @objc fileprivate protocol SegmentedEventProtocol {
        @objc optional func elegantSegmentedControl(with identifier: String?, at indexPath: IndexPath, changeTo value: Int)
    }

    fileprivate struct Keys {
        static var index             = "RxElegantReuse.SegmentedControl.index"
    }

    fileprivate let SegmentAction = ResponderAction<(String?, ViewLocation?, Int)>(
        selector: #selector(SegmentedEventProtocol.elegantSegmentedControl(with:at:changeTo:)),
        toArguments: { (location, userInfo) -> [Any] in
            return [userInfo[UserInfoKeys.identifier] ?? (), location ?? (), userInfo[Keys.index]!]
        }) { (params) -> (String?, ViewLocation?, Int) in
            return (params[0] as? String, params[1] as? ViewLocation, params[2] as! Int)
        }

#endif
    
#endif
