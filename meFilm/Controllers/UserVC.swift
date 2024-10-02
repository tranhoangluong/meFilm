//
//  UserVC.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 8/9/24.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Toast_Swift
import FirebaseAuth
import IQKeyboardManagerSwift
import SDWebImage

class UserVC: UIViewController {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var btnLogout: UIButton!
    
    @IBOutlet weak var btnEditUseravatar: UIButton!
        
    let imgPicker = UIImagePickerController()
    var avatar: UIImage?
    let databaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBtn()
        setupTextField()
        setupImageView()
        getDataFromDatabase()
        getAvatarFromDatabase()
    }
    
    func setupBtn(){
        btnEditUseravatar.layer.masksToBounds = true
        btnEditUseravatar.layer.cornerRadius = btnEditUseravatar.frame.width / 2
        
        btnEditUseravatar.addTarget(self, action: #selector(onTapChooseAvatar), for: .touchUpInside)
        btnLogout.addTarget(self, action: #selector(onTapLogout), for: .touchUpInside)
    }
    
    func setupTextField(){
        userName.underline()
        userName.delegate = self
        
        userEmail.underline()
        userEmail.delegate = self
        
        userPassword.underline()
        userPassword.delegate = self
    }
    
    func setupImageView(){
        userAvatar.layer.cornerRadius = userAvatar.frame.size.width / 2
        userAvatar.clipsToBounds = true
    }
   
    @objc func onTapChooseAvatar(){
        let alert = UIAlertController(title: "Choose avatar", message: nil, preferredStyle: .actionSheet)
        let actionOpenPhoto = UIAlertAction(title: "Photo Library", style: .default) { action in
            self.imgPicker.sourceType = .photoLibrary
            self.imgPicker.delegate = self
            self.present(self.imgPicker, animated: true)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionOpenPhoto)
        alert.addAction(actionCancel)
        present(alert, animated: true)
    }
    
    @objc func onTapLogout(){
        try! Auth.auth().signOut()
        self.view.makeToast("You have successfully logged out  ")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "loginVC")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func addUserAvatarToDatabase(){
        if avatar == nil {
            return
        } else {
            if let image = avatar, let data = image.jpegData(compressionQuality: 0.3){
                let key = Database.database().reference().childByAutoId().key! //AUTO GENERATE KEY
                let imageName = key
                let imageStorageRef = Storage.storage().reference()
                let imageFolder = imageStorageRef.child("Avatar").child(imageName)
                imageFolder.putData(data, metadata: nil) { meta, error in
                    if error != nil{
                        self.view.makeToast(error?.localizedDescription)
                    } else  {
                        imageFolder.downloadURL { url, error in
                            if (error != nil){
                                self.view.makeToast(error?.localizedDescription)
                            } else {
                                guard let avatarUrl = url else {return}
                                guard let userId = Auth.auth().currentUser?.uid else {return}
                                
                                let value = ["avatarUrl": "\(avatarUrl)"]
                                self.databaseReference.child("Users").child(userId).child("avatar").setValue(value)
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    func getDataFromDatabase(){
        if let currentUser = Auth.auth().currentUser{
            databaseReference.child("Users").child(currentUser.uid).observe( .value) { snapshot in
                if let data  = snapshot.value as? [String: Any]{
                    self.userName.text = data["username"] as? String
                    self.userPassword.text = data["password"] as? String
                    self.userEmail.text = data["email"] as? String
                }
            }
        }
    }
    
    func getAvatarFromDatabase(){
        if let currentUser = Auth.auth().currentUser{
            databaseReference.child("Users").child(currentUser.uid).child("avatar").observe( .value) { snapshot in
                if let data  = snapshot.value as? [String: Any]{
                    if let url = URL(string: data["avatarUrl"] as! String){
                        self.userAvatar.sd_setImage(with: url)
                    }
                }
            }
        }
    }
  
}

extension UserVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chooseImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            avatar = chooseImage
            userAvatar.image = avatar
            addUserAvatarToDatabase()
            dismiss(animated: true)
        }
    }
    
}

extension UserVC: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}
