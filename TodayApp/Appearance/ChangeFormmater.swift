//
//  ChangeFormmater.swift
//  TodayApp
//
//  Created by shoh on 2022/06/20.
//

import Foundation

class ChangeFormmater {
    func chagneFormmater(date: Date) -> String{
        let formmater = DateFormatter()
        formmater.dateFormat = "yy.MM.dd(EEEEE)"
        return formmater.string(from: date)
    }
}
