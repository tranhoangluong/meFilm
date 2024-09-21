//
//  HomeCollectionViewCell.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 15/9/24.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameMovie: UILabel!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var rateAverageMovie: UILabel!
    @IBOutlet weak var rateView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    func configView(){
        nameMovie.layer.masksToBounds = true
        nameMovie.layer.cornerRadius = 16
        rateView.layer.masksToBounds = true
        rateView.layer.cornerRadius = 16
    }
}
