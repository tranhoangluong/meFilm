//
//  ResultsSearchVC.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 23/9/24.
//

import UIKit

class ResultsSearchVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    public var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    func setupCollectionView(){
        let reuseCollectionViewCell =  UINib(nibName: "ReuseCollectionViewCell", bundle: nil)
        collectionView.register(reuseCollectionViewCell, forCellWithReuseIdentifier: "reuseCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
 
}


extension ResultsSearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseCollectionViewCell", for: indexPath) as! ReuseCollectionViewCell
        if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(movies[indexPath.row].poster_path ?? "")") {cell.imgMovie.sd_setImage(with: url)}
        cell.lblMovie.text = movies[indexPath.row].original_title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = (view.frame.width - 30) / 2
            return CGSize(width: width, height: width*2)
    }
}
