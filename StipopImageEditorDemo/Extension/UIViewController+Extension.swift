//
//  UIViewController+Extension.swift
//  StipopImageEditorDemo
//
//  Created by kyum on 2023/02/02.
//

import UIKit

extension UIViewController {
    
    var safeAreaInsets: UIEdgeInsets {
        (UIApplication
            .shared
            .keyWindow?
            .rootViewController)
        .flatMap {
            return $0.view.safeAreaInsets
        } ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setInsets(){
        SESafeAreaInsetUtil.top = safeAreaInsets.top
        SESafeAreaInsetUtil.bottom = safeAreaInsets.bottom
    }
}
