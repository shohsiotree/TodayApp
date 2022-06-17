//
//  TodoDataViewModel.swift
//  TodayApp
//
//  Created by shoh on 2022/06/17.
//

import Foundation

struct TodoDataViewModel {
    var TodoM: [TodoDataModel]
    
    func todoCount() -> Int {
        return TodoM.count == 0 ? 0 : TodoM.count
    }
    
    func todoOfCellIndex(index: Int) -> TodoDataModel {
        return TodoM[index]
    }
}
