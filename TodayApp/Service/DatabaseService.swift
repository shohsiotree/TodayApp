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
    
    func signInDB(email: String, pwd: String) {
        db.collection(email).document("UserData").setData(["Email":email,"password": pwd]) { err in
            guard err == nil else { return print("SignInDB err: \(err!)") }
            print("SignInVC - 회원가입 디비 생성 성공")
        }
    }
    
    func homeLoadData(table: UITableView, date: String,  completion: @escaping ([TodoDataModel?]) -> ()) {
        guard let email = Auth.auth().currentUser?.email else { return }
        var todoM: TodoDataModel?
        var arrtodoM = [todoM]
        db.collection(email).addSnapshotListener {(querySnapshot, err) in
            arrtodoM.removeAll()
            guard let querySnapshot = querySnapshot else { return }
            
            for document in querySnapshot.documents {
                if document.documentID != "UserData" {
                    if document.documentID == date {
                        let dd = document.data() as? [String: [String:Any]]
                        let aa: Array = [String](dd!.keys)
                        let documnetId = document.documentID
                        for i in 0..<aa.count {
                            let a = document[aa[i]] as! [String: Any]
                            let todoText = a["todoText"] as! String
                            let isAlarm = a["isAlarm"] as! String
                            let isDone = a["isDone"] as! Bool
                            let uploadTime = a["uploadTime"] as! String
                            todoM = TodoDataModel(documentId: documnetId, todoText: todoText, isAlarm: isAlarm, isDone: isDone, uploadTime: uploadTime)
                            arrtodoM.append(todoM)
                        }
                    }
                }
            }
            //TODO: 특정 값을 가지고 비교 해서 sorted 하기
            completion(arrtodoM)
            table.reloadData()
        }
    }

    func createTodoListDB(date: Date, todoText: String, isAlarm: String, uploadTime: String, table: UITableView) {
        guard let email = Auth.auth().currentUser?.email else { return }
        let random = arc4random_uniform(999999999)
        let field = [ "todoText": todoText, "isAlarm": isAlarm,"isDone": false, "uploadTime": uploadTime] as [String : Any]
        let documentId = ChangeFormmater().chagneFormmater(date: date)
        db.collection(email).document(documentId).setData([
            "\(random)" : field,
        ]) { err in
            guard err == nil else {
                return print("createDB err: \(err!)")
            }
            print("createDB Success")
        }
        table.reloadData()
    }
    
    func updateTodoListDB(date: Date, number: Int, todoText: String, isAlarm: String, isDone: Bool, uploadTime: String, table: UITableView) {
        guard let email = Auth.auth().currentUser?.email else { return }
        let random = arc4random_uniform(999999999)
        let field = [ "todoText": todoText, "isAlarm": isAlarm,"isDone": false, "uploadTime": uploadTime] as [String : Any]
        let documentId = ChangeFormmater().chagneFormmater(date: date)
        db.collection(email).document(documentId).setData([
            "\(random)": field
        ], merge: true)
        table.reloadData()
    }
    //TODO: didSelect 시, IsDone 값 변경 (업데이트)
    func didSelectTodoListDB(date: Date, number: Int, todoText: String, isAlarm: String, isDone: Bool, uploadTime: String, table: UITableView) {
        guard let email = Auth.auth().currentUser?.email else { return }
        let documentId = ChangeFormmater().chagneFormmater(date: Date())
        let field = [ "todoText": todoText, "isAlarm": isAlarm,"isDone": false, "uploadTime": uploadTime] as [String : Any]
        db.collection(email).document(documentId).updateData([
            number: field
        ])
        table.reloadData()
    }
    //TODO: Edit눌러 삭제 시, 해당 날짜를 가진 Collection 업데이트 (삭제)
    //TODO: todoList 삭제 (삭졔) -> 전체 삭제에서 다르게 변경
    func removeDB(documentId: String) {
        guard let email = Auth.auth().currentUser?.email else { return }
        db.collection(email).document(documentId).delete()
    }
    
    func postLoadData(table: UITableView, date: String,  completion: @escaping ([String],[[String]]) -> ()) {
        guard let email = Auth.auth().currentUser?.email else { return }
        var strArr = [String]()
        var documentArr = [String]()
        var strArr2 = [strArr]
        db.collection(email).addSnapshotListener {(querySnapshot, err) in
            guard let querySnapshot = querySnapshot else { return }
            strArr2.removeAll()
            documentArr.removeAll()
            for document in querySnapshot.documents {
                if document.documentID != "UserData" {
                    strArr.removeAll()
                    documentArr.append(document.documentID)
                    let a = document.data() as! [String: [String: Any]]
                    let b = a.keys
                    for i in b {
                        guard let c = a[i]!["todoText"] as? String else { return }
                        strArr.append(c)
                    }
                    strArr2.append(strArr)
                }
            }
            completion(documentArr, strArr2)
            table.reloadData()
        }
    }
}
