//
//  AuthViewController.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 22.03.2024.
//

import UIKit
import Firebase
import FirebaseFirestore



class AuthViewController: UIViewController {
    
    let db = Firestore.firestore()
    var completionHandler: (() -> Void)?
    
    var signSwitcher:Bool = true {
        willSet {
            if newValue {
                titleLabel.text = K.Alert.registrationTitle
                nameTextField.isHidden = false
                questLabel.text = K.Loc.questionLogin
                loginButton.setTitle(K.Alert.signInTitle, for: .normal)
                
            }
            else {
                titleLabel.text = K.Alert.signInTitle
                nameTextField.isHidden = true
                questLabel.text = K.Loc.questionReg
                loginButton.setTitle(K.Alert.registrationTitle, for: .normal)
                
            }
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var questLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        questLabel.text = K.Loc.questionLogin
    }
    
    @IBAction func switchLogin(_ sender: Any) {
        signSwitcher = !signSwitcher
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: K.Loc.error, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}


extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let name = nameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if signSwitcher {
            if !name.isEmpty && !email.isEmpty && !password.isEmpty {
                UserDataManager.shared.createUser(name: name, email: email, password: password) { userId, error in
                    if let error = error as NSError? {
                        if let authError = AuthErrorCode.Code(rawValue: error.code) {
                            switch authError {
                            case .emailAlreadyInUse:
                                self.showAlert(message: K.Alert.emailInUse)
                            case .weakPassword:
                                self.showAlert(message: K.Alert.weakPassword)
                            case .invalidEmail:
                                self.showAlert(message: K.Alert.invalidEmail)
                            default:
                                self.showAlert(message: K.Alert.tryAgain)
                            }
                        }
                    }
                    else if userId != nil {
                        self.dismiss(animated: true)
                        self.completionHandler?()
                    }
                }
            } else {
                showAlert(message: K.Alert.fillAllFields)
            }
        } else {
            if !email.isEmpty && !password.isEmpty {
                UserDataManager.shared.signInUser(email: email, password: password) { userId, error in
                    if let error = error as NSError? {
                        if let authError = AuthErrorCode.Code(rawValue: error.code) {
                            switch authError {
                            case .wrongPassword:
                                self.showAlert(message: K.Alert.incorectPassword)
                            case .invalidEmail:
                                self.showAlert(message: K.Alert.incorectEmail)
                            default:
                                self.showAlert(message: K.Alert.tryAgain)
                            }
                        }
                    } else if userId != nil {
                        self.dismiss(animated: true)
                        self.completionHandler?()
                    }
                }
            }
        }
        return true
    }
}
