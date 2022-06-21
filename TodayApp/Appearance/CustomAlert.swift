//
//  CustomAlert.swift
//  TodayApp
//
//  Created by 오승훈 on 2022/06/16.
//

import UIKit

class CustomAlert {
    func basicAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
    
    func tapDismissAlert(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel) { _ in
            vc.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
    
    func mainAlert(title: String, message: String, vc: UIViewController) {
        guard let mainVC = vc.storyboard?.instantiateViewController(withIdentifier: "MainVC") else { return }
        mainVC.modalPresentationStyle = .fullScreen
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .cancel) { _ in
            vc.present(mainVC, animated: true)
        }
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
    
    func titleAlert(vc: UIViewController) {
        let mainTitle = ChangeFont().mainTitle(title: "오늘의 제목을 정해주세요!")
        
        let alert = UIAlertController(title: "오늘의 제목을 정해주세요!", message: nil, preferredStyle: .alert)
        alert.setValue(mainTitle, forKey: "attributedTitle")
        let cancleButton = UIAlertAction(title: "취소", style: .cancel)
        let saveButton = UIAlertAction(title: "저장", style: .default) { _ in
            //TODO: 데이터베이스생성 추가
        }
        alert.addTextField { textField in
            textField.placeholder = "오늘의 제목은?!"
        }
        cancleButton.setValue(UIColor.red, forKey: "titleTextColor")
        saveButton.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(cancleButton)
        alert.addAction(saveButton)
        vc.present(alert, animated: true)
    }
    
    func todoListAlert(vc: UIViewController, date: Date) {
        let mainTitle = ChangeFont().mainTitle(title: "할일을 추가해주세요!")
        let date = ChangeFormmater().chagneFormmater(date: date)
        let alert = UIAlertController(title: "할일을 추가해주세요!", message: nil, preferredStyle: .alert)
        alert.setValue(mainTitle, forKey: "attributedTitle")
        let cancleButton = UIAlertAction(title: "취소", style: .cancel)
        let saveButton = UIAlertAction(title: "저장", style: .default) { _ in
            //TODO: Date를 받아와 해당 도큐먼트에 todo 추가
            print(alert.textFields?[0].text)
        }
        alert.addTextField { textField in
            textField.placeholder = "오늘의 할일은?"
        }
        cancleButton.setValue(UIColor.red, forKey: "titleTextColor")
        saveButton.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(cancleButton)
        alert.addAction(saveButton)
        vc.present(alert, animated: true)
    }
}
