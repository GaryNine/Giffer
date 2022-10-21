//
//  Layouts.swift
//  Giffer
//
//  Created by Igor Deviatko on 18.10.2022.
//

import UIKit

protocol SectionHandlerProtocol {
    func handleSection()
}

enum Section: Int, CaseIterable {
    case horizontalSection, verticalSection
}

func createCompositionalLayout(handler: SectionHandlerProtocol) -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection in
        guard let section = Section(rawValue: sectionIndex) else {
            fatalError("Unknown kind of section")
        }
        switch section {
        case .verticalSection:
            let verticalSection = creatVerticalSection(with: layoutEnvironment)
            verticalSection.visibleItemsInvalidationHandler = { visibleItems, scrollOffset, layoutEnvironment in
                let position = scrollOffset.y
                guard let lastItem = visibleItems.last else { return }
                let contentHeight = layoutEnvironment.container.contentSize.height
                if position > (lastItem.frame.height * LayoutConstants.defaultItemsCount) - contentHeight {
                    handler.handleSection()
                }
            }
            
            return verticalSection
            
        case .horizontalSection:
            let horizontalSection = createHorizontalSection(with: layoutEnvironment)
            horizontalSection.visibleItemsInvalidationHandler = { visibleItems, scrollOffset, layoutEnvironment in
                let position = scrollOffset.x
                guard let lastItem = visibleItems.last else { return }
                let contentWidth = layoutEnvironment.container.contentSize.width
                if position > (lastItem.frame.width * LayoutConstants.defaultItemsCount) - contentWidth {
                    handler.handleSection()
                }
            }
            
            return horizontalSection
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
    
    static let defaultItemsCount: CGFloat = 7
    
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
