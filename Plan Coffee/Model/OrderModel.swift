//
//  OrderModel.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 27.03.2024.
//

import Foundation


struct Order {
    var item: String
    var count: Int
    var price: Float
}

class OrderDataManager {
    static let shared = OrderDataManager()
    var orders: [Order] = []
    
    func addOrder(item: String, price: Float) {
        if let index = orders.firstIndex(where: { $0.item == item }) {
            orders[index].count += 1
        } else {
            let newOrder = Order(item: item, count: 1, price: price)
            orders.append(newOrder)
        }
    }
    
    func removeOrder(item: String, price: Float) {
        if let index = orders.firstIndex(where: { $0.item == item }) {
            orders.remove(at: index)
        }
    }
    func minusOrder(item: String) {
        if let index = orders.firstIndex(where: { $0.item == item }) {
            if orders[index].count > 0 {
                orders[index].count -= 1
                if orders[index].count == 0 {
                    orders.remove(at: index)
                }
            }
        }
    }
    
    var totalPrice: Float {
        var totalPrice: Float = 0
        for order in orders {
            totalPrice += order.price * Float(order.count)
        }
        return totalPrice
    }
}
