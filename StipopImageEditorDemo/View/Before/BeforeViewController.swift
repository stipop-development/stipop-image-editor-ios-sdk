//
//  BeforeViewController.swift
//  StipopImageEditorDemo
//
//  Created by kyum on 2023/02/02.
//

import UIKit

class BeforeViewController: UIViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setInsets()
        goToMainPage()
    }
    
    private func goToMainPage(){
        let controller = MainController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
}
