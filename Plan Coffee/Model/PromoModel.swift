//
//  PromoModel.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 04.04.2024.
//

import Foundation
import FirebaseFirestore
import Firebase

struct Promotion {
    let name: String
    let description: String
    let imageName: String
    let duration: String
    let offers: String
    let additionalInfo: String
    
    
    init(name: String, description: String, imageName: String, duration: String, offers: String, additionalInfo: String) {
        self.name = name
        self.description = description
        self.imageName = imageName
        self.duration = duration
        self.offers = offers
        self.additionalInfo = additionalInfo
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data(),
              let name = data["name"] as? String,
              let description = data["description"] as? String,
              let imageName = data["imageName"] as? String,
              let duration = data["duration"] as? String,
              let offers = data["offers"] as? String,
              let additionalInfo = data["additionalInfo"] as? String else {
            return nil
        }
        self.init(name: name, description: description, imageName: imageName, duration: duration, offers: offers, additionalInfo: additionalInfo)
    }
}

class PromotionDataManager {
    let db = Firestore.firestore()
    
    func fetchPromotions(completion: @escaping ([Promotion]?, Error?) -> Void) {
        db.collection("promotions").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            var promotions = [Promotion]()
            for document in querySnapshot!.documents {
                if let promotion = Promotion(document: document) {
                    promotions.append(promotion)
                }
            }
            completion(promotions, nil)
        }
    }
}
