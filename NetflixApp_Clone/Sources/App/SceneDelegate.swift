//
//  SceneDelegate.swift
//  NetflixApp_Clone
//
//  Created by User on 14.09.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.overrideUserInterfaceStyle = .dark
        window?.rootViewController = LoginViewController()
        window?.makeKeyAndVisible()
    }

    func changeViewcontroller(viewController: UIViewController, animated: Bool, animationOptions: UIView.AnimationOptions) {
        guard let window = window else { return }
        window.rootViewController = viewController
        let options: UIView.AnimationOptions = [animationOptions]
        UIView.transition(with: window,
                          duration: 0.5,
                          options: options,
                          animations: nil,
                          completion: nil)
    }
}

