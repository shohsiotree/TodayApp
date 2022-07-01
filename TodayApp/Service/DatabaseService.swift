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
            print("DatabaseServic - signInDB")
        }
    }
    
    func homeLoadData(table: UITableView, date: String,  completion: @escaping ([TodoDataModel?]) -> ()) {
        print("DatabaseServic - homeLoadData")
        guard let email = Auth.auth().currentUser?.email else { return }
        var todoM: TodoDataModel?
        var arrtodoM = [todoM]
        
        db.collection(email)
            .document("TodayTodo")
            .collection(date)
            .order(by: "timeStamp", descending: false)
            .addSnapshotListener { (querySnapshot, err) in
                arrtodoM.removeAll()
                guard let querySnapshot = querySnapshot else { return }
                for document in querySnapshot.documents {
                    todoM = TodoDataModel(
                        documentId: document.documentID,
                        todoText: document.data()["todoText"] as! String,
                        isAlarm: document.data()["isAlarm"] as! String,
                        isDone: document.data()["isDone"] as! Bool
                    )
                    arrtodoM.append(todoM)
                }
                completion(arrtodoM)
                table.reloadData()
            }
    }
    
    func createTodoListDB(date: Date, todoText: String, isAlarm: String, table: UITableView) {
        print("DatabaseServic - createTodoListDB")
        guard let email = Auth.auth().currentUser?.email else { return }
        let documentId = ChangeFormmater().chagneFormmater(date: date)
        db.collection(email)
            .document("TodayTodo")
            .collection(documentId)
            .addDocument(data: [
                "todoText": todoText,
                "isAlarm": isAlarm,
                "isDone": false,
                "timeStamp": Date()])
    }
    
    func didSelectTodoListDB(date: String, todoData: TodoDataModel, table: UITableView) {
        print("DatabaseServic - didSelectTodoListDB")
        guard let email = Auth.auth().currentUser?.email else { return }
        let documentId = todoData.documentId
        let isDone = !todoData.isDone
        db.collection(email)
            .document("TodayTodo")
            .collection(date)
            .document(documentId)
            .updateData([
                "isDone": isDone
            ])
        table.reloadData()
    }
    
    func removeDB(date: String, documentID: String) {
        print("DatabaseServic - removeDB")
        guard let email = Auth.auth().currentUser?.email else { return }
        db.collection(email)
            .document("TodayTodo")
            .collection(date)
            .document(documentID)
            .delete()
    }
    
    func addDateDatabase(date: String) {
        print("DatabaseServic - addDateDatabase")
        guard let email = Auth.auth().currentUser?.email else { return }
        db.collection(email)
            .document("Dates")
            .collection("date")
            .addDocument(data: [
                "date": date,
                "timeStamp": Date()
            ])
    }
    
    func dateLoadData(completion: @escaping ([String]) -> ()) {
        print("DatabaseServic - dateLoadData")
        var dateArr = [String]()
        guard let email = Auth.auth().currentUser?.email else { return }
        db.collection(email)
            .document("Dates")
            .collection("date")
            .order(by: "timeStamp", descending: true)
            .getDocuments { (querySnapshot, err) in
                dateArr.removeAll()
                guard let query = querySnapshot else { return }
                for i in query.documents {
                    dateArr.append(i.data()["date"] as! String)
                }
                completion(dateArr)
            }
        
    }
    
    func postLoadData(date: String, table: UITableView, completion: @escaping ([String]) -> ()) {
        print("DatabaseServic - postLoadData")
        guard let email = Auth.auth().currentUser?.email else { return }
        var strArr = [String]()
        var strArr2 = [strArr]
        let arr = date
        strArr2.removeAll()
        db.collection(email)
            .document("TodayTodo")
            .collection(arr)
            .order(by: "timeStamp", descending: true)
            .addSnapshotListener { re, err in
                strArr.removeAll()
                for i in re!.documents {
                    strArr.append(i.data()["todoText"] as! String)
                }
                completion(strArr)
            }
    }
}
