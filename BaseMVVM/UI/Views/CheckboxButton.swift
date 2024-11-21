//
//  CheckboxButton.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 4/20/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CheckboxButton: UIButton {
    let onChecked = BehaviorRelay<Bool>(value: false)
    var todoId = -1
    var disposeBag: DisposeBag = DisposeBag()
    weak var checkboxButtonDelegate: CheckboxButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    private func makeUI() {
        onChecked.subscribe(onNext: { [weak self] isChecked in
            guard let self = self else { return }
            if isChecked {
                self.setImage(UIImage(named: "CheckedTrue"), for: .normal)
            } else {
                self.setImage(UIImage(named: "CheckedFalse"), for: .normal)
            }
        }).disposed(by: disposeBag)
        
        rx.tap.bind { [weak self] () in
            guard let self = self else { return }
//            let isChecked = self.onChecked.value
//            self.onChecked.accept(!isChecked)
            checkboxButtonDelegate?.checkboxButtonTapped(isChecked: !onChecked.value, todoId: todoId)
        }.disposed(by: disposeBag)
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
}

protocol CheckboxButtonDelegate: AnyObject{
    func checkboxButtonTapped(isChecked: Bool, todoId: Int)
}
