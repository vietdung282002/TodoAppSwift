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
    @IBOutlet weak var addNewTodoButton: CustomButton!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    private lazy var todoListVC: TodoListViewController = {
        let todoListViewController = TodoListViewController(nibName: TodoListViewController.className, bundle: nil)
        let todoListNavigator = TodoListNavigator(with: todoListViewController)
        let todoViewModel = TodoListViewModel(navigator: todoListNavigator)
        todoListViewController.viewModel = todoViewModel
        return todoListViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        showTodoList()
        currentDateLabel.text = getCurrentDate()
        
    }
    
    override func setupListener() {
        super.setupListener()
        addNewTodoButton.rx.tap.bind {[weak self] text in
            guard let self = self else { return }
            self.viewModel.openAddTodo(delegate: self)
        }.disposed(by: disposeBag)
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

extension HomeViewController: TodoDetailDelegate{
    func onFinish() {
        todoListVC.reloadData()
    }
}
