//
//  MainViewController.swift
//  BoredomShaker
//
//  Created by Rebekah Baker on 7/18/18.
//  Copyright © 2018 Bekah Baker. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var outOfIdeasStackView: UIStackView!
    @IBOutlet weak var shakeLabel: UILabel!
    @IBOutlet weak var ideaOneLabel: UILabel!
    @IBOutlet weak var ideaTwoLabel: UILabel!
    @IBOutlet weak var ideaThreeLabel: UILabel!
    
    var shakeCount = 0
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder() // To get shake gesture
        self.checkIfUserCanShakeToday()
    }
    
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            shakeCount += 1
            switch shakeCount {
            case 1:
                showIdeaLabel(ideaOneLabel, withText: "First Idea")
            case 2:
                showIdeaLabel(ideaTwoLabel, withText: "Second Idea")
            case 3:
                showIdeaLabel(ideaThreeLabel, withText: "Third Idea")
            case 4:
                shakeLabel.text = ""
                outOfIdeasStackView.alpha = 1
                self.dateFormatter.dateFormat = "MM-dd-yyyy"
                let dateString = dateFormatter.string(from: Date())
                print(dateString)
                UserDefaults.standard.set(dateString, forKey: "LastTimeUserShookThreeTimes")
                UserDefaults.standard.synchronize()
            default: return
            }
        }
    }
    
    private func setupShakeUI() {
        outOfIdeasStackView.alpha = 0
        ideaOneLabel.alpha = 0
        ideaTwoLabel.alpha = 0
        ideaThreeLabel.alpha = 0
    }
    
    private func setupNoShakesUI() {
        shakeLabel.text = ""
        outOfIdeasStackView.alpha = 1
        showIdeaLabel(ideaOneLabel, withText: "First Idea")
        showIdeaLabel(ideaTwoLabel, withText: "Second Idea")
        showIdeaLabel(ideaThreeLabel, withText: "Third Idea")
    }
    
    private func showIdeaLabel(_ ideaLabel: UILabel, withText: String) {
        ideaLabel.alpha = 1
        ideaLabel.text = withText
    }
    
    private func checkIfUserCanShakeToday() {
        
        if let lastTimeUserShookThreeTimes = UserDefaults.standard.value(forKey: "LastTimeUserShookThreeTimes") {
            
            self.dateFormatter.dateFormat = "MM-dd-yyyy"
            let todaysDate = dateFormatter.string(from: Date())

            print("Date ", lastTimeUserShookThreeTimes)
            print("CURRENT DATE ", todaysDate)
            
            if todaysDate != lastTimeUserShookThreeTimes as? String {
                print("User can shake today")
                setupShakeUI()
            } else {
                print("User cannot shake today")
                setupNoShakesUI()
            }
        }
    }

}
