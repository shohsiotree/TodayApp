//
//  EXVC.swift
//  TodayApp
//
//  Created by shoh on 2022/06/27.
//

import UIKit
@available(iOS 15.0, *)
class EXVC: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLayoutConstraint.activate([
            view.keyboardLayoutGuide.topAnchor.constraint(equalTo: textField.bottomAnchor)
        ])
    }
}
