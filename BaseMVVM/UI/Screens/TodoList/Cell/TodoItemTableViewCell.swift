//
//  TodoItemTableViewCell.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 14/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//

import UIKit

class TodoItemTableViewCell: TableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var checkBox: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func bind(viewModel: CellViewModel){
        guard let viewModel = viewModel as? TodoCellViewModel else{
            return
        }
        
        _ = viewModel.item
        viewModel.title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
    
    }
}
