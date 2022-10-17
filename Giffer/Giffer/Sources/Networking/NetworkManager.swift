//
//  NetworkManager.swift
//  Giffer
//
//  Created by Igor Deviatko on 17.10.2022.
//

import Foundation
import Alamofire

protocol NetworkProtocol {
}

class NetworkManager: NetworkProtocol {

    // MARK: -
    // MARK: Public
    
    static func fetchPopularGiffs(searchText: String? , callback: @escaping (Result<AssetModel?, Error>) -> Void) {
        let apikey = "LIVDSRZULELA"
        let searchTerm = searchText == nil ? "excited" : searchText
        let limit = 3
        let urlWithFormat = String(format: "https://g.tenor.com/v1/search?q=%@&key=%@&limit=%d", searchTerm!, apikey, limit)
        let url = URL(string: urlWithFormat)!
        let searchRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: searchRequest) { data, response, error in
            if let error = error {
                callback(.failure(error))
                
                return
            }
            
            do {
                let assetModel = try JSONDecoder().decode(AssetModel.self, from: data!)
                callback(.success(assetModel))
            } catch { callback(.failure(error)) }
        }.resume()
    }
}
