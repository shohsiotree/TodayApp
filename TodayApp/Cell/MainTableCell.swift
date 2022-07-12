//
//  MainTableCell.swift
//  TodayApp
//
//  Created by shoh on 2022/07/12.
//

import UIKit

class MainTableCell: UITableViewCell {
    
    @IBOutlet weak var todoText: UILabel!
    @IBOutlet weak var alarmText: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    var todoDataModel: [TodoDataModel]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateTodo(todoData: TodoDataModel) {
        if todoData.isDone == true {
            self.todoText.textColor = .lightGray
            self.todoText.text = todoData.todoText
        } else if todoData.isDone == false {
            self.todoText.textColor = .black
            self.todoText.text = todoData.todoText
        }
        if todoData.isAlarm == "" {
            self.alarmText.text = ""
            self.alarmSwitch.isHidden = true
        } else {
            self.alarmText.text = todoData.isAlarm
            self.alarmSwitch.isHidden = false
        }
        
    }
    
    @IBAction func tapAlarmSwitch(_ sender: UISwitch) {
        //알림 끄고 키기 연동
        let index = sender.tag
        let isAlarm = self.todoDataModel![index].isAlarm
        //TODO: 로컬 푸시 알림 끄기 및 켜기
        
    }
}
