//
//  UIImageView.swift
//  ExampleTawk
//
//  Created by Himanshu on 29/03/22.
//

import UIKit
extension UIImageView {
    func roundedImage() {
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
    }
}
