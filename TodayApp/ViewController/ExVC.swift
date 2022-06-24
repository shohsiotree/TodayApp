//
//  ExVC.swift
//  TodayApp
//
//  Created by shoh on 2022/06/21.
//

import UIKit
import Firebase

class ExVC: UIViewController {
    
    @IBOutlet weak var toolbarStack: UIStackView!
    @IBOutlet weak var textToolbar: UIToolbar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var alarmText: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var timePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var alarmButton: UIButton!
    
    var keyHeight: CGFloat?
    var numberOfCount = 1
    var todoViewModel: TodoDataViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title =  dateString()
        self.loadData()
        self.stackHeight.constant = 0.0
        self.tableView.clipsToBounds = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.alarmText.text = ""
        self.timePicker.backgroundColor = UIColor(named: "BackgroundColor")
        self.timePicker.tintColor = .black
        self.view.bringSubviewToFront(self.addButton)
        self.view.bringSubviewToFront(self.timePicker)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.tableView.endEditing(true)
        if self.stackHeight.constant == 80.0 {
            UIView.animate(withDuration: 0.5) {
                self.stackHeight.constant = 0.0
                self.tableView.clipsToBounds = true
                self.addButton.isHidden = false
                self.textField.text = ""
                self.alarmText.text = ""
                self.timePicker.alpha = 0
            }
        }
    }
    
    @objc func tapAlaramButton() {
        UIView.animate(withDuration: 0.5) {
            self.timePicker.alpha = 1
            self.alarmButton.setTitle("저장", for: .normal)
        }
    }
    @objc func tapSavaButton() {
        UIView.animate(withDuration: 0.5) {
            self.timePicker.alpha = 0
            self.alarmButton.setTitle("알람", for: .normal)
        }
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        self.keyHeight = keyboardHeight
        self.tableView.frame.size.height -= keyboardHeight
        self.view.frame.size.height -= keyboardHeight
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.tableView.frame.size.height += self.keyHeight!
        self.view.frame.size.height += self.keyHeight!
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        if self.stackHeight.constant == 0.0 {
            UIView.animate(withDuration: 0.5) {
                self.stackHeight.constant = 80.0
                self.tableView.clipsToBounds = true
                self.addButton.isHidden = true
                self.textField.becomeFirstResponder()
            }
        }
    }
    
    @IBAction func tapAlarmButton(_ sender: Any) {
        //TODO: 알람 데이트 피커 열기
        if self.timePicker.alpha == 0 && self.alarmButton.currentTitle == "알람" {
            UIView.animate(withDuration: 0.5) {
                self.timePicker.alpha = 1
                self.alarmButton.setTitle("추가", for: .normal)
            }
        } else if self.timePicker.alpha == 1 && self.alarmButton.currentTitle == "추가"{
            UIView.animate(withDuration: 0.5) {
                self.timePicker.alpha = 0
                self.alarmButton.setTitle("알람", for: .normal)
                self.alarmText.text = self.timeString(date: self.timePicker.date)
                print(self.timeString(date: self.timePicker.date))
            }
        }
    }
    
    func timeString(date: Date) -> String {
        let formmater = DateFormatter()
        formmater.timeStyle = .short
        return formmater.string(from: date)
    }
    
    func dateString() -> String {
        let formmater = DateFormatter()
        formmater.dateFormat = "yy.MM.dd(EEEEE)"
        formmater.locale = Locale(identifier: "ko_KR")
        return formmater.string(from: Date())
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
        if !self.textField.text!.isEmpty {
            guard let text = self.textField.text else { return }
            guard let alarm = self.alarmText.text else { return }
            
            let todayAlarm = alarm != "" ? alarm : ""
            let nowDate = dateString()
            guard let numbers = self.todoViewModel?.todoNumberCount() else { return }
            
            if numbers != 0 {
                DatabaseService().updateTodoListDB(date: Date(), number: numbers+1, todoText: text, isAlarm: todayAlarm, isDone: false, table: self.tableView)
            } else {
                DatabaseService().createTodoListDB(date: Date(), todoText: text, isAlarm: todayAlarm, table: self.tableView)
            }
            
            UIView.animate(withDuration: 0.5) {
                self.stackHeight.constant = 0.0
                self.tableView.clipsToBounds = true
                self.addButton.isHidden = false
                self.textField.text = ""
                self.alarmText.text = ""
                self.timePicker.alpha = 0
                self.view.endEditing(true)
            }
            print("alarm: \(alarm), text: \(text), now: \(nowDate)")
        }
        self.tableView.reloadData()
    }
    
    private func loadData() {
        let nowDate = dateString()
        DispatchQueue.main.async {
            DatabaseService().homeLoadData(table: self.tableView,date: nowDate) { model in
                self.todoViewModel = TodoDataViewModel(todoM: model)
            }
        }
    }
    
    @objc func reloadTable() {
        
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        try? Auth.auth().signOut()
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
}

extension ExVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.todoViewModel != nil {
            if  self.todoViewModel.numberOfRowsInSection() == 0 {
                return 1
            } else {
                return self.todoViewModel.numberOfRowsInSection()
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.todoViewModel.numberOfRowsInSection() == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
            cell.updateTodo(todoData: self.todoViewModel.todoOfCellIndex(index: indexPath.row))
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.todoViewModel.numberOfRowsInSection() == 0 {
            return CGFloat(UIScreen.main.bounds.height / 2 - 50)
        } else {
            return CGFloat(UIScreen.main.bounds.height / 7)
        }
    }
}
