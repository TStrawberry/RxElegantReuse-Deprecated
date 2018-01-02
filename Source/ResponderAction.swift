//
//  ResponderAction.swift
//  RxElegantReuse
//
//  Created by TStrawberry on 2017/12/6.
//  Copyright © 2017年 TStrawberry. All rights reserved.
//

import UIKit


protocol ResponderActionProtocol {
    
//    associatedtype Elements
    
    var selector    : Selector { get }
    var toArguments : (ViewLocation?, [String: Any]) -> [Any] { get }
//    var toElements    : ([Any]) -> Elements { get }
}



public struct ResponderAction<Elements>: ResponderActionProtocol {
    
    typealias E = Elements
    
//    /// A selector performed on DelegateProxy.
//    /// Its relative method usually exists in a protocol which is conformed by RxTableViewDelegateProxy or RxCollectionViewDelegateProxy or both.
    let selector    : Selector
    
    /// A clouser which tranforms it's params to a array which's elements should be upper `selector`'s arguments.
    let toArguments : (ViewLocation?, [String: Any]) -> [Any]
    
    /// A clouser which tranforms its params to a instance of `Values` type, and its params comes from upper `toArguments` clouser.
    let toElements    : ([Any]) -> Elements
    
    
    public init(selector: Selector, toArguments: @escaping (ViewLocation?,[String: Any]) -> [Any], toElements: @escaping ([Any]) -> Elements) {
        self.selector = selector
        self.toArguments = toArguments
        self.toElements = toElements
    }
    
    
    
    
}


