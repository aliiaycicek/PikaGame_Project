//
//  ViewController.swift
//  Pika Game Project
//
//  Created by Ali Ayçiçek on 14.07.2023.
//

import UIKit
import ARKit


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
    
    // Pikachu İmage Views
    
    @IBOutlet weak var pikachu1: UIImageView!
    @IBOutlet weak var pikachu2: UIImageView!
    @IBOutlet weak var pikachu3: UIImageView!
    @IBOutlet weak var pikachu4: UIImageView!
    @IBOutlet weak var pikachu5: UIImageView!
    @IBOutlet weak var pikachu6: UIImageView!
    @IBOutlet weak var pikachu7: UIImageView!
    @IBOutlet weak var pikachu8: UIImageView!
    @IBOutlet weak var pikachu9: UIImageView!
    
    // darkSide Pikachues İmage Views
    
    @IBOutlet weak var Pikachu10: UIImageView!
    @IBOutlet weak var Pikachu11: UIImageView!
    @IBOutlet weak var Pikachu12: UIImageView!
    @IBOutlet weak var Pikachu13: UIImageView!
    @IBOutlet weak var Pikachu14: UIImageView!
    @IBOutlet weak var Pikachu15: UIImageView!
    @IBOutlet weak var Pikachu16: UIImageView!
    @IBOutlet weak var Pikachu17: UIImageView!
    @IBOutlet weak var Pikachu18: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Timer
        
        counter = 20
        timerLable.text = "Time: \(counter)"
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        
        hideTimer = Timer.scheduledTimer(timeInterval: 0.51, target: self, selector: #selector(hidePika), userInfo: nil, repeats: true)
        
        
        // Score
        
        scoreLable.text = "Score: \(score)"
        
        // HighScore Check
        
        let storedHighScore = UserDefaults.standard.object(forKey: "highscore")
        
        if storedHighScore == nil {
            
            highScore = 0
            highscoreLable.text = "Highscore \(highScore)"
            
        }
        
        
        if let newScore = storedHighScore as? Int {
            
            highScore = newScore
            highscoreLable.text = "Highscore \(highScore)"
        }
        // Images
        
        pikachu1.isUserInteractionEnabled = true
        pikachu2.isUserInteractionEnabled = true
        pikachu3.isUserInteractionEnabled = true
        pikachu4.isUserInteractionEnabled = true
        pikachu5.isUserInteractionEnabled = true
        pikachu6.isUserInteractionEnabled = true
        pikachu7.isUserInteractionEnabled = true
        pikachu8.isUserInteractionEnabled = true
        pikachu9.isUserInteractionEnabled = true
      
        // darkSide Pikachues
        Pikachu10.isUserInteractionEnabled = true
        Pikachu11.isUserInteractionEnabled = true
        Pikachu12.isUserInteractionEnabled = true
        Pikachu13.isUserInteractionEnabled = true
        Pikachu14.isUserInteractionEnabled = true
        Pikachu15.isUserInteractionEnabled = true
        Pikachu16.isUserInteractionEnabled = true
        Pikachu17.isUserInteractionEnabled = true
        Pikachu18.isUserInteractionEnabled = true
        
        // Pikachu
        let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(İncscore))
        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(İncscore))
        let recognizer3 = UITapGestureRecognizer(target: self, action: #selector(İncscore))
        let recognizer4 = UITapGestureRecognizer(target: self, action: #selector(İncscore))
        let recognizer5 = UITapGestureRecognizer(target: self, action: #selector(İncscore))
        let recognizer6 = UITapGestureRecognizer(target: self, action: #selector(İncscore))
        let recognizer7 = UITapGestureRecognizer(target: self, action: #selector(İncscore))
        let recognizer8 = UITapGestureRecognizer(target: self, action: #selector(İncscore))
        let recognizer9 = UITapGestureRecognizer(target: self, action: #selector(İncscore))
    
        // DarkSide GestureRecognizers (negative score bar)
        let recognizer10 = UITapGestureRecognizer(target: self, action: #selector(NegativeScore))
        let recognizer11 = UITapGestureRecognizer(target: self, action: #selector(NegativeScore))
        let recognizer12 = UITapGestureRecognizer(target: self, action: #selector(NegativeScore))
        let recognizer13 = UITapGestureRecognizer(target: self, action: #selector(NegativeScore))
        let recognizer14 = UITapGestureRecognizer(target: self, action: #selector(NegativeScore))
        let recognizer15 = UITapGestureRecognizer(target: self, action: #selector(NegativeScore))
        let recognizer16 = UITapGestureRecognizer(target: self, action: #selector(NegativeScore))
        let recognizer17 = UITapGestureRecognizer(target: self, action: #selector(NegativeScore))
        let recognizer18 = UITapGestureRecognizer(target: self, action: #selector(NegativeScore))
       
        
        // Pikachues
        pikachu1.addGestureRecognizer(recognizer1)
        pikachu2.addGestureRecognizer(recognizer2)
        pikachu3.addGestureRecognizer(recognizer3)
        pikachu4.addGestureRecognizer(recognizer4)
        pikachu5.addGestureRecognizer(recognizer5)
        pikachu6.addGestureRecognizer(recognizer6)
        pikachu7.addGestureRecognizer(recognizer7)
        pikachu8.addGestureRecognizer(recognizer8)
        pikachu9.addGestureRecognizer(recognizer9)
      
        
        // DarkSide Pikachues
        Pikachu10.addGestureRecognizer(recognizer10)
        Pikachu11.addGestureRecognizer(recognizer11)
        Pikachu12.addGestureRecognizer(recognizer12)
        Pikachu13.addGestureRecognizer(recognizer13)
        Pikachu14.addGestureRecognizer(recognizer14)
        Pikachu15.addGestureRecognizer(recognizer15)
        Pikachu16.addGestureRecognizer(recognizer16)
        Pikachu17.addGestureRecognizer(recognizer17)
        Pikachu18.addGestureRecognizer(recognizer18)
       
        
       
        
        pikachuArray = [pikachu1, pikachu2, pikachu3, pikachu4, pikachu5, pikachu6, pikachu7, pikachu8, pikachu9,Pikachu10, Pikachu11, Pikachu12, Pikachu13, Pikachu14, Pikachu15, Pikachu16, Pikachu17, Pikachu18]
        hidePika()
        
        
        // Style
        
        playerNameLable.text = playerNames
        
        
    }
    @objc func hidePika(){
       
        if maxHide <= 5
        {
            for pikachu in pikachuArray {
                pikachu.isHidden = true
                
            }
            
            let random = Int (arc4random_uniform(UInt32(pikachuArray.count - 1)))
            
            pikachuArray[random].isHidden = false
            
        }
    }
    
   @objc func İncscore()
    {
       
       score += 1
       scoreLable.text = "Score: \(score)"
        
    }
    @objc func NegativeScore()
    {
        score -= 1
        scoreLable.text = "Score: \(score)"
    }
    @objc func timerFunction(){
        timerLable.text = "Time Remaining: \(counter)"
        counter -= 1
        
        if self.score > self.highScore {
            
            self.highScore = self.score
            
            highscoreLable.text = "Highscore: \(self.highScore)"
            
            UserDefaults.standard.set(self.highScore, forKey: "highscore")
        }
        
        
        if counter == -1 {
            timer.invalidate()
            hideTimer.invalidate()
            let alert = UIAlertController(title: "Time is Up!", message: "Do u want to play again?" , preferredStyle: UIAlertController.Style.alert)
           
            let okButton = UIAlertAction(title: "Go to menu!", style: UIAlertAction.Style.default) {
                (UIAlertAction) in
                self.performSegue(withIdentifier: "backLoginScreen", sender: nil)
                
            }
            let replayButton = UIAlertAction(title: "Replay?", style: UIAlertAction.Style.default) {
                (UIAlertAction) in
                
                self.score = 0
                self.scoreLable.text = "Score: \(self.score)"
                self.counter = 20
                self.timerLable.text = String(self.counter)
                
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerFunction), userInfo: nil, repeats: true)
                
                self.hideTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.hidePika), userInfo: nil, repeats: true)
            }
            alert.addAction(okButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true, completion: nil)
        }
        
    }

}

