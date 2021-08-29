//
//  SceneDelegate.swift
//  AirLiftCaseStudy
//
//  Created by Ammad on 27/08/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let apiClient = APIClient()
        let persistanceStore = PhotoPersistanceStore()
        let dataRepository = DataRepository(persistanceStore: persistanceStore, apiClient: apiClient)
        let viewModel = PhotoViewModel(dataRepository: dataRepository)
        let navigationController = UINavigationController(rootViewController: PhotosViewController(viewModel: viewModel))
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}

