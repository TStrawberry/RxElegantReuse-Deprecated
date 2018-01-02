//
//  ViewController.swift
//  Example-iOS
//
//  Created by TStrawberry on 2017/12/13.
//

import UIKit
import RxSwift
import RxCocoa
import RxElegantReuse
import RxDataSources

@objc protocol Test {
    @objc func test(i: Int, d: Double)
}





class TableViewController: UITableViewController {

    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        
        Observable.just(Array(repeating: 0, count: 10))
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self), curriedArgument: {
                (_, _, cell) in

            })
            .disposed(by: bag)

        tableView.rx.buttonTapped
            .subscribe(onNext: { (values) in
                print(values)
            })
            .disposed(by: bag)

        tableView.rx.segmentSelected
            .subscribe(onNext: { (values) in
                print(values.2)
            })
            .disposed(by: bag)

        tableView.rx.switched
            .subscribe(onNext: { (values) in
                print(values.2)
            })
            .disposed(by: bag)

        tableView.rx.slided
            .subscribe(onNext: { (values) in
                print(values.2)
            })
            .disposed(by: bag)


        tableView.rx.stepperTriggered
            .subscribe(onNext: { (values) in
                print(values.2)
            })
            .disposed(by: bag)

        tableView.rx.textChanged
            .subscribe(onNext: { (values) in
                print(values.2 ?? "")
            })
            .disposed(by: bag)
        
        
        
    }
}


class CustomExampleTableViewController: UITableViewController {
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        tableView.rx.delegate.setForwardToDelegate(self, retainDelegate: false)
        
        tableView.register(UINib.init(nibName: "CustomHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "Header")
        tableView.register(UINib.init(nibName: "CustomFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "Footer")
        
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>.init(configureCell: { (dataSource, tableView, indexPath, model) -> UITableViewCell in
            return tableView.dequeueReusableCell(withIdentifier: "Cell")!
        })
        
        let sectionModel = SectionModel<String, Int>(model: "model", items: [1, 2, 3, 4])
        let sectionModels = Array(repeating: sectionModel, count: 4)
        
        Observable.just(sectionModels)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        tableView.rx.buttonTapped
            .subscribe(onNext: { (values) in
                print(values)
            })
            .disposed(by: bag)
        
        tableView.rx.createControlEvent(action: CustomView.swtchAction)
            .subscribe( onNext: { (values) in
                print(values)
            })
            .disposed(by: bag)
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header") as? CustomHeader
        header?.section = section
        return header
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
     
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Footer") as? CustomHeader
        return footer
    }
    
    
}




