//
//  Assembly.swift
//  Giffer
//
//  Created by Igor Deviatko on 18.10.2022.
//

import UIKit

class AssemblyModuleBuilder {
    
    func createMainModule() -> UIViewController {
        let mainVC = GiffViewController()
        let networkService = NetworkManager()
        let presenter = MainPresenter(networkService: networkService, giffVC: mainVC)
        mainVC.presenter = presenter
        
        return mainVC
    }
}
