//
//  ExtUIViewController.swift
//  GHfollowers
//
//  Created by Sudhanshu Ranjan on 13/07/24.
//

import UIKit

extension UIViewController {
    
    func presentGHAlerOnMainThread(title: String, message: String, buttonText: String){
        //ask prakhar
        DispatchQueue.main.async {
            let alertBox = GHAlertVC(title: title, message: message, buttonTitle: buttonText)
            alertBox.modalTransitionStyle = .crossDissolve
            alertBox.modalPresentationStyle = .overFullScreen
            self.present(alertBox, animated: true)
        }
    }
}
