//
//  LoaderButton.swift
//  Meteor
//
//  Created by Gautier Billard on 29/07/2021.
//

import UIKit

class LoaderButton: UIButton {
    
    lazy var loadBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 3
        return view
    }()
    var loadBarWidthConstraint: NSLayoutConstraint?
    var loadBarTraillingConstraint: NSLayoutConstraint?
    
    private var messagesTimer: Timer?
    private var originTitle: String?
    
    var messages: [String] = [
        "Nous téléchargeons les données…",
        "C’est presque fini…",
        "Plus que quelques secondes avant d’avoir le résultat…"
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.primaryOutlined()
        addLoadBar()
    }
    
    ///Start a loading animation with a bar progressively filling the button
    /// - parameter duration: The time for the bar to progress from current state to completion
    func startLoading(duration: TimeInterval) {
        animateTitle(on: false)
        
        self.isEnabled = false
        
        originTitle = self.title(for: .normal)
        self.setTitle(messages[0], for: .normal)
        
        self.layoutSubviews()
        loadBarWidthConstraint?.isActive = false
        UIView.animate(withDuration: duration, delay: 0, options: .curveLinear) {
            self.loadBarTraillingConstraint?.isActive = true
            
            self.layoutIfNeeded()
        } completion: { _ in
            self.isEnabled = true
            self.messagesTimer?.invalidate()
            self.animateTitle(on: true)
            self.animateBarAway()
        }
        
        var count = 1
        messagesTimer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true) { timer in
            count += 1
            self.setTitle(self.messages[count%3], for: .normal)
        }
        
    }
    
    private func animateTitle(on: Bool) {
        on ? self.setTitle(originTitle, for: .normal) : ()
        UIView.transition(with: self, duration: 0.4, options: .transitionCrossDissolve) {
            self.setTitleColor(on ? .white : .black, for: .normal)
        } completion: { _ in
            //
        }
    }
    private func animateBarAway() {
        UIView.animate(withDuration: 0.4) {
            self.loadBar.alpha = 0
        } completion: { _ in
            self.loadBar.alpha = 1
            self.loadBarTraillingConstraint?.isActive = false
            self.loadBarWidthConstraint?.isActive = true
            
        }
    }
    
    private func addLoadBar() {
        let childView: UIView = loadBar
        let mView: UIView = self
        
        self.insertSubview(childView, at: 0)
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        childView.leadingAnchor.constraint(equalTo: mView.leadingAnchor, constant: 5).isActive = true
        childView.topAnchor.constraint(equalTo: mView.topAnchor, constant: 5).isActive = true
        childView.heightAnchor.constraint(equalToConstant: self.frame.height - 10).isActive = true
        loadBarWidthConstraint = childView.widthAnchor.constraint(equalToConstant: 0)
        loadBarWidthConstraint?.isActive = true
        loadBarTraillingConstraint = childView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        loadBarTraillingConstraint?.isActive = false
        
    }
    
}
