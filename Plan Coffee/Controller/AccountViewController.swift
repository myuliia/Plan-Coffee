//
//  AccountViewController.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 21.03.2024.
//

import UIKit
import FirebaseAuth


class AccountViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    
    let options = [(NSLocalizedString("Edit Profile", comment: "Edit Profile option"), "square.and.pencil"),
                   (NSLocalizedString("Change Language", comment: "Change Language option"), "globe"),
                   (NSLocalizedString("Settings", comment: "Settings option"), "gear"),
                   (NSLocalizedString("Notifications", comment: "Notifications option"), "bell"),
                   (NSLocalizedString("Referral program", comment: "Referral program option"), "gift"),
                   (NSLocalizedString("Feedback", comment: "Feedback option"), "hand.thumbsup")]
    
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @IBAction func logOutTapped(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            UserDataManager.shared.logout()
            updateUI()
            let alert = UIAlertController(title: K.Alert.logOutTitle, message: K.Alert.logOutMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } catch {
        }
    }
    
    func updateUI() {
        nameLabel.text = UserDataManager.shared.currentUser?.name ?? K.Loc.guestLabel
        pointLabel.text = "\(UserDataManager.shared.currentUser?.points ?? 0) \(K.Loc.pointsLabel)"
        logOutButton.layer.cornerRadius = logOutButton.bounds.width / 10
        
        
        if let email = UserDataManager.shared.currentUser?.email {
            emailLabel.isHidden = false
            emailLabel.text = email
            logOutButton.isHidden = false
            
        }
        else {
            emailLabel.isHidden = true
            logOutButton.isHidden = true
        }
        
    }
    
    func editProfile() {
        let alertController = UIAlertController(title: K.Loc.editProfileLabel, message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = K.Loc.newNamePlaceHolder
        }
        
        alertController.addTextField { textField in
            textField.placeholder = K.Loc.newEmailPlaceHolder
        }
        let saveAction = UIAlertAction(title: K.Alert.saveTitle, style: .default) { [weak self] _ in
            guard let newName = alertController.textFields?[0].text,
                  let newEmail = alertController.textFields?[1].text else {
                return
            }
            UserDataManager.shared.updateUserProfile(name: newName.isEmpty ? nil : newName, email: newEmail.isEmpty ? nil : newEmail)
            self?.view.showLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self?.updateUI()
                self?.view.stopLoading()
            }
        }
        
        let cancelAction = UIAlertAction(title: K.Alert.cancelTitle, style: .cancel)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func changeLanguage() {
        let alertController = UIAlertController(title: K.Loc.changeLanguageLabel, message: nil, preferredStyle: .alert)
        
        for language in availableLanguages {
            let action = UIAlertAction(title: language.name, style: .default) { _ in
                UserDefaults.standard.set([language.code], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                
                let restartAlert = UIAlertController(title: "Restart Required", message: "The app will now restart to apply the language changes.", preferredStyle: .alert)
                let restartAction = UIAlertAction(title: "OK", style: .default) { _ in
                    DispatchQueue.main.async {
                        exit(0)
                    }
                }
                restartAlert.addAction(restartAction)
                self.present(restartAlert, animated: true, completion: nil)
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

// MARK: UITableViewDataSource

extension AccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.accountCell, for: indexPath) as! AccountTableViewCell
        
        
        let (optionTitle, iconName) = options[indexPath.row]
        cell.optionLabel.text = optionTitle
        cell.iconImageView.image = UIImage(systemName: iconName)
        return cell
    }
}

// MARK: UITableViewDelegate

extension AccountViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedOption = options[indexPath.row].0
        switch selectedOption {
        case options[0].0:
            editProfile()
        case options[1].0:
            changeLanguage()
        default:
            let alert = UIAlertController(title: "Coming Soon...", message: "This feature is currently under development.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
