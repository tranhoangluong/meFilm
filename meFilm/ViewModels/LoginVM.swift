//
//  LoginVM.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 4/9/24.
//	

import Foundation
import FirebaseAuth

protocol LoginResultDelegate: AnyObject{
    func loginSuccess(title: String)
    func loginFail(title: String, message: String)
}

protocol LoginViewModelDelegate {
    func login(user: User) -> Void
    func forgotPassword(email: String) -> Void
}

class LoginVM{
    var delegate: LoginResultDelegate?
}

extension LoginVM: LoginViewModelDelegate{
    
    func forgotPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            self.delegate?.loginFail(title: "Reset your password", message: "Please check your email: \(email)")
        }
    }
    
    func login(user: User){
        let email = user.email
        let password = user.password
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
                self.delegate?.loginFail(title: "Login failed", message: "You have entered an invalid email or password.")
                return
            }
            if result != nil{
                self.delegate?.loginSuccess(title: "Login successfully")
            }
        }
        
    }
}
