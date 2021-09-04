//
//  ButtonStyles.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 02/09/2021.
//

import UIKit

extension UIButton {
    static func barButton() -> UIButton {
        let button = UIButton()
        button.setImage(K.images.reset, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .fbBlue
        button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }
}
