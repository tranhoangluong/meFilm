//
//  DetailMovieVC.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 9/9/24.
//

import UIKit

class DetailMovieVC: UIViewController {
    
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nameMovie: UILabel!
    @IBOutlet weak var movieResolution: UILabel!
    @IBOutlet weak var movieDuration: UIButton!
    @IBOutlet weak var movieRate: UIButton!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieSynopsis: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHeaderView()
        setupBodyView()
    }

    func setupHeaderView(){
        let heroHeaderView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height))
        headerView.addSubview(heroHeaderView)
    }
  
    func setupBodyView(){
        let reuseCollectionViewCell =  UINib(nibName: "ReuseCollectionViewCell", bundle: nil)
        collectionView.register(reuseCollectionViewCell, forCellWithReuseIdentifier: "reuseCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        movieResolution.layer.masksToBounds = true
        movieResolution.layer.cornerRadius = 8
        movieResolution.layer.borderWidth = 1
        movieResolution.layer.borderColor = UIColor.white.cgColor
        
        movieGenre.layer.masksToBounds = true
        movieGenre.layer.cornerRadius = 10
        movieGenre.layer.borderWidth = 1
        movieGenre.layer.borderColor = UIColor.white.cgColor
        
    }
    
}

extension DetailMovieVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseCollectionViewCell", for: indexPath) as! ReuseCollectionViewCell
        cell.backgroundColor = .red
        return cell
    }
}
