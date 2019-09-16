//
//  IndentedLabel.swift
//  Football Clubs
//
//  Created by Аслан on 17/09/2019.
//  Copyright © 2019 Doka.fun. All rights reserved.
//

import UIKit

class IndentedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let customRect = rect.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        super.drawText(in: customRect)
    }
}
