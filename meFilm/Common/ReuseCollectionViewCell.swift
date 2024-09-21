//
//  ReuseCollectionViewCell.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 8/9/24.
//

import UIKit

class ReuseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var lblMovie: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    
    func configView(){
        imgMovie.layer.masksToBounds = true
        imgMovie.layer.cornerRadius = 16
    }
}
