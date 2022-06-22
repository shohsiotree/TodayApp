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
    func HomeLoadData(table: UITableView ,completion: @escaping ([TodoDataModel]) -> ()) {
        guard let email = Auth.auth().currentUser?.email else { return }
        var todoM: TodoDataModel?
        var arrtodoM = [todoM]
        self.db.collection(email).addSnapshotListener {(querySnapshot, err) in
            guard let querySnapshot = querySnapshot else { return }
            for document in querySnapshot.documents {
                if document.documentID != "UserData" {
                    
                }
            }
        }
    }
    //TODO: today Collection이 없으면, "+"으로 생성 시, CollectionName = today(생성, 추가)
    //TODO: didSelect 시, IsDone 값 변경 (업데이트)
    //TODO: Edit눌러 삭제 시, 해당 날짜를 가진 Collection 업데이트 (삭제)'
    //TODO: Logout 관련
}
