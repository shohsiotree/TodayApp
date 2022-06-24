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
        self.todoText.text = todoData.todoText
        self.alarmText.text = todoData.isAlarm
    }
}
