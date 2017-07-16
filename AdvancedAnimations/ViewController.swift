//
//  ViewController.swift
//  AdvancedAnimations
//
//  Created by Erich Grunewald on 16.07.17.
//  Copyright © 2017 Erich Grunewald. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up stack view that will contain some animatable views.
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.spacing = 10
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view).inset(UIEdgeInsets(top: 40, left: 10, bottom: 10, right: 10))
        }

        // ## 1
        // ## Very basic UIViewPropertyAnimator animation.

        let animatableView1 = AnimatableView()

        // On a button press, animate the view to the right.
        animatableView1.square.reactive.controlEvents(.touchUpInside).observeValues { _ in
            let animator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
                animatableView1.square.frame = animatableView1.square.frame.offsetBy(dx: animatableView1.animationDistanceX, dy: 0)
            }
            animator.startAnimation()
        }

        stackView.addArrangedSubview(animatableView1)

        // ## 2
        // ## Interactive animation.

        let animatableView2 = AnimatableView()
        var animator2: UIViewPropertyAnimator!

        animatableView2.panGestureRecognizer.reactive.stateChanged.observeValues { recognizer in
            switch recognizer.state {
            case .began:
                // When a pan starts, create the property animator and pause it.
                animator2 = UIViewPropertyAnimator(duration: 1, curve: .easeOut) {
                    animatableView2.square.frame = animatableView2.square.frame.offsetBy(dx: animatableView2.animationDistanceX, dy: 0)
                }
                animator2.pauseAnimation()

            case .changed:
                // When panning, update the animation progress.
                let translation = recognizer.translation(in: animatableView2.square)
                animator2.fractionComplete = translation.x / animatableView2.animationDistanceX // Linear.

            case .ended:
                // When a pan ends, finish the animation by animating to the end point.
                animator2.continueAnimation(withTimingParameters: nil, durationFactor: 0)

            case .cancelled, .failed, .possible:
                break
            }
        }

        stackView.addArrangedSubview(animatableView2)

        // ## 3
        // ## Interruptable animation.

        let animatableView3 = AnimatableView()
        var progressWhenInterrupted: CGFloat = 0
        let animator3: UIViewPropertyAnimator = {
            return  UIViewPropertyAnimator(duration: 2, curve: .easeOut) {
                animatableView3.square.frame = animatableView3.square.frame.offsetBy(dx: animatableView3.animationDistanceX, dy: 0)
            }
        }()

        // On a button press, start the animation.
        animatableView3.square.reactive.controlEvents(.touchUpInside).observeValues { _ in
            animator3.startAnimation()
        }

        animatableView3.panGestureRecognizer.reactive.stateChanged.observeValues { recognizer in

            switch recognizer.state {
            case .began:
                // When a pan starts, pause (interrupt) the ongoing animation & remember its
                // progress.
                animator3.pauseAnimation()
                progressWhenInterrupted = animator3.fractionComplete

            case .changed:
                // When panning, update the animation progress. Because we started scrubbing from an
                // arbitrary point on the x-axis, we need to add that starting point to the value.
                let translation = recognizer.translation(in: animatableView2.square)
                animator3.fractionComplete = translation.x / animatableView2.animationDistanceX + progressWhenInterrupted

            case .ended:
                // When a pan ends, continue the animation again.
                let timing = UICubicTimingParameters(animationCurve: .easeOut)
                animator3.continueAnimation(withTimingParameters: timing, durationFactor: 0)

            case .cancelled, .failed, .possible:
                break
            }
        }

        stackView.addArrangedSubview(animatableView3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

