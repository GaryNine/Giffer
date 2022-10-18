//
//  GiffViewModel.swift
//  Giffer
//
//  Created by Igor Deviatko on 17.10.2022.
//

import Foundation

struct GiffViewModel {
    
    let url: URL
    let id = UUID().uuidString
}

extension GiffViewModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: GiffViewModel, rhs: GiffViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
