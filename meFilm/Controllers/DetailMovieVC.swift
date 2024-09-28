//
//  DetailMovieVC.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 9/9/24.
//

import UIKit
import WebKit

class DetailMovieVC: UIViewController {
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var wkWebview: WKWebView!

    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieResolution: UILabel!
    @IBOutlet weak var movieDuration: UILabel!
    @IBOutlet weak var movieRate: UILabel!
    @IBOutlet weak var movieReleaseDate: UILabel!
    @IBOutlet weak var movieGenre1: UILabel!
    @IBOutlet weak var movieGenre2: UILabel!
    @IBOutlet weak var movieOverview: UITextView!
    
    @IBOutlet weak var collectionView: UICollectionView!

    var similarMovies = [Movie]()
    var movieId: Int?
    var movie: MovieDetail?
    var trailer: Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        setupCollectionView()
        fetchSimilarMovie()
        fetchDetailMovie()
    }
    
    func configView(){
        btnBack.layer.masksToBounds = true
        btnBack.layer.cornerRadius =  btnBack.frame.height / 2
        btnBack.addTarget(self, action: #selector(onTapBack), for: .touchUpInside)
        
        movieResolution.layer.masksToBounds = true
        movieResolution.layer.cornerRadius = 8
        movieResolution.layer.borderWidth = 1
        movieResolution.layer.borderColor = UIColor.white.cgColor
        
        movieGenre1.layer.masksToBounds = true
        movieGenre1.layer.cornerRadius = 8
        movieGenre1.layer.borderWidth = 1
        movieGenre1.layer.borderColor = UIColor.white.cgColor
        
        movieGenre2.layer.masksToBounds = true
        movieGenre2.layer.cornerRadius = 8
        movieGenre2.layer.borderWidth = 1
        movieGenre2.layer.borderColor = UIColor.white.cgColor
        
    }
    
    @objc func onTapBack(){
        dismiss(animated: true)
    }
    
    func setupCollectionView(){
        let reuseCollectionViewCell =  UINib(nibName: "ReuseCollectionViewCell", bundle: nil)
        collectionView.register(reuseCollectionViewCell, forCellWithReuseIdentifier: "reuseCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func fetchSimilarMovie(){
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
    
    func fetchDetailMovie(){
        APICaller.shared.getDetailMovie(movieId: movieId!){ [weak self] result in
            switch result {
            case .success(let movie):
                DispatchQueue.main.async {
                    self?.movieTitle.text = movie.original_title
                    self?.movieResolution.text = movie.status
                    self?.movieRate.text = "\(movie.vote_average) IMDb"
                    self?.movieOverview.text = movie.overview
                    self?.movieReleaseDate.text = movie.release_date
                    self?.movieDuration.text = "\(movie.runtime) minutes"
                    self?.movieGenre1.text = movie.genres[0].name
                    self?.movieGenre2.text = movie.genres[1].name
                    APICaller.shared.getTrailer(with: movie.original_title!) { [weak self] result in
                        switch result {
                        case .success(let video):
                            DispatchQueue.main.async {
                                guard let url = URL(string: "https://www.youtube.com/embed/\( video.id.videoId)") else {
                                    return
                                }
                                self?.wkWebview.load(URLRequest(url: url))
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
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
        
        if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(similarMovies[indexPath.row].poster_path ?? "")") {cell.imgMovie.sd_setImage(with: url)
            cell.imgMovie.contentMode = .scaleAspectFill}
        cell.lblMovie.text = similarMovies[indexPath.row].original_title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = (view.frame.width - 30) / 2
        return CGSize(width: width, height: width)
    }
}
