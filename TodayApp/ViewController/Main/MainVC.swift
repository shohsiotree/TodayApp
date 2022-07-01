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
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var settingViewHeight: NSLayoutConstraint!
    
    var todoViewModel: TodoDataViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.loadData()
    }
    
    private func setup() {
        self.navigationItem.title = ChangeFormmater().chagneFormmater(date: Date())
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
        self.view.bringSubviewToFront(self.settingView)
        self.view.keyboardLayoutGuide.topAnchor.constraint(equalTo: self.toolbarStack.bottomAnchor).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("MainVC - touchesBegan")
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
        } else if self.settingViewHeight.constant == 120.0 {
            self.settingViewHeight.constant = 0.0
            self.tableView.clipsToBounds = true
        }
    }
    
    @objc func tapAlaramButton() {
        print("MainVC - tapAlaramButton")
        UIView.animate(withDuration: 0.5) {
            self.timePicker.alpha = 1
            self.alarmButton.setTitle("저장", for: .normal)
        }
    }
    
    @objc func tapSavaButton() {
        print("MainVC - tapSavaButton")
        UIView.animate(withDuration: 0.5) {
            self.timePicker.alpha = 0
            self.alarmButton.setTitle("알람", for: .normal)
        }
    }
    
    private func loadData() {
        print("MainVC - loadData")
        let nowDate = ChangeFormmater().chagneFormmater(date: Date())
        DatabaseService().homeLoadData(table: self.tableView,date: nowDate) { model in
            self.todoViewModel = TodoDataViewModel(todoM: model)
        }
    }
    
    private func timeString(date: Date) -> String {
        print("MainVC - timeString")
        let formmater = DateFormatter()
        formmater.timeStyle = .short
        return formmater.string(from: date)
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        print("MainVC - tapAddButton")
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
        print("MainVC - tapAlarmButton")
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
        print("MainVC - tapSaveButton")
        if !self.textField.text!.isEmpty {
            guard let text = self.textField.text else { return }
            guard let alarm = self.alarmText.text else { return }
            let nowDate = ChangeFormmater().chagneFormmater(date: Date())
            
            if self.todoViewModel.numberOfRowsInSection() == 0 {
                DatabaseService().addDateDatabase(date: nowDate)
            }
            
            DatabaseService().createTodoListDB(date: Date(), todoText: text, isAlarm: alarm, table: self.tableView)
            
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
        print("MainVC - UITableViewCell.EditingStyle.delete")
        if editingStyle == UITableViewCell.EditingStyle.delete {
            CustomAlert().deletAlert(vc: self,documentId: self.todoViewModel.todoDocumentId(index: indexPath.row))
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("MainVC - tdidSelectRowAt")
        DatabaseService().didSelectTodoListDB(date: ChangeFormmater().chagneFormmater(date: Date()), todoData: self.todoViewModel.todoOfCellIndex(index: indexPath.row), table: self.tableView)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: TextFieldDelagte
@available(iOS 15.0, *)
extension MainVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("MainVC - textFieldShouldReturn")
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
