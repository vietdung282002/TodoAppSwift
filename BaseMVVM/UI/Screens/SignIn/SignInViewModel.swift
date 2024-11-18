//
//  SignInViewModel.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 4/29/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class SignInViewModel: ViewModel {
    // MARK: Public Properties
    
    // MARK: Private Properties
    private let navigator: SignInNavigator
    
    init(navigator: SignInNavigator) {
        self.navigator = navigator
        super.init(navigator: navigator)
    }
    
    // MARK: Public Function
    func signIn(email: String, password: String) {
        if email.isEmpty {
            navigator.showAlert(title: "Common.Error".localized(),
                                message: "Login.Username.Empty".localized())
            return
        }
        if password.isEmpty {
            navigator.showAlert(title: "Common.Error".localized(),
                                message: "Login.Password.Empty".localized())
            return
        }
        
        Application.shared
            .apiProvider
            .login(email: email, password: password)
            .trackActivity(loadingIndicator)
            .subscribe(onNext: { [weak self] authResponse in
                guard let self = self else { return }
                //Save data

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
    
    func openSignUp() {
        navigator.pushSignUp()
    }
    
    func openHome(){
        navigator.pushHome()
    }
    
    // MARK: Private Function

}
