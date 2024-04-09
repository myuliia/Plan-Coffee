//
//  ViewController.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 21.03.2024.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage


class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var helloTitleLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var basketItemCountLabel: UILabel!
    @IBOutlet weak var basketButton: UIButton!
    
    var itemsArray = [String]()
    var priceArray = [Float]()
    var basketItemCount: Int = 0 {
        didSet {
            basketItemCountLabel.text = "\(basketItemCount)"
            basketItemCountLabel.isHidden = basketItemCount == 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser == nil {
            presentAuthViewController()
        }
        else {
            reloadUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: K.homeCellNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: K.homeCell)
        tableView.delegate = self
        tableView.dataSource = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.reloadUI()
            self.imageLoading()
        }
        updateBasketItemCountLabel()
    }
    
    func presentAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let authVC = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        authVC.completionHandler = { [weak self] in
            self?.reloadUI()
        }
        DispatchQueue.main.async {
            self.present(authVC, animated: true)
        }
    }
    
    func reloadUI() {
        let userName = UserDataManager.shared.currentUser?.name ?? K.Loc.guestLabel
        let points = UserDataManager.shared.currentUser?.points ?? 0
        helloTitleLabel.text = "\(K.Loc.helloLabel) \(userName)"
        pointsLabel.text = "\(points) \(K.Loc.pointsLabel)"
        updateBasketItemCountLabel()
    }
    
    func imageLoading() {
        if FirebaseApp.app() != nil {
            let db = Firestore.firestore()
            let collRef = db.collection("menu")
            
            collRef.getDocuments { querySnapshot, error in
                if error == nil && querySnapshot != nil {
                    for doc in querySnapshot!.documents {
                        self.itemsArray.append(doc["item"] as! String)
                        self.priceArray.append(doc["price"] as! Float)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func updateBasketItemCountLabel() {
        basketItemCount = OrderDataManager.shared.orders.count
    }
}

// MARK: UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return K.homeCellHight
    }
    
}

// MARK: UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.homeCell, for: indexPath) as! HomeTableViewCell
        
        let nameOfImage = itemsArray[indexPath.row]
        let price = priceArray[indexPath.row]
        
        cell.menuImageView.image = UIImage(named: nameOfImage)
        cell.itemLabel.text = nameOfImage
        cell.priceLabel.text = "\(price) ₴"
        cell.plusButton.tag = indexPath.row
        cell.plusButton.addTarget(self, action: #selector(rowButtonWasTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func rowButtonWasTapped(sender: UIButton) {
        let rowIndex : Int = sender.tag
        let itemName = itemsArray[rowIndex]
        let itemPrice = priceArray[rowIndex]
        
        OrderDataManager.shared.addOrder(item: itemName, price: itemPrice)
        updateBasketItemCountLabel()
        basketButton.imageView?.image = UIImage(systemName: "basket.fill")
    }
}
