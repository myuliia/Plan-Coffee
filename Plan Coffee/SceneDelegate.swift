//
//  SceneDelegate.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 21.03.2024.
//

import UIKit
import FirebaseCore
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").whereField("id", isEqualTo: Auth.auth().currentUser?.uid as Any)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            do {
                try Auth.auth().signOut()
            } catch {
            }
            
            if Auth.auth().currentUser == nil {
            }
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    
    func showModalAuth() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        self.window?.rootViewController?.present(newVC, animated: false)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
