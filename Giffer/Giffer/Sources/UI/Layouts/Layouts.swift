//
//  Layouts.swift
//  Giffer
//
//  Created by Igor Deviatko on 18.10.2022.
//

import UIKit

enum Section: Int, CaseIterable {
    case horizontalSection, verticalSection
}

func createCompositionalLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection in
        guard let section = Section(rawValue: sectionIndex) else {
            fatalError("Unknown kind of section")
        }
        switch section {
        case .verticalSection:
            return creatVerticalSection(with: layoutEnvironment)
            
        case .horizontalSection:
            return createHorizontalSection(with: layoutEnvironment)
        }
    }
    
    return layout
}

func createHorizontalSection(with environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(layoutSize: LayoutConstants.itemSize)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: LayoutConstants.groupSize,subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = LayoutConstants.sectionSpacing
    
    section.orthogonalScrollingBehavior = .continuous
    section.contentInsets = NSDirectionalEdgeInsets(top: LayoutConstants.inset,
                                                    leading: LayoutConstants.inset,
                                                    bottom: 0,
                                                    trailing: LayoutConstants.inset)
    
    return section
}

func creatVerticalSection(with environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    let item = NSCollectionLayoutItem(layoutSize: LayoutConstants.itemSize)
    let group = NSCollectionLayoutGroup.vertical(layoutSize: LayoutConstants.groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = LayoutConstants.sectionSpacing
    
    let centerInset = LayoutConstants.centerInsetVerticalFor(environment)
    section.contentInsets = NSDirectionalEdgeInsets(top: LayoutConstants.inset,
                                                    leading: centerInset,
                                                    bottom: 0,
                                                    trailing: centerInset)
    
    return section
}


// MARK: -
// MARK: Constants

struct LayoutConstants {
    
    static let inset: CGFloat = 20
    static let sectionSpacing: CGFloat = 15
    
    static let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(200),
                                                  heightDimension: .absolute(200))
    static let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                 heightDimension: .fractionalHeight(1))
    
    static func centerInsetVerticalFor(_ environment:  NSCollectionLayoutEnvironment) -> CGFloat {
        return (environment.container.contentSize.width - 200) / 2
    }
}
