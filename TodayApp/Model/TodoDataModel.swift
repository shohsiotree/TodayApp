//
//  TodoDataModel.swift
//  TodayApp
//
//  Created by shoh on 2022/06/17.
//

import Foundation

struct TodoDataModel {
    var todoText: String?
    var check: Int?
    
    init(todoText: String, check: Int) {
        self.todoText = todoText
        self.check = check
    }
}
