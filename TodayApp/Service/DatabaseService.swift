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
    //TODO: 회원 가입 시, Email의 이름을 가진 Collecion 생성 1개 (생성)
    func signInDB(email: String, pwd: String) {
        db.collection(email).document("UserData").setData(["Email":email,"password": pwd]) { err in
            guard err == nil else { return print("SignInDB err: \(err!)") }
            print("SignInVC - 회원가입 디비 생성 성공")
        }
    }
    
    //TODO: MainVC 진입 시, Email Collection을 제외 한 Collection, Document 불러오기 -> Main 및 전체 게시글 보기 (로드)
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
    //TODO: today Collection이 없으면, "+"으로 생성 시, CollectionName = today(생성, 추가)
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
    
    //TODO: today collection이 있으면, append 하여 추가 (업데이트)
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
    //TODO: todoList 삭제 (삭졔)
    func removeDB(documentId: String) {
        guard let email = Auth.auth().currentUser?.email else { return }
        db.collection(email).document(documentId).delete()
    }
    //TODO: Logout 관련
    //TODO: PostVC 전체적으로 나오기
    func postLoadData(table: UITableView, date: String,  completion: @escaping ([String],[String]) -> ()) {
        guard let email = Auth.auth().currentUser?.email else { return }
        var strArr = [String]()
        var documentArr = [String]()
        
        db.collection(email).addSnapshotListener {(querySnapshot, err) in
            guard let querySnapshot = querySnapshot else { return }
            
            for document in querySnapshot.documents {
                if document.documentID != "UserData" {
                    documentArr.append(document.documentID)
                    let a = document.data() as! [String: [String: Any]]
                    let b = a.keys
                    for i in b {
                        guard let c = a[i]!["todoText"] as? String else { return }
                        strArr.append(c)
                    }
                }
            }
            //TODO: 특정 값을 가지고 비교 해서 sorted 하기
            completion(documentArr, strArr)
            table.reloadData()
        }
    }
}
