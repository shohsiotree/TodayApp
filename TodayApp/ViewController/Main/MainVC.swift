//
//  MainVC.swift
//  TodayApp
//
//  Created by shoh on 2022/06/21.
//

import UIKit
import Firebase
import UserNotifications

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
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var sideMenuWidth: NSLayoutConstraint!
    @IBOutlet weak var settingTable: UITableView!
    
    var todoViewModel: TodoDataViewModel!
    let settingArr = ["예제샘플1","예제샘플2","예제샘플3","예제샘플4"]
    var alarmTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkAuth()
        self.setup()
        self.loadData()
    }
    
    private func checkAuth() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { result, err in
            if result == false {
                let alert = UIAlertController(title: "알림", message: "권한 설정 후 실행해주세요.", preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default) { _ in
                    exit(1)
                }
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        }
    }
    
    private func setup() {
        self.navigationItem.title = ChangeFormmater().chagneFormmater(date: Date())
        self.navigationItem.backButtonTitle = "뒤로"
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
        self.sideMenuWidth.constant = 0.0
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "새로고침")
        refresh.addTarget(self, action: #selector(reloadData(_:)), for: .valueChanged)
        self.tableView.refreshControl = refresh
        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTableview)))
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
        }
        
        if self.sideMenuWidth.constant > 0 {
            UIView.animate(withDuration: 0.5) {
                self.sideMenuWidth.constant = 0
                self.addButton.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
        
        self.timePicker.alpha = 0
        self.alarmButton.setTitle("알람", for: .normal)
    }
    
    @objc func tapTableview() {
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
        
        if self.sideMenuWidth.constant > 0 {
            UIView.animate(withDuration: 0.5) {
                self.sideMenuWidth.constant = 0
                self.addButton.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
        
        self.timePicker.alpha = 0
        self.alarmButton.setTitle("알람", for: .normal)
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
    
    @objc func reloadData(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        self.loadData()
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
            print("MainVC - tapAlarmButton: 알람")
            UIView.animate(withDuration: 0.5) {
                self.timePicker.alpha = 1
                self.alarmButton.setTitle("추가", for: .normal)
            }
        } else if self.timePicker.alpha == 1 && self.alarmButton.currentTitle == "추가"{
            print("MainVC - tapAlarmButton: 추가")
            UIView.animate(withDuration: 0.5) {
                self.timePicker.alpha = 0
                self.alarmButton.setTitle("알람", for: .normal)
                self.alarmText.text = self.timeString(date: self.timePicker.date)
                self.alarmTime = self.timePicker.date
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
            if alarm != "", let time = self.alarmTime {
                let content = UNMutableNotificationContent()
                content.title = "알림"
                content.body = text
                content.sound = .default
                content.badge = 1

                let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

                let uuid = UUID().uuidString
                let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request)
            }

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
        }
        
        self.timePicker.alpha = 0
        self.alarmButton.setTitle("알람", for: .normal)
        self.tableView.reloadData()
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        
        if self.sideMenuWidth.constant > 0 {
            UIView.animate(withDuration: 0.5) {
                self.sideMenuWidth.constant = 0.0
                self.addButton.alpha = 1
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.sideMenuWidth.constant = 120.0
                self.addButton.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
        //        try? Auth.auth().signOut()
        //        guard let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") else { return }
        //        vc.modalPresentationStyle = .fullScreen
        //        self.present(vc, animated: true)
        
    }
}

//MARK: TableView DataSource, Delegate
@available(iOS 15.0, *)
extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            if self.todoViewModel != nil {
                if  self.todoViewModel.numberOfRowsInSection() == 0 {
                    return 1
                } else {
                    return self.todoViewModel.numberOfRowsInSection()
                }
            } else {
                return 0
            }
        } else if tableView == self.settingTable {
            return self.settingArr.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
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
        } else if tableView == self.settingTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingCell
            cell.settingText.text = self.settingArr[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            if self.todoViewModel.numberOfRowsInSection() == 0 {
                return CGFloat(UIScreen.main.bounds.height / 2 - 50)
            } else {
                return CGFloat(UIScreen.main.bounds.height / 7)
            }
        } else if tableView == self.settingTable {
            return self.settingTable.estimatedRowHeight
        } else {
            return CGFloat(UIScreen.main.bounds.height / 10)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView == self.tableView {
            if self.todoViewModel.numberOfRowsInSection() == 0 {
                return .none
            }
            return .delete
        } else {
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("MainVC - UITableViewCell.EditingStyle.delete")
        if tableView == self.tableView {
            if editingStyle == UITableViewCell.EditingStyle.delete {
                CustomAlert().deletAlert(vc: self,documentId: self.todoViewModel.todoDocumentId(index: indexPath.row))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("MainVC - tdidSelectRowAt")
        if tableView == self.tableView {
            DatabaseService().didSelectTodoListDB(date: ChangeFormmater().chagneFormmater(date: Date()), todoData: self.todoViewModel.todoOfCellIndex(index: indexPath.row), table: self.tableView)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
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
