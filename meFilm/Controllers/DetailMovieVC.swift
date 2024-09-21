//
//  DetailMovieVC.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 9/9/24.
//

import UIKit

class DetailMovieVC: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var bodyView: UIView!
 
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nameMovie: UILabel!
    @IBOutlet weak var movieResolution: UILabel!
   
    @IBOutlet weak var movieDuration: UILabel!
    @IBOutlet weak var movieRate: UILabel!
    
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieGenre1: UILabel!
    @IBOutlet weak var movieGenre2: UILabel!
    
    @IBOutlet weak var movieSynopsis: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        setupCollectionView()
    }
    
    func configView(){
        let heroHeaderView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height))
        headerView.addSubview(heroHeaderView)
        
        movieResolution.layer.masksToBounds = true
        movieResolution.layer.cornerRadius = 16
        movieResolution.layer.borderWidth = 1
        movieResolution.layer.borderColor = UIColor.white.cgColor
        
        movieGenre1.layer.masksToBounds = true
        movieGenre1.layer.cornerRadius = 16
        movieGenre1.layer.borderWidth = 1
        movieGenre1.layer.borderColor = UIColor.white.cgColor
        
        movieGenre2.layer.masksToBounds = true
        movieGenre2.layer.cornerRadius = 16
        movieGenre2.layer.borderWidth = 1
        movieGenre2.layer.borderColor = UIColor.white.cgColor
        
    }
  
    func setupCollectionView(){
        let reuseCollectionViewCell =  UINib(nibName: "ReuseCollectionViewCell", bundle: nil)
        collectionView.register(reuseCollectionViewCell, forCellWithReuseIdentifier: "reuseCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension DetailMovieVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseCollectionViewCell", for: indexPath) as! ReuseCollectionViewCell
        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = (view.frame.width - 30) / 2
        return CGSize(width: width, height: bodyView.frame.height)
    }
}
