//
//  UIViewController+Extension.swift
//  RxElegantReuse
//
//  Created by TStrawberry on 2017/12/1.
//  Copyright © 2017年 TStrawberry. All rights reserved.
//


#if os(iOS) || os(tvOS)
    import UIKit

    extension UIViewController {
        override open func elegantRouteEvent(with userInfo: [String : Any]?) {
            #if DEBUG
                print("RxElemenReuse - 👇👇👇")
                print("RxElemenReuse should only be used on UITableView/UICollectionView's subviews. Please check your code.")
                print("RxElemenReuse - 👆👆👆")
            #endif
        }
    }

#endif
