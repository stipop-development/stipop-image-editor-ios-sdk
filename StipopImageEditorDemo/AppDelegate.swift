//
//  MainController.swift
//  StipopImageEditorDemo
//
//  Created by kyum on 2023/02/02.
//

import UIKit
//import StipopImageEditor

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
//    let semaphore = DispatchSemaphore(value: 1)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initView()
        return true
    }
    
    private func initView(){
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: BeforeViewController())
    }
}
