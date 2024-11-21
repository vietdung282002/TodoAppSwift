//
//  TodoListViewController.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 14/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TodoListViewController: ViewController<TodoListViewModel,TodoListNavigator>,TodoDetailDelegate{
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private let isPullToRefreshing = BehaviorRelay(value: false)
    private let isLoadingNextPage = BehaviorRelay(value: false)
    private var todoDetailViewModel: TodoDetailViewModel!
    
    private var todoDetailDelegate: TodoDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        viewModel.todoListDelegate = self
    }
    
    override func setupUI() {
        super.setupUI()
        tableView.separatorStyle = .none
        reloadData()
        tableView.refreshControl = refreshControl
        
        tableView.register(nibWithCellClass: NotCompleteTodoItemTableViewCell.self)
        tableView.register(nibWithCellClass: CompletedTodoTableViewCell.self)
        
        isPullToRefreshing.subscribe(onNext: { [weak self] (isLoading) in
            guard let self = self else { return }
            if isLoading {
                self.refreshControl.beginRefreshing()
            } else {
                self.refreshControl.endRefreshing()
            }
        }).disposed(by: disposeBag)
    }
    
    override func setupListener(){
        super.setupListener()
        
        refreshControl.rx.controlEvent(.valueChanged).bind { [weak self] _ in
            guard let self = self else { return }
            
            reloadData()
        }.disposed(by: disposeBag)
        
        
        viewModel.todoDataSource.configureCell = { (dataSource, tableView, indexPath, item) in
            let cellIdentifier = item.isComplete ? CompletedTodoTableViewCell.className : NotCompleteTodoItemTableViewCell.className
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            if let todoCell = cell as? TodoCellConfigurable {
                todoCell.configure(with: item, checkboxButtonDelegate: self)
            }
            
            return cell
            
        }
        
        viewModel.todoDataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .fade,
                                                                                 reloadAnimation: .fade,
                                                                                 deleteAnimation: .fade)
        
        viewModel.todoDataSource.titleForHeaderInSection = { dataSource, sectionIndex in
            let section = dataSource[sectionIndex]
            if section.header == "Incomplete" {
                return nil
            }
            return "Home.Complete.Header".localized()
        }
        
        viewModel.todoDataSource.canEditRowAtIndexPath = { (dataSource, IndexPath) in
            return true
        }
        
        if let todoDatasource = viewModel?.todoDataSource {
            viewModel?.todos
                .map { todos in
                    let incompleteTodos = todos.filter { !$0.isComplete }
                    let completeTodos = todos.filter { $0.isComplete }
                    return [
                        TodoSection(header: "Incomplete", items: incompleteTodos),
                        TodoSection(header: "Complete", items: completeTodos)
                    ]
                }
                .asDriver(onErrorJustReturn: [])
                .drive(self.tableView.rx.items(dataSource: todoDatasource))
                .disposed(by: self.disposeBag)
        }
        
        tableView.rx.modelSelected(Todo.self).bind { [weak self] todo in
            guard let self = self else { return }
            self.viewModel.handleItemTapped(todo: todo, delegate: self)
        }.disposed(by: disposeBag)
        
        tableView.rx.modelDeleted(Todo.self)
            .bind { [weak self] todo in
                guard let self = self else { return }
                viewModel.deleteTodo(todoId: todo.todoId!)
            }.disposed(by: disposeBag)
    }
    
    func reloadData(){
        viewModel.reloadData()
    }
    
    func onFinish() {
        reloadData()
    }
    
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 77
    }
    func tableView(_ tableView: UITableView, widthForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
    }
}

extension TodoListViewController: TodoListViewModelDelegate{
    func isLoadingTodo(loading: Bool) {
        if loading{
            isPullToRefreshing.accept(true)
        }else{
            isPullToRefreshing.accept(false)
        }
    }
}

extension TodoListViewController:CheckboxButtonDelegate{
    func checkboxButtonTapped(isChecked: Bool, todoId: Int) {
        viewModel.checkTodo(todoId: todoId, isChecked: isChecked)
    }
}

protocol TodoCellConfigurable {
    func configure(with item: Todo, checkboxButtonDelegate:CheckboxButtonDelegate)
}
