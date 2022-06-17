//
//  EmptyCell.swift
//  TodayApp
//
//  Created by shoh on 2022/06/17.
//

import UIKit

class EmptyCell: UITableViewCell {
    @IBOutlet weak var DateText: UILabel!
    
    func updateDate() {
        let fomatter = DateFormatter()
        fomatter.dateFormat = "yyyy년MM월dd일"
        let today = fomatter.string(from: Date())
        self.DateText.text = today
    }
}
