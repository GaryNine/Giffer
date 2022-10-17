//
//  GiffCell.swift
//  Giffer
//
//  Created by Igor Deviatko on 16.10.2022.
//

import UIKit

protocol SelfConfiguringCell {
    static var reuseId: String { get }
    func configure(with value: AssetModel)
}

class GiffCell: UICollectionViewCell, SelfConfiguringCell {
    
    // MARK: -
    // MARK: Properties
    
    let gifImageView = UIImageView()
    
    // MARK: -
    // MARK: SelfConfiguringCell
    
    static var reuseId = "giffCell"
    
    func configure(with value: AssetModel) {
        // TODO: fill image via NetworkManager
        gifImageView.image = UIImage()
    }
    
    // MARK: -
    // MARK: Private
    
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
    
    // MARK: -
    // MARK: Initializations
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init(coder: has not been implemented")
    }
}
 




import SwiftUI

struct GiffCellProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let navVC = UINavigationController(rootViewController: GiffViewController())
        typealias context = UIViewControllerRepresentableContext<GiffCellProvider.ContainerView>
        
        func makeUIViewController(context: context) -> some UINavigationController {
            return navVC
        }
        
        func updateUIViewController(
            _ uiViewController: GiffCellProvider.ContainerView.UIViewControllerType,
            context: context
        ) { }
    }
}
