//
//  SceneDelegate.swift
//  CurrencyCalculator
//
//  Created by 임재현 on 6/4/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let service = ExchangeRateService()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = CalculatorViewController(exchangeRateService: service)
        window.makeKeyAndVisible()
        self.window = window

    }
}

