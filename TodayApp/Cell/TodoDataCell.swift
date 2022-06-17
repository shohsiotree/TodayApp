//
//  TodoDataCell.swift
//  TodayApp
//
//  Created by shoh on 2022/06/17.
//

import UIKit

class TodoDataCell: UITableViewCell {
    @IBOutlet weak var todoButton: UIButton!
    @IBOutlet weak var todoText: UILabel!
    
    func updateTodo(todoData: TodoDataModel) {
        if todoData.check == 0 {
            self.todoButton.setImage(UIImage(named: "unCheck"), for: .normal)
            self.todoText.textColor = .black
            self.todoText.text = todoData.todoText
        } else if todoData.check == 1 {
            self.todoButton.setImage(UIImage(named: "check"), for: .selected)
            self.todoText.text = todoData.todoText
            self.todoText.textColor = UIColor(named: "textColor")
        }
    }
    
    @objc func tapButton() {
        if self.todoButton.currentImage == UIImage(named: "unCheck") {
            self.todoButton.setImage(UIImage(named: "check"), for: .selected)
            self.todoText.textColor = UIColor(named: "textColor")
        } else if self.todoButton.currentImage == UIImage(named: "check") {
            self.todoButton.setImage(UIImage(named: "unCheck"), for: .normal)
            self.todoText.textColor = .black
        }
    }
}
