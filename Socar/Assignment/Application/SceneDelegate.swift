//
//  SceneDelegate.swift
//  Assignment
//
//  Created by anna.bae on 2023/06/30.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var appDependency: AppDependency = AppDependency()
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.overrideUserInterfaceStyle = .light
        let discoverDependency = appDependency.makeDiscoverDependency()
        let viewModel = discoverDependency.makeDiscoverMapViewModel()
        let navigationController = Router.shared.makeRootMapViewController(viewModel: viewModel)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
}

