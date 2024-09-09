//
//  DetailMovieVC.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 9/9/24.
//

import UIKit

class DetailMovieVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView()
    }

    func setupHeaderView(){
        let headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2))
        view.addSubview(headerView)
    }
}
