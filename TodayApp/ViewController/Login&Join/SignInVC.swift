//
//  SignInVC.swift
//  TodayApp
//
//  Created by shoh on 2022/06/14.
//

import UIKit
import FirebaseAuth

protocol FillInfoData: AnyObject {
    func fillData(email: String?)
}

class SignInVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var rePasswordText: UITextField!
    
    weak var delegate: FillInfoData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        self.emailText.delegate = self
        self.passwordText.delegate = self
        self.rePasswordText.delegate = self
    }
    
   
    
    @IBAction func siginButton(_ sender: Any) {
        guard let emailText = self.emailText.text else { return }
        guard let passwordText = self.passwordText.text else { return }
        guard let rePasswordText = self.rePasswordText.text else { return }
        
        if CheckVaild().isVaildEmail(email: emailText), CheckVaild().isVaildPassword(password: passwordText), passwordText == rePasswordText {
            AuthService().signInAuth(email: emailText, password: passwordText, vc: self)
        } else {
            if !CheckVaild().isVaildEmail(email: emailText) {
                CustomAlert().basicAlert(title: "알림", message: "이메일을 다시 입력해주세요", vc: self)
            } else if !CheckVaild().isVaildPassword(password: passwordText) {
                CustomAlert().basicAlert(title: "알림", message: "비밀번호를 다시 입력해주세요", vc: self)
            } else if passwordText != rePasswordText {
                CustomAlert().basicAlert(title: "알림", message: "비밀번호가 동일하지 않습니다", vc: self)
            }
        }
    }
}

extension SignInVC {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailText {
            passwordText.becomeFirstResponder()
        } else if textField == passwordText {
            rePasswordText.becomeFirstResponder()
        } else if textField == rePasswordText {
            rePasswordText.resignFirstResponder()
        }
        return true
    }
}
