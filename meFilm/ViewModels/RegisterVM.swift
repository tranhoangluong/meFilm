//
//  RegisterVM.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 4/9/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

protocol RegisterResultDelegate{
    func registerSuccess(title: String)
    func regisertAlert(title: String, message: String)
}

protocol RegisterViewModelDelegate{
    func register(user: User) -> Void
    func addUserToDatabase(username: String) -> Void
    func checkUsernameIsUnique(_ username: String, completion: @escaping (Bool) -> Void) -> Void
}

class RegisterVM{
    var delegate: RegisterResultDelegate?
}

extension RegisterVM: RegisterViewModelDelegate{
    func register(user: User) {
        let email = user.email
        let password = user.password
        guard let username = user.username else {return}
        checkUsernameIsUnique(username) { isUnique in
            if isUnique{
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if error != nil{
                        print(error!.localizedDescription)
                        self.delegate?.regisertAlert(title: "Register failed", message: error!.localizedDescription)
                        return
                    }
                    if result != nil{
                        self.addUserToDatabase(username: username)
                        self.delegate?.registerSuccess(title: "Register successfully")
                    }
                }
            }
        }
    
    }
    
    func addUserToDatabase(username: String) {
        guard let userId = Auth.auth().currentUser?.uid else {return}
        let databaseRef = Database.database().reference()
        let data = ["username": username]
        let userRef = databaseRef.child("Users/\(userId)")
        userRef.setValue(data)
    }
    
    func checkUsernameIsUnique(_ username: String, completion: @escaping (Bool) -> Void) {
        let databaseRef = Database.database().reference()
        let usernameQuery = databaseRef.child("Users").queryOrdered(byChild: "username").queryEqual(toValue: username)
        
        usernameQuery.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                completion(false)
                self.delegate?.regisertAlert(title: "Invalid username", message: "This username was taken before")
                return
            }
            completion(true)
        }
    }
    
    
}
