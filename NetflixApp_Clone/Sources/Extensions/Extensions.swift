//
//  Extensions.swift
//  NetflixApp_Clone
//
//  Created by User on 14.09.2022.
//

import Foundation
import UIKit

extension SceneDelegate {
    static var shared: SceneDelegate {
        return (UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate)
    }
}

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
