//
//  NetworkManager.swift
//  Giffer
//
//  Created by Igor Deviatko on 17.10.2022.
//

import Foundation

fileprivate let limit = 7
fileprivate let command = "v1/search"
fileprivate var urlQuery = "?"
fileprivate let baseUrl = URL(string: "https://api.tenor.com/")

protocol NetworkProtocol {
    
     var decoder: JSONDecoder { get }
     func fetchPopularGiffs(searchText: String?, callback: @escaping (Result<Response?, Error>) -> Void)
}

extension NetworkProtocol {
     var decoder: JSONDecoder  {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

class NetworkManager: NetworkProtocol {
    
    // MARK: -
    // MARK: Public
    
     func makeParamsWithSearchText(text: String) -> [String: String] {
        return ["tag" : text,
                "key" : "LIVDSRZULELA",
                "limit": "\(limit)"]
    }
    
     func paramString(parameters: [String: String]) -> String {
        var string = parameters.reduce("") { $0 + "&\($1.0)=\($1.1)" }
        string.removeFirst()
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
     func fetchPopularGiffs(searchText: String?, callback: @escaping (Result<Response?, Error>) -> Void) {
        let parameters = makeParamsWithSearchText(text: searchText!)
        let urlData = command + urlQuery + paramString(parameters: parameters)
        let url = URL(string: urlData, relativeTo: baseUrl!)
        guard let url = url else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                callback(.failure(error))
                
                return
            }
            do {
                guard let data = data else { return }
                let response = try self.decoder.decode(Response.self, from: data)
                callback(.success(response))
                self.processError(error)
            } catch { callback(.failure(error)) }
        }
        .resume()
    }
    
      private func processError(_ error : Error?) {
        if let error = error {
            print("network response error \(error)")
        }
    }
}
