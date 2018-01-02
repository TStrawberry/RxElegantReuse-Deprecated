//
//  ViewLocatable.swift
//  RxElegantReuse
//
//  Created by TStrawberry on 2017/12/6.
//  Copyright © 2017年 TStrawberry. All rights reserved.
//

#if os(iOS) || os(tvOS)
    
    import UIKit

    public enum ViewLocation {
        
        case indexPath(IndexPath)
        case section(Int)
        
        public var section: Int {
            switch self {
            case let .section(s):
                return s
            case let .indexPath(i):
                return i.section
            }
        }
        
        public var row: Int? {
            return indexPath?.row
        }
        
        public var item: Int? {
            return indexPath?.item
        }
        
        public var indexPath: IndexPath? {
            switch self {
            case let .indexPath(i):
                return i
            default:
                return nil
            }
        }
    }


    
    
    
    
    
    
    @objc public protocol ViewLocatable {
        @objc func locateSection() -> Int
        @objc optional func locateRowOrItem() -> Int
    }

    extension UITableViewHeaderFooterView: ViewLocatable {
        open func locateSection() -> Int { return -1 }
        open func locateRowOrItem() -> Int { return -1 }
    }
    
    extension UICollectionReusableView: ViewLocatable {
        open func locateSection() -> Int { return -1 }
        open func locateRowOrItem() -> Int { return -1 }
    }

    extension ViewLocatable {
        func locate() -> ViewLocation? {
            let section = locateSection()
            guard section >= 0 else { return nil }
            
            if let rowOrItem = locateRowOrItem?(),
                rowOrItem >= 0 {
                return ViewLocation.indexPath([rowOrItem, section])
            } else {
                return ViewLocation.section(section)
            }
        }
    }
    

#endif
