//
//  ViewController.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 26/8/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstView()
    }
    
    func setupFirstView(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "loginVC")
        vc.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
