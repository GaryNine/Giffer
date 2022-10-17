//
//  ViewController.swift
//  Giffer
//
//  Created by Igor Deviatko on 15.10.2022.
//

import UIKit

class GiffViewController: UIViewController {
    
    // MARK: -
    // MARK: Properties
    
    var collectionView: UICollectionView!
    let networkManager = NetworkManager()
    
    enum Section: Int, CaseIterable {
        case horizontalSection, verticalSection
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, AssetModel>?
    
    // There should be one array of AssetModel for vertical and horizontal representation
    
    private var assetModel: AssetModel?
    let verticalGifs: [AssetModel] = []
    let horizontalGifs: [AssetModel] = []
    
    
    // MARK: -
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        reloadData()
    }
    
    // MARK: -
    // MARK: Private
        
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        view.backgroundColor = .white
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.register(GiffCell.self, forCellWithReuseIdentifier: "giffCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "giffCell2")
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AssetModel>()
        snapshot.appendSections([.horizontalSection, .verticalSection])
        snapshot.appendItems(verticalGifs, toSection: .verticalSection)
        snapshot.appendItems(horizontalGifs, toSection: .horizontalSection)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: -
// MARK: Data Source

extension GiffViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AssetModel>(collectionView: collectionView,
                                                                       cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown kind of section")
            }
            
            switch section {
            case .verticalSection:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "giffCell", for: indexPath)
                cell.backgroundColor = .systemBlue
                return cell
            case .horizontalSection:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "giffCell2", for: indexPath)
                cell.backgroundColor = .systemRed
                
                return cell
            }
        })
    }
}

// MARK: -
// MARK: Setup layout

extension GiffViewController {
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection in
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown kind of section")
            }
            
            switch section {
            case .verticalSection:
                return self.createActiveChats(with: layoutEnvironment)
            case .horizontalSection:
                return self.createWaitingChats(with: layoutEnvironment)
            }
        }
        
        return layout
    }
    
    // Creation should be the same
    
    private func createWaitingChats(with environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(200),
                                               heightDimension: .absolute(200))
        // 1
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
    
        return section
    }
    
    private func createActiveChats(with environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(200),
                                               heightDimension: .absolute(200))
        // 1
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        // 2
        let centerInset = (environment.container.contentSize.width - 200) / 2
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: centerInset, bottom: 0, trailing: centerInset)
        
        return section
    }
    
}

// MARK: -
// MARK: SearchBarDelegate

extension GiffViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        NetworkManager.fetchPopularGiffs(searchText: searchText) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let assetModel):
                    self.assetModel = assetModel!
                    self.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

// MARK: -
// MARK: Canvas

import SwiftUI

struct ViewControllerProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let navVC = UINavigationController(rootViewController: GiffViewController())
        typealias context = UIViewControllerRepresentableContext<ViewControllerProvider.ContainerView>
        
        func makeUIViewController(context: context) -> some UINavigationController {
            return navVC
        }
        
        func updateUIViewController(
            _ uiViewController: ViewControllerProvider.ContainerView.UIViewControllerType,
            context: context
        ) { }
    }
}

