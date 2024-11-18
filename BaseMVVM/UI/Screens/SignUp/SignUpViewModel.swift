//
//  SignUpViewModel.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 4/20/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModel {
    // MARK: Public Properties
    
    // MARK: Private Properties
    private let navigator: SignUpNavigator
    
    private let email = BehaviorRelay(value: "")
    private let password = BehaviorRelay(value: "")
    
    init(navigator: SignUpNavigator) {
        self.navigator = navigator
        super.init(navigator: navigator)
    }
    
    // MARK: Public Function
    
    func changeEmai(email: String) -> Void {
        self.email.accept(email)
    }
    
    func changePassword(password: String) -> Void {
        self.password.accept(password)
    }
    
    func signUp() {
        let email = self.email.value
        if email.isEmpty {
            navigator.showAlert(title: "Common.Error".localized(),
                                message: "Login.Username.Empty".localized())
            return
        }
        let password = self.password.value
        if password.isEmpty {
            navigator.showAlert(title: "Common.Error".localized(),
                                message: "Login.Password.Empty".localized())
            return
        }
        
        Application.shared
            .apiProvider
            .register(email: email, password: password)
            .trackActivity(loadingIndicator)
            .subscribe(onNext: { [weak self] authResponse in
                guard let self = self else { return }
                //Save data
                print(authResponse.accessToken ?? "")
                var token = Token()
                token.accessToken = authResponse.accessToken
                AuthManager.shared.token = token
                
                let user = authResponse.user
                if user != nil{
                    UserManager.shared.saveUser(user!)
                }
                self.openHome()
            }, onError: {[weak self] error in
                self?.navigator.showAlert(title: "Common.Error".localized(),
                                          message: "Login.Username.Password.Invalid".localized())
            }).disposed(by: disposeBag)
    }
    
    func openHome(){
        navigator.pushHome()
    }
    
    // MARK: Private Function
    

}
