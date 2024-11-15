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

class TodoListViewController: ViewController<TodoListViewModel,TodoListNavigator> {

    @IBOutlet weak var tableView: UITableView!

    private let todoObservable = Observable.of(Todo.sampleData)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
    }
    
    override func setupUI() {
        super.setupUI()
        tableView.register(nibWithCellClass: TodoItemTableViewCell.self)
        todoObservable
            .bind(to: tableView.rx.items(cellIdentifier:TodoItemTableViewCell.className, cellType: TodoItemTableViewCell.self)) { (row, element, cell) in
                cell.titleLabel.text = element.title
                if element.status == true{
                    cell.checkBox.image = UIImage(named: "CheckedTrue")
                }else{
                    cell.checkBox.image = UIImage(named: "CheckedFalse")
                }
            }
            .disposed(by: self.disposeBag)
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 10
    }
    func tableView(_ tableView: UITableView, widthForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width
    }
}
