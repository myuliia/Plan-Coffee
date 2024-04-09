//
//  UserModel.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 25.03.2024.
//

import Foundation
import Firebase
import FirebaseFirestore


struct User: Identifiable, Codable {
    var id: String
    var name: String
    var email: String
    var points: Int
    
    var representaion: [String: Any] {
        var repr = [String: Any]()
        repr["id"] = self.id
        repr["name"] = self.name
        repr["email"] = self.email
        repr["points"] = self.points
        
        return repr
    }
}

class UserDataManager {
    static let shared = UserDataManager()
    var currentUser: User?
    let db = Firestore.firestore()
    
    func createUser(name: String, email: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(nil, error)
            } else if let authResult = authResult {
                let user = User(id: authResult.user.uid, name: name, email: email, points: 0)
                self.db.collection("users").document(authResult.user.uid).setData(user.representaion)
                self.currentUser = user
                completion(authResult.user.uid, nil)
            }
        }
    }
    func logout() {
        currentUser = nil
    }
    
    func signInUser(email: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { data, error in
            if let error = error {
                completion(nil, error)
            } else if let data = data {
                let userRef = self.db.collection("users").whereField("id", isEqualTo: data.user.uid as Any)
                userRef.getDocuments { documentSnapshot, error in
                    for document in documentSnapshot!.documents {
                        let data = document.data()
                        if let id = data["id"] as? String,
                           let name = data["name"] as? String,
                           let email = data["email"] as? String,
                           let points = data["points"] as? Int {
                            let user = User(id: id, name: name, email: email, points: points)
                            UserDataManager.shared.currentUser = user
                        }
                    }
                }
            }
            completion(data?.user.uid, nil)
        }
    }
    
    func calculatePointsForOrder(totalSum: Float) -> Int {
        let pointsEarned = Int(totalSum * 0.1)
        let user = UserDataManager.shared.currentUser
        
        if (user != nil) {
            let newPoints = user!.points + pointsEarned
            UserDataManager.shared.currentUser!.points = newPoints
            db.collection("users").whereField("id", isEqualTo: user!.id).getDocuments { querySnapshot, error in
                guard let document = querySnapshot?.documents.first else {
                    return
                }
                let newPoints = (document.data()["points"] as? Int ?? 0) + pointsEarned
                document.reference.updateData(["points": newPoints])
            }
            return pointsEarned
        }
        return 0
    }
    
    func updateUserProfile(name: String?, email: String?) {
        let user = UserDataManager.shared.currentUser
        
        db.collection("users").whereField("id", isEqualTo: user!.id).getDocuments { querySnapshot, error in
            guard let document = querySnapshot?.documents.first else {
                return
            }
            if let newName = name {
                document.reference.updateData(["name": newName])
                UserDataManager.shared.currentUser?.name = newName
            }
            if let newEmail = email  {
                document.reference.updateData(["email": newEmail])
                UserDataManager.shared.currentUser?.email
                = newEmail
            }
        }
    }
}
