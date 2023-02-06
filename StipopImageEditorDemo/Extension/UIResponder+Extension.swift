//
//  UIResponder+Extension.swift
//  StipopImageEditorDemo
//
//  Created by kyum on 2023/02/03.
//

import UIKit

extension UIResponder {
    func getOwningViewController() -> UIViewController? {
        var nextResponser = self
        while let next = nextResponser.next {
            nextResponser = next
            if let viewController = nextResponser as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
