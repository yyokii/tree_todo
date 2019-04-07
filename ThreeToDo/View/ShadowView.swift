//
//  ShadowView.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/02/10.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit
import MaterialComponents

class ShadowView: UIView {
    
    override class var layerClass: AnyClass {
        return MDCShadowLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    var shadowLayer: MDCShadowLayer {
        return self.layer as! MDCShadowLayer
    }

    func setElevation() {
        self.shadowLayer.elevation = .cardPickedUp
    }
}

