//
//  SignUpViewController.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 4/20/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: ViewController<SignUpViewModel, SignUpNavigator> {
    @IBOutlet weak private var signUpButton: CustomButton!
    @IBOutlet weak private var emailTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        showLeftButton()
    }
    
    override func setupListener() {
        super.setupListener()
        
        emailTextField.rx.text.orEmpty.bind { [weak self] text in
            guard let self = self else { return }
            self.viewModel.changeEmai(email: text)
        }.disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty.bind { [weak self] text in
            guard let self = self else { return }
            self.viewModel.changePassword(password: text)
        }.disposed(by: disposeBag)
        
        signUpButton.rx.tap.bind { [weak self] text in
            guard let self = self else { return }
            self.viewModel.signUp()
        }.disposed(by: disposeBag)
        
        viewModel.loadingIndicator.asObservable().bind(to: isLoading).disposed(by: disposeBag)
    }
}
