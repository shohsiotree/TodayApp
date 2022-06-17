//
//  DatabaseService.swift
//  TodayApp
//
//  Created by shoh on 2022/06/17.
//

import Foundation
import Firebase

class DatabaseService {
    let db = Firestore.firestore()
    
    func todoLoadData(completion: @escaping (TodoDataModel)-> ()) {
        guard let user = Auth.auth().currentUser?.email else { return }
        self.db.collection(user).document("Todo").addSnapshotListener { (querySnapshot, err)in
            if err == nil {
                guard let document = querySnapshot else { return }
                let data = document.data()
                
            }
        }
    }
}
