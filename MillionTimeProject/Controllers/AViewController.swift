//
//  AViewController.swift
//  MillionTimeProject
//
//  Created by Костицина Елизавета Константиновна on 20.06.2021.
//

import UIKit
import RxSwift
import RxCocoa

//a) Два текстовых поля. Логин и пароль, под ними лейбл и ниже кнопка «Отправить». В лейбл выводится «некорректная почта», если введённая почта некорректна. Если почта корректна, но пароль меньше шести символов, выводится: «Слишком короткий пароль». В противном случае ничего не выводится. Кнопка «Отправить» активна, если введена корректная почта и пароль не менее шести символов.
//b) Текстовое поле для ввода поисковой строки. Реализуйте симуляцию «отложенного» серверного запроса при вводе текста: если не было внесено никаких изменений в текстовое поле в течение 0,5 секунд, то в консоль должно выводиться: «Отправка запроса для <введенный текст в текстовое поле>».


class ABViewController: UIViewController {
    
    @IBOutlet weak var mailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let disposeBag = DisposeBag()
    
    var passwordIsCorrect = false
    var mailIsCorrect = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - SearchBar Binding
        
        searchBar
            .rx.text.throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .filter { if let text = $0 { return
                !text.isEmpty} else { return false } }
            .subscribe {  query in
                if let el = query.element, let str = el {
                    print("Отправка запроса для \(str)")
                }
                
            }
            .disposed(by:disposeBag)
        
        self.button.isEnabled = false
        
        //MARK: - MailTextfeld Binding
        
        mailTextfield.rx.text.bind { mail in
            
                self.checkMail(mail: mail)
                
            self.button.isEnabled = self.mailIsCorrect && self.passwordIsCorrect
            
        }.disposed(by: disposeBag)
        
        //MARK: - PasswordTextfeld Binding
        
        passwordTextfield.rx.text.bind { password in
            
            self.checkPassword(password: password)
            
            self.button.isEnabled = self.passwordIsCorrect && self.mailIsCorrect
            
            
        }.disposed(by: disposeBag)
        
        
    }
    
    //MARK: - FunctionForCheckingPassword
    
    func checkPassword(password: String?) {
        
        passwordIsCorrect = false
        
        guard let password = password, !(password.count == 0) else {return}
        
        
        if password.count < 6 {
            
            self.label.text = "Слишком короткий пароль"
            
        }  else {
            
            self.label.text = ""
            passwordIsCorrect = true
            
        }
    }
    
    //MARK: - FunctionForCheckingMail
    
    func checkMail(mail: String?) {
        
        mailIsCorrect = false
        
        guard let mail = mail, !(mail.count == 0) else {return}
        
        if mail.hasSuffix("@mail.ru") || mail.hasSuffix("@gmail.ru")  {
            
            self.label.text = ""
            mailIsCorrect = true
            
        } else {
            self.label.text = "Некорректная почта"
        }
    }
    
    
}

