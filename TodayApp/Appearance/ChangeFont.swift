//
//  ChangeFont.swift
//  TodayApp
//
//  Created by shoh on 2022/06/20.
//

import UIKit

class ChangeFont {
    func mainTitle(title: String) -> NSMutableAttributedString {
        let title = title
        let font = UIFont(name: "LeeSeoyun", size: 20)
        let chagneTitle = NSMutableAttributedString(string: title)
        chagneTitle.addAttribute(.font, value: font!, range: (title as NSString).range(of: title))
        return chagneTitle
    }
    
    func subTitle(subTitle: String) -> NSMutableAttributedString {
        let subTitle = subTitle
        let font = UIFont(name: "LeeSeoyun", size: 15)
        let chagneTitle = NSMutableAttributedString(string: subTitle)
        chagneTitle.addAttribute(.font, value: font!, range: (subTitle as NSString).range(of: subTitle))
        return chagneTitle
    }
}
