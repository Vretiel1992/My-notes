//
//  AppDelegate.swift
//  TestTaskCFT
//
//  Created by Антон Денисюк on 24.12.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let firstNote = Note.getFirstNote()
        let notes = StorageManager.shared.fetchFromFile()
        guard notes.isEmpty && !notes.contains(firstNote) else { return true }
        StorageManager.shared.saveToFile(with: firstNote)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
