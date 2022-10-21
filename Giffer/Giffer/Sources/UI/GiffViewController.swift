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
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, GiffViewModel>?
    
    private var verticalSectionModels: [GiffViewModel] = []
    private var horizontalSectionModels: [GiffViewModel] = []
    
    var presenter: MainPresenter!
    
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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout(handler: self))
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.register(GiffCell.self, forCellWithReuseIdentifier: GiffCell.reuseId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "giffCell2")
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, GiffViewModel>()
        snapshot.appendSections([.horizontalSection, .verticalSection])
        snapshot.appendItems(verticalSectionModels, toSection: .verticalSection)
        snapshot.appendItems(horizontalSectionModels, toSection: .horizontalSection)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: -
// MARK: Data Source

extension GiffViewController {
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, GiffViewModel>(collectionView: collectionView,
                                                                                cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown kind of section")
            }
            
            switch section {
            case .verticalSection, .horizontalSection:
                return self.configure(cellType: GiffCell.self, with: itemIdentifier, for: indexPath)
            }
        })
    }
    
    private func configure<T: SelfConfiguringCell>(cellType: T.Type , with value: GiffViewModel, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath)
                as? T else { fatalError("Unable to dequeue \(cellType)") }
        cell.configure(with: value)
        
        return cell
    }
    
    func populateViewModelsWith(urls: [URL]) {
        let verticalModels = urls.map { GiffViewModel(url: $0) }
        self.verticalSectionModels.append(contentsOf: verticalModels)
        let horizontalModels = urls.map { GiffViewModel(url: $0) }
        self.horizontalSectionModels.append(contentsOf: horizontalModels)

        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}

// MARK: -
// MARK: SearchBarDelegate

extension GiffViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.fetchGifsByText(text: searchText)
    }
}

extension GiffViewController: SectionHandlerProtocol {
    func handleSection() {
        guard let text = navigationItem.searchController?.searchBar.text else { return }
        presenter.fetchGifsByText(text: text, pagination: true)
    }
}
