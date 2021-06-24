//
//  CViewController.swift
//  MillionTimeProject
//
//  Created by Костицина Елизавета Константиновна on 21.06.2021.
//

//c) UITableView с выводом 20 разных имён людей и две кнопки. Одна кнопка добавляет новое случайное имя в начало списка, вторая — удаляет последнее имя. Список реактивно связан с UITableView.
//f) Для задачи «c» добавьте поисковую строку. При вводе текста в поисковой строке, если текст не изменялся в течение двух секунд, выполните фильтрацию имён по введённой поисковой строке (с помощью оператора throttle). Такой подход применяется в реальных приложениях при поиске, который отправляет поисковый запрос на сервер, — чтобы не перегружать сервер и поисковая строка отправлялась на сервер, только когда пользователь закончит ввод (или сделает паузу во вводе).

import UIKit
import RxSwift
import RxCocoa

class CViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var searchbar: UISearchBar!
    
    
    let disposeBag = DisposeBag()
    
    var namesSource =  ["Vanya","Masha","Petya","Katya","Vasya","Sveta","Dima","Kostya","Olya","Vera","Jenya","Tanya","Dasha","Lesha","Lena","Stepa","Misha","Gosha","Valera","Vitya"]
    var names =  [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ps = PublishSubject<[String]>()
        ps.bind(to: tableView.rx.items(cellIdentifier: "Cell")){
            (tableView, item, cell) in
            cell.textLabel?.text = item
        }.disposed(by: disposeBag)
        
        
        buttonAdd.rx.tap.subscribe(onNext: { [weak self] _ in
            
            let name = self?.namesSource.randomElement()
            if let name = name {
                self?.names.insert(name, at: 0)
                ps.on(.next(self!.names))
            }
        }).disposed(by: disposeBag)
        
        buttonDelete.rx.tap.subscribe(onNext: { [weak self] _ in
            
            self?.names.removeLast()
            ps.on(.next(self!.names))
        }).disposed(by: disposeBag)
        
        
        _ = searchbar.rx.text.orEmpty
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map({  [weak self]  query in
                self!.names.filter { name in
                    query.isEmpty || name.lowercased().contains(query.lowercased())
                }
            }).subscribe (onNext:{
                            ps.on(.next($0))
                        }
            ).disposed(by: disposeBag)
        
    }
    
}
