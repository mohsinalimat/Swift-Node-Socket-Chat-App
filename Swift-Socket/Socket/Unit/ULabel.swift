//
//  ULabel.swift
//  Socket
//
//  Created by Matt on 2019/11/11.
//  Copyright © 2019 Matt. All rights reserved.
//

import UIKit

class ULabel : UILabel {
    override var text: String? {
        didSet{
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.alpha = 0
            }) { _ in
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                    self.alpha = 1
                }, completion: nil)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
