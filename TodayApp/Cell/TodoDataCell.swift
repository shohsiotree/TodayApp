//
//  TodoDataCell.swift
//  TodayApp
//
//  Created by shoh on 2022/06/17.
//

import UIKit

class TodoDataCell: UITableViewCell {
    @IBOutlet weak var todoText: UILabel!
    
    func updateTodo(todoData: TodoDataModel) {
        if todoData.check {
            self.accessoryType = .checkmark
            self.todoText.textColor = UIColor(named: "textColor")
            self.todoText.text = todoData.todoText
        }else {
            self.accessoryType = .none
            self.todoText.textColor = .black
            self.todoText.text = todoData.todoText            
        }
    }
}
