//
//  HistoryViewController.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 21.03.2024.
//

import UIKit

class HistoryViewController: UIViewController {
    
    var history: [History] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        loadHistory()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: K.historyCellNibName, bundle: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nib, forCellReuseIdentifier: K.historyCell)
    }
    
    func loadHistory() {
        let userID : String = UserDataManager.shared.currentUser?.id ?? "KTg0fP1oyCd5GF8CgmJSN1FTnes2"
        HistoryDataManager().getHistoryByUserID(userID: userID ) { data, error in
            if let error = error {
                print("Error fetching history: \(error)")
                return
            }
            if let data = data {
                self.history = data.sorted(by: { $0.timestamp > $1.timestamp })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}


// MARK: UITableViewDelegate

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return K.historyCellHight
    }
}

// MARK: UITableViewDataSource

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.historyCell, for: indexPath) as! HistoryTableViewCell
        let sum = history[indexPath.row].totalSum
        let time = history[indexPath.row].timestamp
        let points = Int(history[indexPath.row].points)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let dateString = dateFormatter.string(from: time)
        
        cell.totalSum.text = "\(sum) ₴"
        cell.points.text = "+\(points)"
        cell.timestamp.text = dateString
        
        return cell
    }
}
