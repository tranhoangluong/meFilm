//
//  HomeVC.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 7/9/24.
//

import UIKit
import SDWebImage

class HomeVC: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var trendingMovies  = [Movie]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        configView()
        setupCollectionView()
        fetchTrendingAll()
    }
    
    func setupNavigationController(){
        navigationItem.title = "Stream Everywhere"
        navigationController?.navigationBar.barTintColor = UIColor(red: 21.0/225.0, green: 20.0/255.0, blue: 31.0/255.0, alpha: 1.0)
        tabBarController?.tabBar.barTintColor = UIColor(red: 21.0/225.0, green: 20.0/255.0, blue: 31.0/255.0, alpha: 1.0)
               navigationController?.navigationBar.prefersLargeTitles = true
               navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Gill Sans", size: 25) ?? UIFont.systemFont(ofSize: 25)]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Gill Sans", size: 25) ?? UIFont.systemFont(ofSize: 25)]
    }
    
    func configView(){
        imgMovie.layer.masksToBounds = true
        imgMovie.layer.cornerRadius = 16
        playButton.layer.masksToBounds = true
        playButton.layer.cornerRadius = 16
    }
    
    func setupCollectionView(){
        let homeCollectionViewCell =  UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        collectionView.register(homeCollectionViewCell, forCellWithReuseIdentifier: "homeCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func fetchTrendingAll(){
        APICaller.shared.getTrendingMovies { [weak self] result in
                   switch result {
                   case .success(let movies):
                       self?.trendingMovies = movies
                       DispatchQueue.main.async {
                           self?.collectionView.reloadData()
                       }
                   case .failure(let error):
                       print(error.localizedDescription)
                   }
               }
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendingMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 16
        
        if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(trendingMovies[indexPath.row].poster_path ?? "")") {cell.imgMovie.sd_setImage(with: url)}
        cell.nameMovie.text = trendingMovies[indexPath.row].original_title
        cell.rateAverageMovie.text = "\(trendingMovies[indexPath.row].vote_average)"
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailMovieVC(nibName: "DetailMovieVC", bundle: nil)
        vc.movieId =  trendingMovies[indexPath.row].id
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}

