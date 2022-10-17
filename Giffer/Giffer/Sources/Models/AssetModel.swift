//
//  Giff.swift
//  Giffer
//
//  Created by Igor Deviatko on 16.10.2022.
//

import Foundation

struct AssetModel: Hashable, Decodable {
    
    struct LoopedMP4: Decodable {
        let url: URL
        //let preview: URL
    }
    
    struct Media: Decodable {
        let loopedmp4: LoopedMP4
    }
    
    struct GIFS: Decodable {
        let media: [Media]
        let title: String
    }
    
    let results: [GIFS]
    let next: String?
    
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: AssetModel, rhs: AssetModel) -> Bool {
        return lhs.id == rhs.id
    }
}
