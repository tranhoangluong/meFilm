//
//  HeroHeaderView.swift
//  meFilm
//
//  Created by Tran Chu Hoang Luong on 9/9/24.
//

import UIKit

class HeroHeaderView: UIView {
    
    private let playButton: UIButton = {
        let image = UIImage(systemName: "play.circle.fill")
        let button = UIButton()
        button.setImage(image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        button.tintColor = UIColor(red: 246.0/255.0, green: 138.0/255.0, blue: 109.0/255.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addSubview(playButton)
        applyConstraint()
    }
    
    private func applyConstraint(){
        playButton.centerXAnchor.constraint(equalTo: heroImageView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: heroImageView.centerYAnchor).isActive = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
}
