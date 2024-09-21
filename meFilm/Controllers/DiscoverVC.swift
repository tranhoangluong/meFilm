//
//  DiscoverVC.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 8/9/24.
//

import UIKit


enum MovieType: Int {
    case movies = 0
    case tvSeries = 1
}

class DiscoverVC: UIViewController{
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControlView: UIView!
    
    var popularMovies  = [Movie]()
    var popularTvSeries = [Movie]()
    var currentMovieType: MovieType = .movies
    
    var delegate: CustomSegmentedControlDelegate?
    
    override func viewDidLoad() {
        setupSearchBar()
        setupSegmentedControl()
        setupCollectionView()
    }
   
    func setupSegmentedControl(){
        let segmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: segmentControlView.frame.width, height: segmentControlView.frame.height), buttonTitle: ["Movies", "Tv Series", "Top rated", "Upcoming"])
        segmentControlView.backgroundColor = .clear
        segmentControlView.addSubview(segmented)
        segmented.delegate = self
    }
    
    func setupSearchBar(){
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont(name: "Gill Sans", size: 18)
            textField.textColor = UIColor.white
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "Doreamon", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
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

extension DiscoverVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CustomSegmentedControlDelegate{
    func change(to index: Int) {
        switch index {
        case 0: currentMovieType = .movies
        case 1: currentMovieType = .tvSeries
        default: break
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentMovieType {
            case .movies:
                return popularMovies.count
            case .tvSeries:
                return popularTvSeries.count
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuseCollectionViewCell", for: indexPath) as! ReuseCollectionViewCell
        
        switch indexPath.section {
        case MovieType.movies.rawValue :
            APICaller.shared.getPopularMovies{ [weak self] result in
                       switch result {
                       case .success(let movies):
                           self?.popularMovies = movies
                           DispatchQueue.main.async {
                               self?.collectionView.reloadData()
                           }
                           if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(self?.popularMovies[indexPath.row].poster_path ?? "")") {cell.imgMovie.sd_setImage(with: url)}
                           cell.lblMovie.text = self?.popularMovies[indexPath.row].original_title
                       case .failure(let error):
                           print(error.localizedDescription)
                       }
                   }
        case MovieType.tvSeries.rawValue:
            APICaller.shared.getPopularTVSeries{ [weak self] result in
                       switch result {
                       case .success(let movies):
                           self?.popularTvSeries = movies
                           DispatchQueue.main.async {
                               self?.collectionView.reloadData()
                           }
                          
                           if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(self?.popularTvSeries[indexPath.row].poster_path ?? "")") {cell.imgMovie.sd_setImage(with: url)}
                           cell.lblMovie.text = self?.popularTvSeries[indexPath.row].original_title
                       case .failure(let error):
                           print(error.localizedDescription)
                       }
                   }
        default:
           return UICollectionViewCell()
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

