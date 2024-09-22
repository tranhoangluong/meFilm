//
//  DiscoverVC.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 8/9/24.
//

import UIKit

enum MovieType{
    case movies, tvSeries, topRated, upComing
}

class DiscoverVC: UIViewController{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControlView: UIView!
    
    var popularMovies  = [Movie]()
    var popularTvSeries = [Movie]()
    var topRated = [Movie]()
    var upComing = [Movie]()

    var currentMovieType: MovieType = .movies
    
    var delegate: CustomSegmentedControlDelegate?
    
    override func viewDidLoad() {
        setupSearchBar()
        setupSegmentedControl()
        setupCollectionView()
        change(to: 0)
    }
   
    func setupSegmentedControl(){
        let segmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: segmentControlView.frame.width, height: segmentControlView.frame.height), buttonTitle: ["Movies", "Tv Series", "Top rated", "Upcoming"])
        segmented.backgroundColor = UIColor(red: 21.0/255.0, green: 20.0/255.0, blue: 31.0/255.0, alpha: 1.0)
        segmented.delegate = self
        segmentControlView.addSubview(segmented)
    }
    
    func setupSearchBar(){
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont(name: "Gill Sans", size: 18)
            textField.textColor = UIColor.white
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            if let leftView = textField.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.white
            }
            let crossIconView = textField.value(forKey: "clearButton") as? UIButton
             crossIconView?.setImage(crossIconView?.currentImage?.withRenderingMode(.alwaysTemplate), for: .normal)
             crossIconView?.tintColor = .white
        }
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
        case 0: currentMovieType = .movies
            APICaller.shared.getPopularMovies{ [weak self] result in
                                 switch result {
                                 case .success(let movies):
                                     self?.popularMovies = movies
                                     DispatchQueue.main.async {
                                         self?.collectionView.reloadData()
                                     }
                                 case .failure(let error):
                                     print(error.localizedDescription)
                                 }
                             }
        case 1: currentMovieType = .tvSeries
            APICaller.shared.getPopularTVSeries{ [weak self] result in
                                 switch result {
                                 case .success(let movies):
                                     self?.popularTvSeries = movies
                                     DispatchQueue.main.async {
                                         self?.collectionView.reloadData()
                                     }
                                 case .failure(let error):
                                     print(error.localizedDescription)
                                 }
                             }
        case 2: currentMovieType = .topRated
            APICaller.shared.getTopRatedMovies{ [weak self] result in
                                 switch result {
                                 case .success(let movies):
                                     self?.topRated = movies
                                     DispatchQueue.main.async {
                                         self?.collectionView.reloadData()
                                     }
                                 case .failure(let error):
                                     print(error.localizedDescription)
                                 }
                             }
        case 3: currentMovieType = .upComing
            APICaller.shared.getUpComingMovies{ [weak self] result in
                                 switch result {
                                 case .success(let movies):
                                     self?.upComing = movies
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
        switch currentMovieType {
        case .movies:
                return popularMovies.count
        case .tvSeries:
                return popularTvSeries.count
        case .topRated:
            return topRated.count
        case .upComing:
            return upComing.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseCollectionViewCell", for: indexPath) as! ReuseCollectionViewCell
        
        switch currentMovieType {
        case .movies :
            if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(popularMovies[indexPath.row].poster_path ?? "")") {cell.imgMovie.sd_setImage(with: url)}
            cell.lblMovie.text = popularMovies[indexPath.row].original_title
        case .tvSeries:
            if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(popularTvSeries[indexPath.row].poster_path ?? "")") {cell.imgMovie.sd_setImage(with: url)}
            cell.lblMovie.text = popularTvSeries[indexPath.row].original_name
        case .topRated:
            if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(topRated[indexPath.row].poster_path ?? "")") {cell.imgMovie.sd_setImage(with: url)}
            cell.lblMovie.text = topRated[indexPath.row].original_title ?? topRated[indexPath.row].original_name
        case .upComing:
            if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(upComing[indexPath.row].poster_path ?? "")") {cell.imgMovie.sd_setImage(with: url)}
            cell.lblMovie.text = upComing[indexPath.row].original_title ?? upComing[indexPath.row].original_name
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
        present(vc, animated: true, completion: nil)
    }
}

