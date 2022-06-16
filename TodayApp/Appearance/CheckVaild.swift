//
//  CheckVaild.swift
//  TodayApp
//
//  Created by 오승훈 on 2022/06/16.
//

import UIKit

class CheckVaild {
    func isVaildEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func isVaildPassword(password: String) -> Bool {
        let passwordreg =  ("(?=.*[A-Za-z])(?=.*[0-9]).{8,20}")
        let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
        return passwordtesting.evaluate(with: password)
    }
}
