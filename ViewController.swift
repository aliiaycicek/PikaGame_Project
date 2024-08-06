//
//  ViewController.swift
//  Pika Game Project
//
//  Created by Ali Ayçiçek on 14.07.2023.
//

import UIKit

class ViewController: UIViewController {
    var timer = Timer()
    var counter = 0
    var score = 0
    var pikachuArray = [UIImageView]()
    var hideTimer = Timer()
    var highScore = 0
    var maxHide = 0

    @IBOutlet weak var timerLable: UILabel!
    @IBOutlet weak var scoreLable: UILabel!
    @IBOutlet weak var highscoreLable: UILabel!
    @IBOutlet weak var playerNameLable: UILabel!
    
    var playerNames = " "
    
    // Pikachu Image Views
    @IBOutlet weak var pikachu1: UIImageView!
    @IBOutlet weak var pikachu2: UIImageView!
    @IBOutlet weak var pikachu3: UIImageView!
    @IBOutlet weak var pikachu4: UIImageView!
    @IBOutlet weak var pikachu5: UIImageView!
    @IBOutlet weak var pikachu6: UIImageView!
    @IBOutlet weak var pikachu7: UIImageView!
    @IBOutlet weak var pikachu8: UIImageView!
    @IBOutlet weak var pikachu9: UIImageView!
    
    // DarkSide Pikachues Image Views
    @IBOutlet weak var Pikachu10: UIImageView!
    @IBOutlet weak var Pikachu11: UIImageView!
    @IBOutlet weak var Pikachu12: UIImageView!
    @IBOutlet weak var Pikachu13: UIImageView!
    @IBOutlet weak var Pikachu14: UIImageView!
    @IBOutlet weak var Pikachu15: UIImageView!
    @IBOutlet weak var Pikachu16: UIImageView!
    @IBOutlet weak var Pikachu17: UIImageView!
    @IBOutlet weak var Pikachu18: UIImageView!
    
    var clickCounts = [UIImageView: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Timer
        counter = 20
        timerLable.text = "Time: \(counter)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        hideTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(hidePika), userInfo: nil, repeats: true)
        
        // Score
        scoreLable.text = "Score: \(score)"
        
        // HighScore Check
        let storedHighScore = UserDefaults.standard.object(forKey: "highscore")
        if let newScore = storedHighScore as? Int {
            highScore = newScore
            highscoreLable.text = "Highscore: \(highScore)"
        } else {
            highScore = 0
            highscoreLable.text = "Highscore \(highScore)"
        }
        
        // Initialize Click Counts
        let allPikachus = [pikachu1, pikachu2, pikachu3, pikachu4, pikachu5, pikachu6, pikachu7, pikachu8, pikachu9, Pikachu10, Pikachu11, Pikachu12, Pikachu13, Pikachu14, Pikachu15, Pikachu16, Pikachu17, Pikachu18]
        for pikachu in allPikachus {
            if let pikachu = pikachu {
                pikachu.isUserInteractionEnabled = true
                clickCounts[pikachu] = 0
                let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                pikachu.addGestureRecognizer(recognizer)
            }
        }
        
        pikachuArray = allPikachus as! [UIImageView]
        hidePika()
        
        // Style
        playerNameLable.text = playerNames
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let tappedPikachu = sender.view as? UIImageView else { return }
        let isDarkSide = (tappedPikachu == Pikachu10 || tappedPikachu == Pikachu11 || tappedPikachu == Pikachu12 ||
                           tappedPikachu == Pikachu13 || tappedPikachu == Pikachu14 || tappedPikachu == Pikachu15 ||
                           tappedPikachu == Pikachu16 || tappedPikachu == Pikachu17 || tappedPikachu == Pikachu18)
        
        if let count = clickCounts[tappedPikachu], count < 2 {
            clickCounts[tappedPikachu] = count + 1
            if isDarkSide {
                score -= 1
            } else {
                score += 1
            }
            scoreLable.text = "Score: \(score)"
        } else if let count = clickCounts[tappedPikachu], count >= 2 {
            // Optionally show a visual indication or feedback
            print("Pikachu already clicked twice!")
        }
    }

    @objc func hidePika() {
        if maxHide <= 5 {
            for pikachu in pikachuArray {
                pikachu.isHidden = true
            }
            let random = Int(arc4random_uniform(UInt32(pikachuArray.count)))
            pikachuArray[random].isHidden = false
        }
    }

    @objc func timerFunction() {
        timerLable.text = "Time Remaining: \(counter)"
        counter -= 1

        if score > highScore {
            highScore = score
            highscoreLable.text = "Highscore: \(highScore)"
            UserDefaults.standard.set(highScore, forKey: "highscore")
        }

        if counter == -1 {
            timer.invalidate()
            hideTimer.invalidate()
            let alert = UIAlertController(title: "Time is Up!", message: "Do you want to play again?", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Go to menu!", style: .default) { _ in
                self.performSegue(withIdentifier: "backLoginScreen", sender: nil)
            }
            let replayButton = UIAlertAction(title: "Replay?", style: .default) { _ in
                self.score = 0
                self.scoreLable.text = "Score: \(self.score)"
                self.counter = 20
                self.timerLable.text = String(self.counter)
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerFunction), userInfo: nil, repeats: true)
                self.hideTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.hidePika), userInfo: nil, repeats: true)
                // Reset click counts
                for pikachu in self.clickCounts.keys {
                    self.clickCounts[pikachu] = 0
                }
            }
            alert.addAction(okButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
