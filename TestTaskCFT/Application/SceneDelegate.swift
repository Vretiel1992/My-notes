//
//  SceneDelegate.swift
//  TestTaskCFT
//
//  Created by Антон Денисюк on 24.12.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let mainVC = ModuleBuilder.createMainModule()
        let navController = UINavigationController(rootViewController: mainVC)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}
