//
//  AppManager.swift
//  TodayApp
//
//  Created by 오승훈 on 2022/06/16.
//

import UIKit
import Firebase

class AppManager {
    static let shared = AppManager()
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    var appContainerr: IntroVC!
    
    private init() {
        
    }
    
    func showApp(){
        var viewController: UIViewController
        if Auth.auth().currentUser == nil {
            viewController = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        } else {
            viewController = storyboard.instantiateViewController(withIdentifier: "MainVC")
        }
        viewController.modalPresentationStyle = .fullScreen
        appContainerr.present(viewController, animated: true)
    }
}
