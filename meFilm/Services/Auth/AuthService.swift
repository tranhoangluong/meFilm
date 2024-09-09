//
//  AuthService.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 26/8/24.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FacebookLogin

protocol SignInServiceDelegate: AnyObject{
    func logInFirstTime()
    func logInBefore()
    func logInFBAlert(title: String, message: String)
}

protocol AuthServiceDelegate{
    func logInFacebook(viewController: UIViewController)
}

class AuthService{
    private let userRef = Database.database().reference().child("Users")
    
    var delegate: SignInServiceDelegate?
    
    func checkExistedUsername() -> Void{
        guard let currentUser = Auth.auth().currentUser else {return}
        userRef.child(currentUser.uid).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                if let userData = snapshot.value as? [String: Any],
                   let _ = userData["username"] as? String{
                    self.delegate?.logInBefore()
                } else {
                    self.delegate?.logInFirstTime()
                }
                    
            }
        }
          
    }
}

extension AuthService: AuthServiceDelegate{
    func logInFacebook(viewController: UIViewController) {
        if let accessToken = AccessToken.current{
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            Auth.auth().signIn(with: credential) { result, error in
                if error != nil{
                    self.delegate?.logInFBAlert(title: "Login via Facebook failed", message: error!.localizedDescription)
                    return
                } else {
                    self.delegate?.logInFBAlert(title: "Login via Facebook successfully", message: "")
                }
            }
        }
    }
}
 
