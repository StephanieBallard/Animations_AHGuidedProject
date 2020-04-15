//
//  ViewController.swift
//  Animations
//
//  Created by Kenny on 4/14/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Properties -
    var animationLabel = UILabel()

    // MARK: - View Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationLabel.center = view.center
    }
    
    private func createViews() {
        // create our animation label
        createLabel()
        // create Horizontal Stack
        let hStack = stackView(axis: .horizontal, distribution: .fillEqually)
        hStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        hStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        hStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        
        let rotateButton = createButton(title: "Rotate", action: #selector(rideAWave))
        hStack.addArrangedSubview(rotateButton)
        
        let vanishButton = createButton(title: "Vanish", action: #selector(vanish))
        hStack.addArrangedSubview(vanishButton)
    }

    /// Creates UILabel in the center of the view used for animating
    ///- paremeter text: This passes text into the label
    private func createLabel() {
        animationLabel = UILabel(frame: CGRect(x:0, y:0, width: 200, height: 200))
        animationLabel.translatesAutoresizingMaskIntoConstraints = false
        animationLabel.text = "🏄🏼‍♂️"
        animationLabel.textAlignment = .center
        animationLabel.font = UIFont.systemFont(ofSize: 96)
        view.addSubview(animationLabel)
    }
    
    private func stackView(axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution) -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = axis
        stack.distribution = distribution
        self.view.addSubview(stack)
        return stack
    }
    
    /**
        create a button with a title, and action
        - parameter title: the button's title
        - parameter action: a method that's exposed to objC in a selector
     */
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    // MARK: - Animations -
    
    private func gracefullyReturnToCenter() {
        let labelToCenter = {
            self.animationLabel.transform = .identity
            self.animationLabel.center = self.view.center
        }
        animationLabel.alpha = 1
        
        UIView.animate(withDuration: 1,
                       delay: 0.33,
                       options: .curveEaseOut,
                       animations: labelToCenter,
                       completion: nil)
    }
    
    @objc private func rideAWave() {
        UIView.animateKeyframes(withDuration: 4, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
                self.animationLabel.transform = CGAffineTransform(rotationAngle: .pi/4)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                self.animationLabel.center.x -= self.view.bounds.size.width/2
                self.animationLabel.center.x -= self.animationLabel.frame.size.width/2
                
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                self.animationLabel.transform = CGAffineTransform(rotationAngle: .pi/8)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.33, relativeDuration: 0.17) {
                self.animationLabel.transform = CGAffineTransform(rotationAngle: .pi/4)
            }
            
        }) { _ in
        
            self.gracefullyReturnToCenter()
        }
    }
    
    @objc private func vanish() {
        vanishWithKeyFrames()
//        UIView.animate(withDuration: 1, animations: {
//            self.animationLabel.alpha = 0
//        }) { _ in
//            UIView.animate(withDuration: 1, animations: {
//                self.animationLabel.alpha = 1
//            }) { _ in
//                self.gracefullyReturnToCenter()
//            }
//        }
    }
    
    private func vanishWithKeyFrames() {
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.animationLabel.alpha = 0
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.animationLabel.alpha = 1
            }
        }) { _ in
            self.gracefullyReturnToCenter()
        }
    }
}

