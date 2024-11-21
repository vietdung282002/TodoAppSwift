//
//  TodoItemTableViewCell.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 14/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//

import UIKit
import RxSwift

class NotCompleteTodoItemTableViewCell: TableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var checkBoxButton: CheckboxButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension NotCompleteTodoItemTableViewCell: TodoCellConfigurable {
    func configure(with item: Todo,checkboxButtonDelegate: CheckboxButtonDelegate) {
        titleLabel.text = item.taskTitle
        typeImage.image = item.categoryImage(for: item.categoryId)
        timeLabel.text = item.formattedTime()
        checkBoxButton.todoId = item.todoId!
        checkBoxButton.onChecked.accept(item.isComplete)
        checkBoxButton.checkboxButtonDelegate = checkboxButtonDelegate
        checkBoxButton.onChecked.subscribe(onNext: { [weak self] isChecked in
            guard self != nil else { return }
            item.isComplete = isChecked
        }).disposed(by: DisposeBag())
    }
}

