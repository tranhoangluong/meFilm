//
//  CustomTextField.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 31/8/24.
//

import UIKit

extension UITextField{
    func underline(){
            let border = CALayer()
            let width = CGFloat(1.0)
            border.borderColor = UIColor.gray.cgColor
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
            border.borderWidth = width
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
        }
    
    func placeholder(text: String){
        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
    }
}




