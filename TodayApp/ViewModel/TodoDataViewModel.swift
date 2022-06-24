//
//  TodoDataViewModel.swift
//  TodayApp
//
//  Created by shoh on 2022/06/17.
//

import Foundation

struct TodoDataViewModel {
    var todoM: [TodoDataModel?]
    
    func numberOfRowsInSection() -> Int {
        return todoM.count
    }
    
    func todoNumberCount() -> Int {
        var dbID: Int = 0
        if todoM.count > 0 {
            for i in 0...todoM.count-1 {
                if self.todoM[i]!.documentId != "" {
                    dbID += 1
                }
            }
            return dbID
        } else {
            return 0
        }
    }
    
    func todoOfCellIndex(index: Int) -> TodoDataModel {
        return todoM[index]!
    }
}
