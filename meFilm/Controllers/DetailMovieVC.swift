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
    
    var similarMovies = [Movie]()
    
    var movieId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        setupCollectionView()
        fetchData()
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
    
    func fetchData(){
        APICaller.shared.getSimilarMovies(movieId: movieId!){ [weak self] result in
                             switch result {
                             case .success(let movies):
                                 self?.similarMovies = movies
                                 DispatchQueue.main.async {
                                     self?.collectionView.reloadData()
                                 }
                             case .failure(let error):
                                 print(error.localizedDescription)
                             }
                         }
    }
    
}

extension DetailMovieVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseCollectionViewCell", for: indexPath) as! ReuseCollectionViewCell
        if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(similarMovies[indexPath.row].poster_path ?? "")") {cell.imgMovie.sd_setImage(with: url)}
        cell.lblMovie.text = similarMovies[indexPath.row].original_title ?? similarMovies[indexPath.row].original_name
        cell.imgMovie.contentMode = .scaleAspectFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = (view.frame.width - 30) / 2
        return CGSize(width: width, height: width)
    }
}
