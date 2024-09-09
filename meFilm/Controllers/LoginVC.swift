//
//  LoginVC.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 26/8/24.
//

import UIKit
import FBSDKLoginKit
import Toast_Swift

class LoginVC: UIViewController{
  
    //DECLARE LOGINVIEWMODEL && AUTHSERVICE
    var loginVM = LoginVM()
    var authService = AuthService()
    
    //DECLARE USERMODEL
    private var user: User{
        let email = tfEmail.text ?? ""
        let password = tfPassword.text ?? ""
        let user = User(email: email, password: password)
        return user
    }
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnForgotPass: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblOr: UILabel!
    
    var btnFacebook = FBLoginButton()
    var btnRegisterNavigator = UIButton()
    var lblRegisterNavigator =  UIButton()
    var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupButton()
        setupStackView()
        loginVM.delegate = self //DECLARE LOGINVIEWMODEL DELEGATE
        authService.delegate = self //DECLARE AUTHSERVICE DELEGATE
    }
    
    func setupTextField(){
        //TEXTFIELD EMAIL
        tfEmail.underline()
        tfEmail.placeholder(text: "Email")
        tfEmail.tag = 0
        tfEmail.delegate = self
        
        //TEXTFIELD PASSWORD
        tfPassword.underline()
        tfPassword.placeholder(text: "Password")
        tfPassword.textContentType = .oneTimeCode
        tfPassword.tag = 1
        tfPassword.delegate = self
    }
    
    func setupButton(){
        //SET UP BUTTON LOGIN
        btnLogin.layer.masksToBounds = true
        btnLogin.layer.cornerRadius = 10
        
        //SET UP BUTTON LOGIN FACEBOOK
        view.addSubview(btnFacebook)
        
        //AUTOLAYOUT BUTTON LOGIN FACEBOOK
        btnFacebook.translatesAutoresizingMaskIntoConstraints = false
        btnFacebook.leadingAnchor.constraint(equalTo: btnLogin.leadingAnchor).isActive = true
        btnFacebook.trailingAnchor.constraint(equalTo: btnLogin.trailingAnchor).isActive = true
        btnFacebook.topAnchor.constraint(equalTo: lblOr.bottomAnchor, constant: 40).isActive = true
        
        btnFacebook.layer.masksToBounds = true
        btnFacebook.layer.cornerRadius = 10
        
        btnFacebook.addTarget(self, action: #selector(onTapFacebookLogin), for: .touchUpInside)
        btnFacebook.permissions = ["public_profile","email"]
        btnFacebook.delegate = self
    }
    
    func setupStackView(){
        //SET UP STACKVIEW
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: btnLogin.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: btnLogin.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: btnFacebook.bottomAnchor, constant: 40).isActive = true
        stackView.widthAnchor.constraint(equalTo: btnLogin.widthAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: btnLogin.heightAnchor).isActive = true
        
        stackView.addArrangedSubview(lblRegisterNavigator)
        stackView.addArrangedSubview(btnRegisterNavigator)
        stackView.spacing = 10
        
        //SET UP BUTTON NAVIGATE -> REGISTER SCREEN
        btnRegisterNavigator.translatesAutoresizingMaskIntoConstraints = false
        btnRegisterNavigator.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -40).isActive = true
        btnRegisterNavigator.setTitle("Register", for: .normal)
        btnRegisterNavigator.contentHorizontalAlignment = .left
        btnRegisterNavigator.addTarget(self, action: #selector(onTapRegisterNavigator), for: .touchUpInside)
        
        //SET UP LABEL SUBTITLE FOR BUTTON NAVIGATE -> REGISTER SCREEN
        lblRegisterNavigator.translatesAutoresizingMaskIntoConstraints = false
        lblRegisterNavigator.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 40).isActive = true
        lblRegisterNavigator.setTitle("Don't have an account?", for: .normal)
        
    }
    
    //NAVIGATE -> REGISTER SCREEN ACTION
    @objc func onTapRegisterNavigator(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "registerVC")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
    //FORGOT PASSWORD ACTION
    @IBAction func onTapForgotPassword(_ sender: Any) {
        loginVM.forgotPassword(email: tfEmail.text!)
        self.view.makeToast("Please check your email: \(tfEmail.text!)")
    }
    
    //LOGIN USER ACTION
    @IBAction func onTapLogin(_ sender: Any) {
        view.endEditing(true)
        if tfEmail.text == "" {
            self.view.makeToast("Please enter email")

            return
        }
        if tfPassword.text == "" {
            self.view.makeToast("Please enter password")
            return
        }
        
        if tfEmail.text != "" && tfPassword.text != "" {
            loginVM.login(user: user)
        }
        
    }
    
    //LOGIN FACEBOOK ACTION
    @objc func onTapFacebookLogin(){
        authService.logInFacebook(viewController: self)
    }
}

//EXTENSION TEXTFIELD_DELEGATE
extension LoginVC: UITextFieldDelegate{
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

//EXTENSION LOGIN_RESULT_DELEGATE
extension LoginVC: LoginResultDelegate{
    func loginSuccess(title: String) {
        self.view.makeToast(title)
        DispatchQueue.main.async{
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "mainTabBarVC")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func loginFail(title: String, message: String) {
        DispatchQueue.main.async {
            self.view.makeToast(message, title: title)
        }
    }

}

//EXTENSION SIGNIN_SERVICE_DELEGATE
extension LoginVC: SignInServiceDelegate{
    func logInFirstTime() {
        DispatchQueue.main.async {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "registerVC")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func logInBefore() {
        DispatchQueue.main.async {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "mainTabBarVC")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func logInFBAlert(title: String, message: String) {
        DispatchQueue.main.async {
            self.view.makeToast(message, title: title)
        }
    }
    
}

//EXTENSION FACEBOOK_LOGIN_BUTTON_DELEGATE
extension LoginVC: LoginButtonDelegate{
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: (any Error)?) {
        if AccessToken.current != nil {
            self.btnFacebook.isHidden = true
        }
        else{
            self.btnFacebook.isHidden = false
        }

    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        let loginManager = LoginManager()
        loginManager.logOut()
    }
    
}
