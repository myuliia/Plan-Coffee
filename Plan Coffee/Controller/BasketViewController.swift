//
//  BasketViewController.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 27.03.2024.
//

import UIKit

class BasketViewController: UIViewController {
    
    let historyManager = HistoryDataManager()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noItemsView: UIView!
    @IBOutlet weak var orderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: K.basketCell, bundle: nil)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nib, forCellReuseIdentifier: K.basketCell)
        orderButton.backgroundColor = K.CoralBright
        
        orderButton.layer.cornerRadius =  orderButton.frame.size.width / 11
        noItemsView.isHidden = !OrderDataManager.shared.orders.isEmpty
        
    }
    
    @IBAction func placeOrderButtonTapped(_ sender: Any) {
        if UserDataManager.shared.currentUser?.id != nil {
            view.showLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.view.stopLoading()
                self.orderButton.setTitle(K.Loc.successfullyOrderLabel, for: .normal)
                self.orderButton.backgroundColor = #colorLiteral(red: 1, green: 0.3647058824, blue: 0.3261129159, alpha: 0.5930950847)
                self.historyManager.sendOrdersToFirestore(orders: OrderDataManager.shared.orders)
                OrderDataManager.shared.orders = []
                self.tableView.reloadData()
            }
        } else {
            let alert = UIAlertController(title: K.Loc.error, message: K.Alert.loginFirst , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
        }
    }
}



// MARK: UITableViewDelegate

extension BasketViewController: UITableViewDelegate {
}

// MARK: UITableViewDataSource

extension BasketViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderDataManager.shared.orders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = OrderDataManager.shared.orders[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.basketCell, for: indexPath) as! BasketTableViewCell
        let sumOfItems = order.price * Float(order.count)
        
        
        cell.countLabel.text = "\(order.count)x"
        cell.itemNameLabel.text = order.item
        cell.priceLabel.text = "\(sumOfItems) ₴"
        cell.addButton.tag =  indexPath.row
        cell.addButton.addTarget(self, action: #selector(addButtonTapped(sender:)), for: .touchUpInside)
        cell.minusButton.tag = indexPath.row
        cell.minusButton.addTarget(self, action: #selector(minusButtonTapped(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func addButtonTapped(sender: UIButton) {
        let rowIndex : Int = sender.tag
        let order = OrderDataManager.shared.orders[rowIndex]
        
        OrderDataManager.shared.addOrder(item: order.item, price: order.price)
        
        tableView.reloadData()
        
    }
    
    @objc func minusButtonTapped(sender: UIButton) {
        let rowIndex : Int = sender.tag
        let order = OrderDataManager.shared.orders[rowIndex]
        
        if order.count > 0 {
            OrderDataManager.shared.minusOrder(item: order.item)
        }
        if OrderDataManager.shared.orders.reduce(0, { $0 + $1.count }) == 0 {
            noItemsView.isHidden = false
        }
        tableView.reloadData()
    }
}

extension UIView {
    static let loadingViewTag = 1938123987
    
    func showLoading(style: UIActivityIndicatorView.Style = .medium) {
        if let _ = self.viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView {
            return
        }
        
        let loadingView = UIActivityIndicatorView(style: style)
        loadingView.color = K.CoralBright
        loadingView.tag = UIView.loadingViewTag
        loadingView.center = self.center
        loadingView.startAnimating()
        
        self.addSubview(loadingView)
    }
    
    func stopLoading() {
        if let loadingView = self.viewWithTag(UIView.loadingViewTag) as? UIActivityIndicatorView {
            loadingView.stopAnimating()
            loadingView.removeFromSuperview()
        }
    }
}
