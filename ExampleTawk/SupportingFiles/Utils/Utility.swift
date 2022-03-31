//
//  Utility.swift
//  ExampleTawk
//
//  Created by Himanshu on 29/03/22.
//

import Foundation
import UIKit

class AppHelper{
    static func showAlert(title: String, subtitle: String){
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title, message: subtitle, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
            if #available(iOS 13.0, *) {
                let sceneDelegate = UIApplication.shared.connectedScenes
                    .first!.delegate as! SceneDelegate
                sceneDelegate.window!.rootViewController?.present(alert, animated: true, completion: nil)
            } else {
                // UIApplication.shared.keyWindow?.rootViewController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window!.rootViewController?.present(alert, animated: true, completion: nil)
            }
        })
    }
    static func showAlert(_ saError: SAError){
        guard let description = saError.description else {
            self.showAlert(title: "Error", subtitle: saError.error.localizedDescription)
            return
        }
        self.showAlert(title: "Error", subtitle: description)
    }
    
    static func appDelegate() -> UIApplicationDelegate {
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
            return sceneDelegate as! UIApplicationDelegate
        } else {
            // UIApplication.shared.keyWindow?.rootViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate
        }
    }
}
