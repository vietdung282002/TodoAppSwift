//
//  HomeViewController.swift
//  BaseMVVM
//
//  Created by Lê Thọ Sơn on 4/21/20.
//  Copyright © 2020 thoson.it. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: ViewController<HomeViewModel, HomeNavigator> {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addNewTodoButton: UIButton!
    
    private lazy var todoListVC: TodoListViewController = {
        let viewController = TodoListViewController(nibName: TodoListViewController.className, bundle: nil)
        let navigator = TodoListNavigator(with: viewController)
        let viewModel = TodoListViewModel(navigator: navigator)
        viewController.viewModel = viewModel
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        showTodoList()
        addNewTodoButton.rx.tap.bind {[weak self] text in
            guard let self = self else { return }
            self.viewModel.openAddTodo()
//            let controller = TestViewController()
//            navigationController?.pushViewController(controller, animated: true)
        }.disposed(by: disposeBag)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func setupUI() {
        super.setupUI()
    }
    
    override func setupListener() {
        super.setupListener()
    }
    
    //Show list data
    private func showTodoList() {
        addChild(todoListVC)
        containerView.addSubview(todoListVC.view)
        todoListVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            todoListVC.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            todoListVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            todoListVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            todoListVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        todoListVC.didMove(toParent: self)
    }
}
