//
//  AuthService.swift
//  TodayApp
//
//  Created by 오승훈 on 2022/06/16.
//

import UIKit
import FirebaseAuth

class AuthService {
    func signInAuth(email: String, password: String,vc: SignInVC) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, err in
            if err == nil {
                vc.delegate?.fillData(email: email)
                vc.emailText.text = ""
                vc.passwordText.text = ""
                vc.rePasswordText.text = ""
                CustomAlert().tapDismissAlert(title: "알림", message: "회원가입 성공!", vc: vc)
            } else {
                if let err = err {
                    print("AuthService err: \(err)")
                    CustomAlert().basicAlert(title: "알림", message: "회원가입 실패", vc: vc)
                }
            }
        }
    }
    
    func loginAuth(email: String, password: String, vc: UIViewController) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, err in
            if err == nil {
                CustomAlert().mainAlert(title: "알림", message: "로그인 성공", vc: vc)
            } else {
                if let err = err {
                    print("AuthService err: \(err)")
                    CustomAlert().basicAlert(title: "알림", message: "이메일과 비밀번호를 확인해주세요", vc: vc)
                }
            }
        }
    }
}
