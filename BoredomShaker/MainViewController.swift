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
    
    var shakeCount = 1
    let dateFormatter = DateFormatter()
    
    var suggestions = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        
        self.checkIfUserCanShakeToday()
    }

    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            switch shakeCount {
            case 1, 2, 3:
                generateSuggestions()
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
            shakeCount += 1
        }
    }
    
    private func getSavedIdeaForLabel(forKey key: String) -> String {
        if let idea = UserDefaults.standard.value(forKey: key) {
            return idea as! String
        }
        return ""
    }
    
    private func setupShakeUI() {
        shakeCount = 1
        outOfIdeasStackView.alpha = 0
        ideaOneLabel.alpha = 0
        ideaTwoLabel.alpha = 0
        ideaThreeLabel.alpha = 0
        checkIfAlteredListNeedsToBeReset()
    }
    
    private func setupNoShakesUI() {
        shakeLabel.text = ""
        outOfIdeasStackView.alpha = 1
        showIdeaLabel(ideaOneLabel, withText: getSavedIdeaForLabel(forKey: "IdeaOne"))
        showIdeaLabel(ideaTwoLabel, withText: getSavedIdeaForLabel(forKey: "IdeaTwo"))
        showIdeaLabel(ideaThreeLabel, withText: getSavedIdeaForLabel(forKey: "IdeaThree"))
    }
    
    private func showIdeaLabel(_ ideaLabel: UILabel, withText: String) {
        ideaLabel.alpha = 1
        ideaLabel.text = withText
        switch shakeCount {
        case 1:
            UserDefaults.standard.set(ideaLabel.text, forKey: "IdeaOne")
        case 2:
            UserDefaults.standard.set(ideaLabel.text, forKey: "IdeaTwo")
        case 3:
            UserDefaults.standard.set(ideaLabel.text, forKey: "IdeaThree")
        default:
            return
        }
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
//              Force SetupShakeUI() For Testing
//                setupShakeUI()
            }
        }
    }
    
    private func generateSuggestions() {
        let randomIdeaIndex = Int(arc4random_uniform(UInt32(suggestions.count)))
        switch shakeCount {
        case 1:
            let ideaOne = suggestions[randomIdeaIndex]
            showIdeaLabel(ideaOneLabel, withText: ideaOne)
            
        case 2:
            let ideaTwo = suggestions[randomIdeaIndex]
            showIdeaLabel(ideaTwoLabel, withText: ideaTwo)
        case 3:
            let ideaThree = suggestions[randomIdeaIndex]
            showIdeaLabel(ideaThreeLabel, withText: ideaThree)
        default:
            return
        }
        removeItemAndSaveAlteredListOfSuggestions(at: randomIdeaIndex)
        checkIfAlteredListNeedsToBeReset()
    }
    
    private func removeItemAndSaveAlteredListOfSuggestions(at index: Int) {
        suggestions.remove(at: index)
        UserDefaults.standard.set(suggestions, forKey: "AlteredIdeas")
        UserDefaults.standard.synchronize()
    }
    
    private func checkIfAlteredListNeedsToBeReset() {
        if let alteredSuggestions = UserDefaults.standard.value(forKey: "AlteredIdeas") {
            if let leftoverList = alteredSuggestions as? [String] {
                if leftoverList.count > 0 {
                    suggestions = leftoverList
                } else {
                    let pList = Bundle.main.path(forResource: "Suggestions", ofType: "plist")
                    guard let content = NSDictionary(contentsOfFile: pList!) as? [String:[String]] else {
                        fatalError()
                    }
                    guard let ideas = content["Ideas"] else { fatalError() }
                    suggestions = ideas
                }
            }
        } else {
            print("No altered ideas yet")
        }
    }
}
