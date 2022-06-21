//
//  LoginVC.swift
//  TodayApp
//
//  Created by shoh on 2022/06/14.
//

import UIKit
import IQKeyboardManagerSwift

class LoginVC: UIViewController, UITextFieldDelegate, FillInfoData {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    var keyHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = true
        setUp()
    }
    
    private func setUp() {
        self.emailText.delegate = self
        self.passwordText.delegate = self
    }
    
    @IBAction func loginButton(_ sender: Any) {
        guard let emailText = self.emailText.text else { return }
        guard let passwordText = self.passwordText.text else { return }
        
        if emailText.isEmpty, passwordText.isEmpty {
            CustomAlert().basicAlert(title: "알림", message: "이메일과 비밀번호를 확인해주세요", vc: self)
        } else {
            if CheckVaild().isVaildEmail(email: emailText), CheckVaild().isVaildPassword(password: passwordText) {
                AuthService().loginAuth(email: emailText, password: passwordText, vc: self)
            } else {
                CustomAlert().basicAlert(title: "알림", message: "이메일과 비밀번호를 확인해주세요", vc: self)
                self.passwordText.text = ""
            }
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? SignInVC else { return }
        vc.delegate = self
    }
    
    func fillData(email: String?) {
        if let email = email {
            self.emailText.text = email
        }
    }
    
}

extension LoginVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailText {
            passwordText.becomeFirstResponder()
        } else if textField == passwordText {
            passwordText.resignFirstResponder()
        }
        return true
    }
}
