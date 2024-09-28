//
//  DiscoverVC.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 8/9/24.
//

import UIKit

enum MovieType{
    case popularMovies, nowplayingMovies, topratedMovies, upcomingMovies
}

class DiscoverVC: UIViewController, UISearchBarDelegate{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControlView: UIView!
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: ResultsSearchVC())
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.searchTextField.placeholder(text: "Search for a Movie")
        return controller
       }()
        
    var movies = [Movie]()
    
    var resultSearch = [Movie]()

    var currentMovieType: MovieType = .popularMovies
    
    var delegate: CustomSegmentedControlDelegate?
    
    override func viewDidLoad() {
        setupNavigationController()
        setupSegmentedControl()
        setupCollectionView()
        change(to: 0)
    }
   
    func setupNavigationController(){
        navigationItem.title = "Discover the best movies, here!"
        navigationController?.navigationBar.barTintColor = UIColor(red: 21.0/225.0, green: 20.0/255.0, blue: 31.0/255.0, alpha: 1.0)
        tabBarController?.tabBar.barTintColor = UIColor(red: 21.0/225.0, green: 20.0/255.0, blue: 31.0/255.0, alpha: 1.0)
               navigationController?.navigationBar.prefersLargeTitles = true
               navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Gill Sans", size: 25) ?? UIFont.systemFont(ofSize: 25)]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "Gill Sans", size: 25) ?? UIFont.systemFont(ofSize: 25)]
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchTextField.font = UIFont(name: "Gill Sans", size: 18)
    }
    
    func setupSegmentedControl(){
        let segmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: segmentControlView.frame.width, height: segmentControlView.frame.height), buttonTitle: ["Popular", "Now Playing", "Top Rated", "Upcoming"])
        segmented.backgroundColor = UIColor(red: 21.0/255.0, green: 20.0/255.0, blue: 31.0/255.0, alpha: 1.0)
        segmented.delegate = self
        segmentControlView.addSubview(segmented)
    }
    
    func setupCollectionView(){
        let reuseCollectionViewCell =  UINib(nibName: "ReuseCollectionViewCell", bundle: nil)
        collectionView.register(reuseCollectionViewCell, forCellWithReuseIdentifier: "reuseCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension DiscoverVC: CustomSegmentedControlDelegate{
    func change(to index: Int) {
        switch index {
        case 0: currentMovieType = .popularMovies
            APICaller.shared.getPopularMovies{ [weak self] result in
                                 switch result {
                                 case .success(let movies):
                                     self?.movies = movies
                                     DispatchQueue.main.async {
                                         self?.collectionView.reloadData()
                                     }
                                 case .failure(let error):
                                     print(error.localizedDescription)
                                 }
                             }
        case 1: currentMovieType = .nowplayingMovies
            APICaller.shared.getNowPlayingMovies{ [weak self] result in
                                 switch result {
                                 case .success(let movies):
                                     self?.movies = movies
                                     DispatchQueue.main.async {
                                         self?.collectionView.reloadData()
                                     }
                                 case .failure(let error):
                                     print(error.localizedDescription)
                                 }
                             }
        case 2: currentMovieType = .topratedMovies
            APICaller.shared.getTopRatedMovies{ [weak self] result in
                                 switch result {
                                 case .success(let movies):
                                     self?.movies = movies
                                     DispatchQueue.main.async {
                                         self?.collectionView.reloadData()
                                     }
                                 case .failure(let error):
                                     print(error.localizedDescription)
                                 }
                             }
        case 3: currentMovieType = .upcomingMovies
            APICaller.shared.getUpComingMovies{ [weak self] result in
                                 switch result {
                                 case .success(let movies):
                                     self?.movies = movies
                                     DispatchQueue.main.async {
                                         self?.collectionView.reloadData()
                                     }
                                 case .failure(let error):
                                     print(error.localizedDescription)
                                 }
                             }
        default: break
        }
    }
}


extension DiscoverVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseCollectionViewCell", for: indexPath) as! ReuseCollectionViewCell
        
        func configCell(){
            let data = movies[indexPath.row]
            if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(data.poster_path ?? "")") {cell.imgMovie.sd_setImage(with: url)}
            cell.lblMovie.text = data.original_title
        }
        
        switch currentMovieType{
        case .popularMovies:
            configCell()
        case .nowplayingMovies:
            configCell()
        case .topratedMovies:
            configCell()
        case .upcomingMovies:
            configCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = (view.frame.width - 30) / 2
            return CGSize(width: width, height: width*2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailMovieVC(nibName: "DetailMovieVC", bundle: nil)
        vc.modalPresentationStyle = .fullScreen
        vc.movieId = movies[indexPath.row].id
        present(vc, animated: true, completion: nil)
    }
}

extension DiscoverVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
                
                guard let query = searchBar.text,
                      !query.trimmingCharacters(in: .whitespaces).isEmpty,
                      query.trimmingCharacters(in: .whitespaces).count >= 3,
                      let resultsController = searchController.searchResultsController as? ResultsSearchVC else {
                          return
                      }
                APICaller.shared.search(with: query) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let movies):
                            resultsController.movies = movies
                            resultsController.collectionView.reloadData()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
    }
}
