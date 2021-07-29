//
//  ViewController.swift
//  Meteor
//
//  Created by Gautier Billard on 29/07/2021.
//

import UIKit

class RootController: UIViewController {

    @IBOutlet weak var startButton: UIButton! {
        didSet {
            startButton.primaryOutlined()
        }
    }
    
    var timer: Timer?
    var colors: [UIColor?] = [UIColor(named: "weather2"),
                             UIColor(named: "weather3"),
                             UIColor(named: "weather4"),
                             UIColor(named: "weather1")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateBackground()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }

    func animateBackground() {
        var count = 0
        func animate() {
            UIView.animate(withDuration: 5, delay: 0, options: [.transitionCrossDissolve, .allowUserInteraction]) {
                self.view.backgroundColor = self.colors[count%4]
            }
            count += 1
        }
        animate()
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
            animate()
        }
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        let vc = CitiesListController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
