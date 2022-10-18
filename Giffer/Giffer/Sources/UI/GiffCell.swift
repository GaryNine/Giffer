//
//  GiffCell.swift
//  Giffer
//
//  Created by Igor Deviatko on 16.10.2022.
//

import UIKit
import Kingfisher

protocol SelfConfiguringCell {
    
    static var reuseId: String { get }
    func configure(with value: GiffViewModel)
}

class GiffCell: UICollectionViewCell, SelfConfiguringCell {
    
    // MARK: -
    // MARK: Properties
    
    private let gifImageView = UIImageView()
    
    // MARK: -
    // MARK: SelfConfiguringCell
    
    static var reuseId = "giffCell"
    
    func configure(with value: GiffViewModel) {
        gifImageView.kf.indicatorType = .activity
        gifImageView.kf.setImage(with: value.url)
    }
    
    // MARK: -
    // MARK: Initializations
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init(coder: has not been implemented")
    }
}

// MARK: -
// MARK: SetUp constraints
 
extension GiffCell {
    
    private func setupConstraints() {
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gifImageView)
        
        NSLayoutConstraint.activate([
            gifImageView.topAnchor.constraint(equalTo: self.topAnchor),
            gifImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gifImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
