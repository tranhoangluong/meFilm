//
//  RegisterVC.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 26/8/24.
//

import UIKit
import Toast_Swift

class RegisterVC: UIViewController{
    
    //DECLARE REGISTERVIEWMODEL
    var registerVM = RegisterVM()
    
    //DECLARE USERMODEL
    private var user: User{
        let username = tfUsername.text ?? ""
        let email = tfEmail.text ?? ""
        let password = tfPassword.text ?? ""
        let user = User(username: username, email: email, password: password)
        return user
    }
    
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfConfirmPassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    
    var btnLoginNavigator = UIButton()
    var lblLoginNavigator =  UIButton()
    var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupStackView()
        setupButton()
        registerVM.delegate = self //DECLARE REGISTERMODEL DELEGATE
    }
    
    func setupTextField(){
        //TEXTFIELD USERNAME
        tfUsername.underline()
        tfUsername.placeholder(text: "Username")
        tfUsername.tag = 0
        tfUsername.delegate = self
        
        //TEXTFIELD EMAIL
        tfEmail.underline()
        tfEmail.placeholder(text: "Email")
        tfEmail.tag = 1
        tfEmail.delegate = self
        
        //TEXTFIELD PASSWORD
        tfPassword.underline()
        tfPassword.placeholder(text: "Password")
        tfPassword.textContentType = .oneTimeCode
        tfPassword.tag = 2
        tfPassword.delegate = self
        
        //TEXTFIELD CONFIRM PASSWORD
        tfConfirmPassword.underline()
        tfConfirmPassword.placeholder(text: "Confirm password")
        tfConfirmPassword.textContentType = .oneTimeCode
        tfConfirmPassword.tag = 3
        tfConfirmPassword.delegate = self
    }
    
    func setupButton(){
        //SET UP BUTTON REGISTER
        btnRegister.layer.masksToBounds = true
        btnRegister.layer.cornerRadius = 10
    }
    
    func setupStackView(){
        //SET UP STACKVIEW
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: btnRegister.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: btnRegister.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: btnRegister.bottomAnchor, constant: 40).isActive = true
        stackView.widthAnchor.constraint(equalTo: btnRegister.widthAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo:  btnRegister.heightAnchor).isActive = true
        
        stackView.addArrangedSubview(lblLoginNavigator)
        stackView.addArrangedSubview(btnLoginNavigator)
        stackView.spacing = 10
        
        //SET UP BUTTON NAVIGATE -> LOGIN SCREEN
        btnLoginNavigator.translatesAutoresizingMaskIntoConstraints = false
        btnLoginNavigator.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -40).isActive = true
        btnLoginNavigator.setTitle("Login", for: .normal)
        btnLoginNavigator.contentHorizontalAlignment = .left
        btnLoginNavigator.addTarget(self, action: #selector(onTapLoginNavigator), for: .touchUpInside)
        
        //SET UP LABEL SUBTITLE FOR BUTTON NAVIGATE -> LOGIN SCREEN
        lblLoginNavigator.translatesAutoresizingMaskIntoConstraints = false
        lblLoginNavigator.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 40).isActive = true
        lblLoginNavigator.setTitle("Already have an account?", for: .normal)
        
    }
    
    //NAVIGATE -> LOGIN SCREEN ACTION
    @objc func onTapLoginNavigator(){
      dismiss(animated: true, completion: nil)
    }
    
    
    //REGISTER USER ACTION
    @IBAction func onTapRegister(_ sender: Any) {
        view.endEditing(true)
        if tfUsername.text == "" {
            self.view.makeToast("Please enter username")
            return
        }
        if tfEmail.text == "" {
            self.view.makeToast("Please enter email")
            return
        }
        if tfPassword.text == "" {
            self.view.makeToast("Please enter password")
            return
        }
        if tfConfirmPassword.text == ""{
            self.view.makeToast("Please enter confirm password")
            return
        }
        if tfPassword.text != tfConfirmPassword.text {
            self.view.makeToast("Password not match")
            return
        }
        
        if tfUsername.text != "" && tfEmail.text != "" && tfPassword.text != "" && tfConfirmPassword.text != "" {
            registerVM.register(user: user)
        }
    }
    
}

//EXTENSION TEXTFIELD_DELEGATE
extension RegisterVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTextFieldTag = textField.tag + 1
           if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as? UITextField {
               nextTextField.becomeFirstResponder()
           } else {
               textField.resignFirstResponder()
               view.endEditing(true)
           }
        return true
    }
}

//EXTENSION REGISTER_RESULT_DELEGATE
extension RegisterVC: RegisterResultDelegate{
    func registerSuccess(title: String) {
        self.view.makeToast(title)
        DispatchQueue.main.async {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "mainTabBarVC")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func regisertAlert(title: String, message: String) {
        DispatchQueue.main.async{
            self.view.makeToast(message, title: title)
        }
    }
    
    
}
