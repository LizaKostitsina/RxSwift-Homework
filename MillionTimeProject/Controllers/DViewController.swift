//
//  DViewController.swift
//  MillionTimeProject
//
//  Created by Костицина Елизавета Константиновна on 22.06.2021.

//   d) Лейбл и кнопку. В лейбле выводится значение counter (по умолчанию 0), при нажатии counter увеличивается на 1.

//  e) Две кнопки и лейбл. Когда на каждую кнопку нажали хотя бы один раз, в лейбл выводится: «Ракета запущена».

import UIKit
import RxCocoa
import RxSwift

class DViewController: UIViewController {
    
    @IBOutlet weak var labelCounter : UILabel!
    @IBOutlet weak var button : UIButton!
    @IBOutlet weak var firstButton : UIButton!
    @IBOutlet weak var secondButton : UIButton!
    @IBOutlet weak var labelRocket : UILabel!
    
    let disposeBag = DisposeBag()
    
    var counter = 0
    var firstButtonWasTapped = false
    var secondButtonWasTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.rx.tap.bind {
            self.counter += 1
            self.labelCounter.text = ("\(self.counter) times")
        }.disposed(by: disposeBag)
        
        firstButton.rx.tap.bind {
            self.firstButtonWasTapped = true
            self.labelRocket.text = self.firstButtonWasTapped && self.secondButtonWasTapped ? "Ракета была запущена" : "Ракета не была запущена"
        }.disposed(by: disposeBag)
        
        secondButton.rx.tap.bind {
            self.secondButtonWasTapped = true
            self.labelRocket.text = self.firstButtonWasTapped && self.secondButtonWasTapped ? "Ракета была запущена" : "Ракета не была запущена"
        }.disposed(by: disposeBag)
        
        
    }
    

  

}
