//
//  AnimatableView.swift
//  AdvancedAnimations
//
//  Created by Erich Grunewald on 16.07.17.
//  Copyright © 2017 Erich Grunewald. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import SnapKit

class AnimatableView: UIView {
    let square = UIButton()

    let panGestureRecognizer = UIPanGestureRecognizer()

    var animationDistanceX: CGFloat {
        return self.frame.width - square.frame.width
    }

    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor(white: 0, alpha: 0.1)
        square.backgroundColor = UIColor.orange
        square.addGestureRecognizer(self.panGestureRecognizer)

        self.addSubview(square)
        square.snp.makeConstraints { make in
            make.size.equalTo(self.snp.height).multipliedBy(0.8)
            make.left.centerY.equalTo(self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 80)
    }
}
