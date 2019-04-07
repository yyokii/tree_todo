//
//  PopTipView.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/03/21.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import AMPopTip

class PopTipView {
    static func standardPoptip(offset: CGFloat) -> PopTip {
        let popTip = PopTip()
        popTip.font = UIFont(name: "Avenir-Medium", size: 15)!
        popTip.bubbleColor = UIColor(hex: "607D8B")
        popTip.textColor = UIColor.white
        popTip.shouldDismissOnTap = true
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        popTip.edgeMargin = 50
        popTip.offset = offset
        popTip.edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return popTip
    }
}
