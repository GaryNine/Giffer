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
    
    var isPaginating: Bool { get set }
    
    var decoder: JSONDecoder { get }
    func fetchPopularGiffs(searchText: String?, pagination: Bool, callback: @escaping (Result<Response?, Error>) -> Void)
}

extension NetworkProtocol {
            
     var decoder: JSONDecoder  {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

class NetworkManager: NetworkProtocol {

    var isPaginating = false
    var next: String?
    
    // MARK: -
    // MARK: Public
    
    func fetchPopularGiffs(searchText: String?, pagination: Bool = false, callback: @escaping (Result<Response?, Error>) -> Void) {
        if isPaginating { return }
        isPaginating = pagination
        guard let searchText = searchText else { return }
        var parameters = makeParamsWithSearchText(text: searchText)
        if isPaginating { parameters["pos"] = "\(next ?? "")" }
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
                guard let data = data else {
                    self.processError(error)
                    return
                }
                let response = try self.decoder.decode(Response.self, from: data)
                self.next = response.next
                callback(.success(response))
                self.isPaginating = false
                self.processError(error)
            } catch { callback(.failure(error)) }
        }
        .resume()
    }
    
    // MARK: -
    // MARK: Private
    
    func makeParamsWithSearchText(text: String) -> [String: String] {
       return ["tag" : text,
               "key" : "LIVDSRZULELA",
               "limit" : "\(limit)"]
   }
   
    func paramString(parameters: [String: String]) -> String {
       var string = parameters.reduce("") { $0 + "&\($1.0)=\($1.1)" }
       string.removeFirst()
       return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
   }
    
      private func processError(_ error : Error?) {
        if let error = error {
            print("network response error \(error)")
        }
    }
}
