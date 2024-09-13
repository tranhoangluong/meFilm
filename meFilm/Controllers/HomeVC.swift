//
//  HomeVC.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 7/9/24.
//

import UIKit

class HomeVC: UIViewController {
  
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageMovie()
        setupPlayButton()
    }
    
    
    func setupImageMovie(){
        imgMovie.layer.masksToBounds = true
        imgMovie.layer.cornerRadius = 8
    }
    
    func setupPlayButton(){
        playButton.layer.masksToBounds = true
        playButton.layer.cornerRadius = 8
    }
    
    func setupCollectionView(){
        
    }


}
