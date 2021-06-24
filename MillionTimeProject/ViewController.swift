//
//  ViewController.swift
//  MillionTimeProject
//
//  Created by Костицина Елизавета Константиновна on 17.05.2021.
//
import RxCocoa
import RxSwift
import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var items = Observable.just(["Item1","Item2","Item3","Item4"])
    let disposableBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        items
            .bind(to: tableView
                    .rx
                    .items(cellIdentifier: "myCell")) {
                (tableView, item, cell) in
                cell.textLabel?.text = item
            }
            .disposed(by: disposableBag)
        
    }
   

}

