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
        
        db.collection(email)
            .document("TodayTodo")
            .collection(date)
            .order(by: "timeStamp", descending: false)
            .addSnapshotListener { (querySnapshot, err) in
                arrtodoM.removeAll()
                guard let querySnapshot = querySnapshot else { return }
                for document in querySnapshot.documents {
                    todoM = TodoDataModel(
                        documentId: "",
                        todoText: document.data()["todoText"] as! String,
                        isAlarm: document.data()["isAlarm"] as! String,
                        isDone: (document.data()["isDone"] != nil),
                        uploadTime: document.data()["uploadTime"] as! String)
                    arrtodoM.append(todoM)
                }
                completion(arrtodoM)
                table.reloadData()
            }
    }
    
    func createTodoListDB(date: Date, todoText: String, isAlarm: String, uploadTime: String, table: UITableView) {
        guard let email = Auth.auth().currentUser?.email else { return }
        let documentId = ChangeFormmater().chagneFormmater(date: date)
        db.collection(email)
            .document("TodayTodo")
            .collection(documentId)
            .addDocument(data: [
                "todoText": todoText,
                "isAlarm": isAlarm,
                "isDone": false,
                "uploadTime": uploadTime,
                "timeStamp": Date()])
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
    //TODO: todoList 삭제 (삭졔) -> 전체 삭제에서 다르게 변경(2022.06.28)
    func removeDB(documentId: String) {
        guard let email = Auth.auth().currentUser?.email else { return }
        db.collection(email).document(documentId).delete()
    }
    //TODO: 따로 날짜를 추가하는 데이터베이스를 추가
    func addDateDatabase(date: String) {
        guard let email = Auth.auth().currentUser?.email else { return }
        db.collection(email)
            .document("Dates")
            .collection("date")
            .addDocument(data: [
                "date": date,
                "timeStamp": Date()
            ])
    }
    //TODO: 따로 추가한 날짜 컬렉션안에 값 뺴오기
    func dateLoadData(completion: @escaping ([String]) -> ()) {
        var dateArr = [String]()
        guard let email = Auth.auth().currentUser?.email else { return }
        db.collection(email)
            .document("Dates")
            .collection("date")
            .order(by: "timeStamp", descending: false)
            .getDocuments { (querySnapshot, err) in
                guard let query = querySnapshot else { return }
                for i in query.documents {
                    dateArr.append(i.data()["date"] as! String)
                }
                completion(dateArr)
            }
        
    }
    
    //TODO: 날짜를 따로 데이터베이스에 추가 하는 걸 만들기 (할일 추가 시, 디비 생성 하나 더 추가로 해서 값을 뽑아 arr로 정리후 하단 화면처럼 하기
    func postLoadData(date: [String], completion: @escaping ([[String]]) -> ()) {
        guard let email = Auth.auth().currentUser?.email else { return }
        var strArr = [String]()
        var strArr2 = [strArr]
        let arr = date
        for i in arr {
            db.collection(email)
                .document("TodayTodo")
                .collection(i)
                .order(by: "timeStamp", descending: false)
                .addSnapshotListener{ re, err in
                    strArr.removeAll()
                    strArr2.removeAll()
                    for i in re!.documents {
                        //                        print(i.data()["todoText"] as! String)
                        strArr.append(i.data()["todoText"] as! String)
                    }
                    strArr2.append(strArr)
                    completion(strArr2)
                }
        }
        
        /*
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
         */
    }
}
