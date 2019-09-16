//
//  UIViewController+Helpers.swift
//  Football Clubs
//
//  Created by Аслан on 16/09/2019.
//  Copyright © 2019 Doka.fun. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setUpPlusButtonInNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "plus"), style: .plain, target: self, action: selector)
    }
    
    func setUpLeftBarButtonItem(title: String, selector: Selector) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: selector)
    }
    
    func setUpCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelModal))
    }
    
    @objc private func handleCancelModal() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupLightBlueBackgroundView(height: CGFloat) -> UIView {
        
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = .lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lightBlueBackgroundView)
        lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        return lightBlueBackgroundView
    }
}
