//
//  MainVC.swift
//  TodayApp
//
//  Created by shoh on 2022/06/21.
//

import UIKit
import Firebase

@available(iOS 15.0, *)
class MainVC: UIViewController {
    
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
    @IBOutlet weak var bottomStackView: UIStackView!
    
    var keyHeight: CGFloat?
    var todoViewModel: TodoDataViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.loadData()
    }
    
    private func setup() {
        self.navigationItem.title =  dateString()
        self.stackHeight.constant = 0.0
        self.toolbarStack.frame.size.height = 0.0
        self.tableView.clipsToBounds = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.textField.delegate = self
        self.alarmText.text = ""
        self.bottomStackView.isHidden = true
        self.timePicker.backgroundColor = UIColor(named: "BackgroundColor")
        self.timePicker.tintColor = .black
        self.view.bringSubviewToFront(self.addButton)
        self.view.bringSubviewToFront(self.timePicker)
        self.view.keyboardLayoutGuide.topAnchor.constraint(equalTo: self.toolbarStack.bottomAnchor).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.tableView.endEditing(true)
        if self.stackHeight.constant == 80.0 {
            self.bottomStackView.isHidden = true
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
    
    private func loadData() {
        let nowDate = dateString()
        DatabaseService().homeLoadData(table: self.tableView,date: nowDate) { model in
            self.todoViewModel = TodoDataViewModel(todoM: model)
        }
    }
    
    private func timeString(date: Date) -> String {
        let formmater = DateFormatter()
        formmater.timeStyle = .short
        return formmater.string(from: date)
    }
    
    private func dateString() -> String {
        let formmater = DateFormatter()
        formmater.dateFormat = "yy.MM.dd(EEEEE)"
        formmater.locale = Locale(identifier: "ko_KR")
        return formmater.string(from: Date())
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        if self.stackHeight.constant == 0.0 {
            UIView.animate(withDuration: 0.5) {
                self.bottomStackView.isHidden = false
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
    
    @IBAction func tapSaveButton(_ sender: Any) {
        if !self.textField.text!.isEmpty {
            guard let text = self.textField.text else { return }
            guard let alarm = self.alarmText.text else { return }
            let nowDate = dateString()
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            formatter.locale = Locale(identifier: "ko_KR")
            let time = formatter.string(from: Date())
            
            if self.todoViewModel.numberOfRowsInSection() == 0 {
                DatabaseService().addDateDatabase(date: nowDate)
            }
            
            DatabaseService().createTodoListDB(date: Date(), todoText: text, isAlarm: alarm, uploadTime: time, table: self.tableView)
            
            self.bottomStackView.isHidden = true
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
    
    @IBAction func logoutButton(_ sender: Any) {
        try? Auth.auth().signOut()
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

//MARK: TableView DataSource, Delegate
@available(iOS 15.0, *)
extension MainVC: UITableViewDataSource, UITableViewDelegate {
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
            self.tableView.separatorStyle = .none
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath) as! EmptyCell
            cell.updateDate()
            return cell
        } else {
            if self.todoViewModel.numberOfRowsInSection() > 1 {
                self.tableView.separatorStyle = .singleLine
            } else {
                self.tableView.separatorStyle = .none
            }
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if self.todoViewModel.numberOfRowsInSection() == 0 {
            return .none
        }
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            CustomAlert().deletAlert(vc: self,documentId: self.todoViewModel.todoDocumentId(index: indexPath.row))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

//MARK: TextFieldDelagte
@available(iOS 15.0, *)
extension MainVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.bottomStackView.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.stackHeight.constant = 0.0
            self.tableView.clipsToBounds = true
            self.addButton.isHidden = false
            self.textField.text = ""
            self.alarmText.text = ""
            self.timePicker.alpha = 0
        }
        return true
    }
}
