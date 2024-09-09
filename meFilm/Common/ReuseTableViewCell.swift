//
//  ReuseTableViewCell.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 8/9/24.
//

import UIKit

class ReuseTableViewCell: UITableViewCell {

    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var btnWatching: UIButton!
    
    func setupImgMovie(){
        imgMovie.layer.masksToBounds = true
        imgMovie.layer.cornerRadius = 16
    }
 
    func setupBtnWatching(){
        btnWatching.layer.masksToBounds = true
        btnWatching.layer.cornerRadius = 16
        btnWatching.layer.borderWidth = 1
        btnWatching.layer.borderColor = UIColor.white.cgColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImgMovie()
        setupBtnWatching()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
