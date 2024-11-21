//
//  SignInNavigator.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 4/29/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import UIKit

class SignInNavigator: Navigator {
    
    func pushSignUp() {
        let viewController = SignUpViewController(nibName: SignUpViewController.className, bundle: nil)
        let navigator = SignUpNavigator(with: viewController)
        let viewModel = SignUpViewModel(navigator: navigator)
        viewController.viewModel = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushHome() {
        let viewController = HomeViewController(nibName: HomeViewController.className, bundle: nil)
        let navigator = HomeNavigator(with: viewController)
        let viewModel = HomeViewModel(navigator: navigator)
        viewController.viewModel = viewModel

        navigationController?.pushViewController(viewController, animated: true)

        if var viewControllers = navigationController?.viewControllers, viewControllers.count > 1 {
            viewControllers.remove(at: viewControllers.count - 2)
            navigationController?.viewControllers = viewControllers
        }
    }
}
