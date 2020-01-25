//
//  AlertController.swift
//  UKSchools
//
//  Created by Mark on 25/01/2020.
//  Copyright © 2020 UK Schools. All rights reserved.
//

import UIKit

struct AlertController {
    
    
    /// Reusable AlertController to display messages & status codes
    /// - Parameters:
    ///   - title: String
    ///   - message: String
    ///   - vc: ViewController
    public static func customAlert(title: String, message: String, on vc: UIViewController) {
        DispatchQueue.main.async {
            showAlert(on: vc, title: title, message: message)
        }
    }
    
    private static func showAlertWithMultipleActions(on view: UIViewController, title: String, message: String, actions: [UIAlertAction]) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        DispatchQueue.main.async {
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    private static func showAlert(on view: UIViewController, title: String, message: String) {
        let action:[UIAlertAction] = [UIAlertAction(title: "Ok", style: .default, handler: nil)]
        showAlertWithMultipleActions(on: view, title: title, message: message, actions: action)
    }
    
}
