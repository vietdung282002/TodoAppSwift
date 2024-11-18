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

class TodoListViewController: ViewController<TodoListViewModel,TodoListNavigator> {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let todoObservable = Observable.of(Todo.sampleData)
    let dataSource = RxTableViewSectionedReloadDataSource<TodoSection>(
        configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: TodoItemTableViewCell.className, for: indexPath) as! TodoItemTableViewCell
            cell.titleLabel.text = item.taskTitle
            if item.isComplete {
                cell.checkBox.image = UIImage(named: "CheckedTrue")
            } else {
                cell.checkBox.image = UIImage(named: "CheckedFalse")
            }
            return cell
        },
        titleForHeaderInSection: { dataSource, sectionIndex in
            let section = dataSource[sectionIndex]
            if section.header == "Incomplete" {
                return nil
            }
            return section.header
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        tableView.separatorStyle = .none
        viewModel.reloadData()

    }
    
    override func setupUI() {
        super.setupUI()
        tableView.register(nibWithCellClass: TodoItemTableViewCell.self)
        
        //        todoObservable
        //            .bind(to: tableView.rx.items(cellIdentifier:TodoItemTableViewCell.className, cellType: TodoItemTableViewCell.self)) { (row, element, cell) in
        //                cell.titleLabel.text = element.title
        //                if element.status == true{
        //                    cell.checkBox.image = UIImage(named: "CheckedTrue")
        //                }else{
        //                    cell.checkBox.image = UIImage(named: "CheckedFalse")
        //                }
        //            }
        //            .disposed(by: self.disposeBag)
        
        let sectionsObservable = Observable.just(sections)
        
        sectionsObservable
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 8
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
