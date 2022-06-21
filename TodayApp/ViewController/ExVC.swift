//
//  ExVC.swift
//  TodayApp
//
//  Created by shoh on 2022/06/21.
//

import UIKit

class ExVC: UIViewController {
    
    @IBOutlet weak var toolbarStack: UIStackView!
    @IBOutlet weak var textToolbar: UIToolbar!
    @IBOutlet weak var buttonToolbar: UIToolbar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackHeight: NSLayoutConstraint!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var alramText: UILabel!
    
    var keyHeight: CGFloat?
    var numberOfCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackHeight.constant = 0.0
        self.tableView.clipsToBounds = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.alramText.isHidden = true
        self.view.bringSubviewToFront(self.addButton)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.tableView.endEditing(true)
        if self.stackHeight.constant == 80.0 {
            self.stackHeight.constant = 0.0
            self.tableView.clipsToBounds = true
            self.addButton.isHidden = false
            self.textField.text = ""
        }
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
    @IBAction func alramButton(_ sender: Any) {
        //TODO: 알람 데이트 피커 열기
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if !self.textField.text!.isEmpty {
            guard let text = self.textField.text else { return }
            print(text)
        }
    }
}

extension ExVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(UIScreen.main.bounds.height / 2 - 50)
    }
}
