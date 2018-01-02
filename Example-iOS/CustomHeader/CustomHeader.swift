//
//  CustomHeader.swift
//  Example-iOS
//
//  Created by TStrawberry on 2017/12/25.
//

import UIKit
import RxElegantReuse

class CustomHeader: UITableViewHeaderFooterView {
    
    var section: Int = -1

    override func locateSection() -> Int {
        return section
    }
    
}
