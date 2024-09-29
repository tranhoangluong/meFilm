//
//  UserVC.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 8/9/24.
//

import UIKit

class UserVC: UIViewController {
    
    @IBOutlet weak var userAvatar: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
    
    let imgPicker = UIImagePickerController()
    var avatar: UIImage?
    
    @IBAction func onTapMyProfile(_ sender: Any) {
        
    }
    
    
    @IBAction func onTapFavoriteMovies(_ sender: Any) {
    }
    
    @IBAction func onTapDownloadMovies(_ sender: Any) {
    }
    
    @IBAction func onTapLogout(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserAvatar()
    }
    
    func setupUserAvatar(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseAvatar))
        
        userAvatar.layer.cornerRadius = userAvatar.frame.size.width / 2
        userAvatar.clipsToBounds = true
        
        userAvatar.addGestureRecognizer(tapGesture)
    }
    
    @objc func chooseAvatar(){
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
}

extension UserVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chooseImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            avatar = chooseImage
            userAvatar.image = avatar
            dismiss(animated: true)
        }
    }
}
