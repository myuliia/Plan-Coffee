//
//  HistoryModel.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 28.03.2024.
//

import Foundation
import Firebase


struct History {
    let userUID: String
    let timestamp: Date
    let totalSum: Float
    let points: Float
    var order: [String : Int]?
}

class HistoryDataManager {
    private let db = Firestore.firestore()
    
    func sendOrdersToFirestore(orders: [Order]) {
        let db = Firestore.firestore()
        guard let userID = UserDataManager.shared.currentUser?.id else {
            return
        }
        
        var ordersData: [[String: Any]] = []
        for order in orders {
            let orderData: [String: Any] = [
                "item": order.item,
                "count": order.count,
            ]
            ordersData.append(orderData)
        }
        let timestamp = Date()
        let totalSum = OrderDataManager.shared.totalPrice
        let points = UserDataManager().calculatePointsForOrder(totalSum: totalSum)
        
        let orderDocument = db.collection("history").document()
        orderDocument.setData([
            "userID": userID as Any,
            "orders": ordersData,
            "timestamp": timestamp,
            "totalSum": totalSum,
            "points" : points
        ]) { error in
            if let error = error {
                print("Error adding order to Firestore: \(error.localizedDescription)")
            }
        }
    }
    
    func getHistoryByUserID(userID: String, completion: @escaping ([History]?, Error?) -> Void) {
        let historyCollection = db.collection("history")
        
        historyCollection.whereField("userID", isEqualTo: userID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching history: \(error)")
                completion(nil, error)
                return
            }
            
            var historyList: [History] = []
            
            for document in querySnapshot!.documents {
                let data = document.data()
                let userUID = data["userID"] as? String
                let timestamp = data["timestamp"] as? Timestamp
                let totalSum = data["totalSum"] as? Float
                let points = data["points"] as? Float
                let history = History(userUID: userUID!, timestamp: timestamp!.dateValue(), totalSum: totalSum!, points: points!)
                historyList.append(history)
            }
            completion(historyList, nil)
        }
    }
}
