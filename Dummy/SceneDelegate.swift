//
//  SceneDelegate.swift
//  Dummy
//
//  Created by Anmol Kalra on 13/07/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window = UIWindow(windowScene: windowScene)
		let homeVC = ViewController()
		let navController = UINavigationController(rootViewController: homeVC)
		window?.rootViewController = navController
		window?.makeKeyAndVisible()
	}
}
