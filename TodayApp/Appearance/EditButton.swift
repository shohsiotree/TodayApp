//
//  EditButton.swift
//  TodayApp
//
//  Created by shoh on 2022/06/15.
//

import UIKit

@IBDesignable
class EditButton: UIButton {
   @IBInspectable var roundButton: Bool = false {
        didSet{
            if roundButton {
                self.layer.cornerRadius = 5
                self.layer.borderWidth = 1
                self.layer.borderColor = CGColor(red: 74, green: 74, blue: 74, alpha: 1)
                self.layer.masksToBounds = false
                self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowOpacity = 0.14
                self.layer.shadowOffset = CGSize(width: 8, height: 0)
                self.layer.shadowRadius = 7 / 2.0
            }
        }
    }
}
