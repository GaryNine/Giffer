//
//  SceneDelegate.swift
//  Giffer
//
//  Created by Igor Deviatko on 15.10.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: -
    // MARK: Properties

    var window: UIWindow?
    
    // MARK: -
    // MARK: UIWindowSceneDelegate

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let giffVC = AssemblyModuleBuilder().createMainModule()
        let navigationVC = UINavigationController(rootViewController: giffVC)
        
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
    }
}
