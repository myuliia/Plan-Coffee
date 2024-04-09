//
//  Constants.swift
//  Plan Coffee
//
//  Created by Yullia Mishchenko on 01.04.2024.
//

import Foundation
import UIKit


struct K {
    static let historyCell = "historyCell"
    static let homeCell = "HomeCell"
    static let basketCell = "BasketTableViewCell"
    static let accountCell = "AccountCell"
    static let promoCell = "PromotionCell"
    
    static let homeCellNibName = "HomeTableViewCell"
    static let historyCellNibName = "HistoryTableViewCell"
    static let promoCellNibName = "PromoCollectionViewCell"
    static let promoDetailVCId = "PromoDetailViewController"
    static let homeCellHight : CGFloat = 125
    static let historyCellHight : CGFloat = 115
    static let CoralBright = UIColor(named: "Coral Bright")
    static let backgoundWithoutLogo = "backgrooundImage_withoutLogo"
    
    
    
    
    struct Alert {
        static let registrationTitle = NSLocalizedString("Registration", comment: "Registration Title")
        static let signInTitle = NSLocalizedString("Sign in", comment: "Sign in Title")
        static let emailInUse = NSLocalizedString("Email is already in use.", comment: "Email In Use Alert")
        static let weakPassword = NSLocalizedString("Password should be 6 symbols or more.", comment: "Weak Password Alert")
        static let invalidEmail = NSLocalizedString("Please enter correct email.", comment: "Invalid Email Alert")
        static let genericError = NSLocalizedString("Please try again.", comment: "Generic Error Alert")
        static let fillAllFields = NSLocalizedString("Fill in all the fields.", comment: "Fill All Fields Alert")
        static let incorectPassword = NSLocalizedString("Incorrect password.", comment: "Incorrect password.")
        static let incorectEmail = NSLocalizedString("Please enter correct email.", comment: "Please enter correct email.")
        static let tryAgain = NSLocalizedString("Please try again.", comment: "Please try again.")
        static let loginFirst = NSLocalizedString("Please login to your account to make an order.", comment: "Please login to your account to make an order.")
        static let saveTitle = NSLocalizedString("Save", comment: "Save Title")
        static let cancelTitle = NSLocalizedString("Cancel", comment: "cancel Title")
        static let logOutTitle = NSLocalizedString("Logged Out", comment: "Logged Out Title")
        static let logOutMessage = NSLocalizedString("You have successfully logged out.", comment: "Logged Out Message")
        
        
    }
    
    struct Loc {
        static let questionReg = NSLocalizedString("Do not have an account?", comment: "Do not have an account? Label")
        static let questionLogin = NSLocalizedString("Already have an account?", comment: "Already have an account? Label")
        static let error = NSLocalizedString("Error", comment: "Eror title")
        static let newNamePlaceHolder  = NSLocalizedString("New Name", comment: "New Name PlaceHolder")
        static let newEmailPlaceHolder  = NSLocalizedString("New Email", comment: "New Email PlaceHolder")
        static let pointsLabel = NSLocalizedString("points", comment: "Points Label")
        static let guestLabel = NSLocalizedString("Guest", comment: "Guest Label")
        static let editProfileLabel = NSLocalizedString("Edit Profile", comment: "Edit Profile Label")
        static let changeLanguageLabel = NSLocalizedString("Change Language", comment: "Change Language Label")
        static let successfullyOrderLabel = NSLocalizedString("Successfully Ordered", comment: "Successfully Ordered Label")
        static let home = NSLocalizedString("Home", comment: "Home Tab Bar Item")
        static let offers = NSLocalizedString("Offers", comment: "Offers Tab Bar Item")
        static let history = NSLocalizedString("History", comment: "History Tab Bar Item")
        static let account = NSLocalizedString("Account", comment: "Account Tab Bar Item")
        static let helloLabel = NSLocalizedString("Hello,", comment: "Hello Label")
        static let totalSumLabel = NSLocalizedString("Total sum", comment: "Total Sum Label")
        static let dateAndTimeLabel = NSLocalizedString("Date and time", comment: "Date And Time Label")
        static let pointsAddedLabel = NSLocalizedString("Points added", comment: "points Added Label")
    }
}
