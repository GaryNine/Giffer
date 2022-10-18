//
//  Giff.swift
//  Giffer
//
//  Created by Igor Deviatko on 16.10.2022.
//

import Foundation

struct Response: Decodable {
    
    let results: [GIF]?
    let next: String?
}

struct GIF: Decodable {
    
    let id: String?
    let url: URL?
    let title: String?
    let media: [MediaCollection]?
}

struct MediaCollection: Decodable {
    
    let tinygif: Media?
}

struct Media: Decodable {
    
    let url: URL?
    let preview: URL?
}
