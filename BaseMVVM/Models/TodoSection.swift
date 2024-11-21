//
//  TodoSection.swift
//  BaseMVVM
//
//  Created by Tong Viet Dung on 19/11/24.
//  Copyright © 2024 thoson.it. All rights reserved.
//
import Foundation
import ObjectMapper
import Differentiator

class TodoSection: SectionModelType {
    var header: String
    var items: [Todo]

    // Initializer
    init(header: String, items: [Todo]) {
        self.header = header
        self.items = items
    }

    required init(original: TodoSection, items: [Todo]) {
        self.header = original.header
        self.items = items
    }
}

extension TodoSection: AnimatableSectionModelType {
    typealias Identity = String
    
    var identity: String {
        return header
    }
}
