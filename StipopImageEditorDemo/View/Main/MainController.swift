//
//  MainController.swift
//  StipopImageEditorDemo
//
//  Created by kyum on 2023/02/02.
//

import UIKit

class MainController: UIViewController {
    
    lazy var customView: MainView = {
        let view = MainView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = customView
    }
}
