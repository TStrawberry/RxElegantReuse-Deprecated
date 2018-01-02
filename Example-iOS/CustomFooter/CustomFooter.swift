//
//  CustomFooter.swift
//  Example-iOS
//
//  Created by TStrawberry on 2017/12/25.
//

import UIKit


class CustomFooter: UITableViewHeaderFooterView, CustomViewProtocol {
    
    @IBOutlet weak var customView: CustomView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customView.delegate = self
    }
    
    func customView(switchTo: Bool) {
        elegantRouteEvent(action: CustomView.swtchAction, otherInfo: ["ISON": switchTo])
    }
}

