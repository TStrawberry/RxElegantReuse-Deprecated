//
//  CustomView.swift
//  Example-iOS
//
//  Created by TStrawberry on 2017/12/25.
//

import UIKit

import RxCocoa
import RxElegantReuse


@objc protocol CustomViewProtocol {
    @objc optional func customView(switchTo: Bool)
}


class CustomView: UIView {
    
    static let swtchAction: ResponderAction<Bool> = {
        ResponderAction<Bool>(
            selector: #selector(CustomViewProtocol.customView(switchTo:)),
            toArguments: { (location, userInfo) -> [Any] in
            return [userInfo["ISON"] ?? ()]
        }, toElements: { (params) -> Bool in
            return params[0] as! Bool
        })
    }()
    
    
    private let label: UILabel = UILabel()
    private let `switch`: UISwitch = UISwitch()
    
    weak var delegate: CustomViewProtocol?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initial()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initial()
    }
    
    private func initial() {
        label.text = "CustomView"
        addSubview(label)
        addSubview(`switch`)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        `switch`.translatesAutoresizingMaskIntoConstraints = false
        
        `switch`.addTarget(self, action: #selector(switched(_:)), for: .valueChanged)
    }
    
    @objc func switched(_ s: UISwitch) {
        self.delegate?.customView?(switchTo: s.isOn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let constrains: [NSLayoutConstraint] = [
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            `switch`.centerXAnchor.constraint(equalTo: centerXAnchor),
            `switch`.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constrains)
    }
    
}

