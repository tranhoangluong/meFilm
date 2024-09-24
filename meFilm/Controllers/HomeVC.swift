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
    
    var trendingAll  = [Movie]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        setupCollectionView()
        fetchData()
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
    
    func fetchData(){
        APICaller.shared.getTrendingAll { [weak self] result in
                   switch result {
                   case .success(let movies):
                       self?.trendingAll = movies
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
        return trendingAll.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 16
        
        let data = trendingAll[indexPath.row]
        
        if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(data.poster_path ?? "")") {cell.imgMovie.sd_setImage(with: url)}
        cell.nameMovie.text = data.original_title ?? data.original_name
        cell.rateAverageMovie.text = "\(data.vote_average)"
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath)  as? HomeCollectionViewCell
        collectionView.bringSubviewToFront(selectedCell!)
           UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
               selectedCell?.transform = CGAffineTransform(scaleX: 1.5, y: 2)
               })

        let vc = DetailMovieVC(nibName: "DetailMovieVC", bundle: nil)
        let passData = trendingAll[indexPath.row]
        vc.movieId = passData.id
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let unselectedCell = collectionView.cellForItem(at: indexPath)  as? HomeCollectionViewCell
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 0, options: [], animations: {
            unselectedCell?.transform = .identity
        })
    }
    
}

