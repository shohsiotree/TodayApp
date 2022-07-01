//
//  TodoCell.swift
//  TodayApp
//
//  Created by shoh on 2022/06/17.
//

import UIKit

class TodoCell: UITableViewCell {
    @IBOutlet weak var todoText: UILabel!
    @IBOutlet weak var alarmText: UILabel!
    func updateTodo(todoData: TodoDataModel) {
        if todoData.isDone == true {
            self.todoText.textColor = .lightGray
            self.todoText.text = todoData.todoText
        } else if todoData.isDone == false {
            self.todoText.textColor = .black
            self.todoText.text = todoData.todoText
        }
        self.alarmText.text = todoData.isAlarm
    }
}
