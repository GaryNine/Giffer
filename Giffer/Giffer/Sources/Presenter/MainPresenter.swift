//
//  MainPresenter.swift
//  Giffer
//
//  Created by Igor Deviatko on 18.10.2022.
//

import Foundation

class MainPresenter {
    
    let networkService: NetworkProtocol!
    let giffVC: GiffViewController?
    
    // MARK: -
    // MARK: Initialization
    
    init(networkService: NetworkProtocol, giffVC: GiffViewController) {
        self.networkService = networkService
        self.giffVC = giffVC
    }
    
    // MARK: -
    // MARK: Public
    
    func fetchGifsByText(text: String) {
        networkService.fetchPopularGiffs(searchText: text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let url = response!.results?.compactMap { $0.media?[0].tinygif?.url }
                guard let url = url else {
                    print("Fail with url!")
                    return 
                }
                self.giffVC?.populateViewModelsWith(urls: url)
            case .failure(let error):
                print("Fail with data: \(error)")
            }
        }
    }
}
