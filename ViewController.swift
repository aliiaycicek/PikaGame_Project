import UIKit

// MARK: - Protocol
protocol SkinsSelectionDelegate: AnyObject {
    func didSelectSkins(normalSkin: UIImage?, darkSideSkin: UIImage?)
}

// MARK: - ViewController
class ViewController: UIViewController, SkinsSelectionDelegate {
    var timer = Timer()
    var counter = 0
    var score = 0
    var pikachuArray = [UIImageView]()
    var hideTimer = Timer()
    var highScore = 0
    var maxHide = 0
    var selectedDifficulty = "Easy"
    
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
    
    // DarkSide Pikachus Image Views
    @IBOutlet weak var pikachu10: UIImageView!
    @IBOutlet weak var pikachu11: UIImageView!
    @IBOutlet weak var pikachu12: UIImageView!
    @IBOutlet weak var pikachu13: UIImageView!
    @IBOutlet weak var pikachu14: UIImageView!
    @IBOutlet weak var pikachu15: UIImageView!
    @IBOutlet weak var pikachu16: UIImageView!
    @IBOutlet weak var pikachu17: UIImageView!
    @IBOutlet weak var pikachu18: UIImageView!
    
    var clickCounts = [UIImageView: Int]()
    
    // Skin variables
    var normalSkin: UIImage?
    var darkSideSkin: UIImage?
    
    let normalSkinImages = ["Pikachu 2", "Bulbasaur", "Rattata", "Squirtle", "Jigglypuff", "Charmander"]
    let darkSideSkinImages = ["darkSide Pikachu 1", "DarkSide Bulbasaur", "DarkSide Rattata", "DarkSide Squirtle", "DarkSide Jigglypuff", "DarkSide Charmander"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Kayıtlı skinleri yükle
        loadSavedSkins()
        setupGame()
    }

    func loadSavedSkins() {
        if let normalSkinName = UserDefaults.standard.string(forKey: "selectedNormalSkin"),
           let darkSkinName = UserDefaults.standard.string(forKey: "selectedDarkSideSkin") {
            normalSkin = UIImage(named: normalSkinName)
            darkSideSkin = UIImage(named: darkSkinName)
        } else {
            // Varsayılan skinler
            normalSkin = UIImage(named: normalSkinImages[0])
            darkSideSkin = UIImage(named: darkSideSkinImages[0])
        }
        applySkinsToPikachus()
    }

    func setupGame() {
        counter = selectedDifficulty == "Easy" ? 20 : 10
        timerLable.text = "Time: \(counter)"
        let interval = selectedDifficulty == "Easy" ? 1.5 : 0.5
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        hideTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(hidePika), userInfo: nil, repeats: true)
        
        scoreLable.text = "Score: \(score)"
        
        // HighScore Check
        let storedHighScore = UserDefaults.standard.object(forKey: "highscore")
        if let newScore = storedHighScore as? Int {
            highScore = newScore
            highscoreLable.text = "Highscore: \(highScore)"
        } else {
            highScore = 0
            highscoreLable.text = "Highscore: \(highScore)"
        }
        
        // Initialize Click Counts and Gesture Recognizers
        let allPikachus = [pikachu1, pikachu2, pikachu3, pikachu4, pikachu5, pikachu6, pikachu7, pikachu8, pikachu9,
                          pikachu10, pikachu11, pikachu12, pikachu13, pikachu14, pikachu15, pikachu16, pikachu17, pikachu18]
        
        for pikachu in allPikachus {
            if let pikachu = pikachu {
                pikachu.isUserInteractionEnabled = true
                clickCounts[pikachu] = 0
                let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                pikachu.addGestureRecognizer(recognizer)
            }
        }
        
        pikachuArray = allPikachus.compactMap { $0 }
        hidePika()
        
        playerNameLable.text = playerNames
        applySkinsToPikachus()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let tappedPikachu = sender.view as? UIImageView else { return }
        
        if tappedPikachu.isHidden { return }
        
        let isDarkSide = (tappedPikachu == pikachu10 || tappedPikachu == pikachu11 || tappedPikachu == pikachu12 ||
                         tappedPikachu == pikachu13 || tappedPikachu == pikachu14 || tappedPikachu == pikachu15 ||
                         tappedPikachu == pikachu16 || tappedPikachu == pikachu17 || tappedPikachu == pikachu18)
    
        if let count = clickCounts[tappedPikachu], count < 2 {
            clickCounts[tappedPikachu] = count + 1
            score += isDarkSide ? -1 : 1
            scoreLable.text = "Score: \(score)"
        }
    }
    
    @objc func hidePika() {
        if maxHide <= 5 {
            for pikachu in pikachuArray {
                pikachu.isHidden = true
            }
            
            let random = Int(arc4random_uniform(UInt32(pikachuArray.count)))
            pikachuArray[random].isHidden = false
            clickCounts[pikachuArray[random]] = 0
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
                self.showDifficultySelectionAlert()
            }
            alert.addAction(okButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showDifficultySelectionAlert() {
        let alert = UIAlertController(title: "Select Difficulty", message: nil, preferredStyle: .alert)
        
        let easyAction = UIAlertAction(title: "Easy", style: .default) { _ in
            self.selectedDifficulty = "Easy"
            self.resetGame()
        }
        
        let hardAction = UIAlertAction(title: "Hard", style: .default) { _ in
            self.selectedDifficulty = "Hard"
            self.resetGame()
        }
        
        alert.addAction(easyAction)
        alert.addAction(hardAction)
        present(alert, animated: true)
    }
    
    func resetGame() {
        score = 0
        scoreLable.text = "Score: \(score)"
        counter = selectedDifficulty == "Easy" ? 20 : 10
        timerLable.text = "Time: \(counter)"
        
        let interval = selectedDifficulty == "Easy" ? 1.5 : 0.5
        timer.invalidate()
        hideTimer.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        hideTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(hidePika), userInfo: nil, repeats: true)
        
        clickCounts.keys.forEach { clickCounts[$0] = 0 }
        hidePika()
    }
    
    func didSelectSkins(normalSkin: UIImage?, darkSideSkin: UIImage?) {
        self.normalSkin = normalSkin
        self.darkSideSkin = darkSideSkin
        
        applySkinsToPikachus()
    }
    
    func applySkinsToPikachus() {
        let normalPikachus = [pikachu1, pikachu2, pikachu3, pikachu4, pikachu5, pikachu6, pikachu7, pikachu8, pikachu9]
        let darkSidePikachus = [pikachu10, pikachu11, pikachu12, pikachu13, pikachu14, pikachu15, pikachu16, pikachu17, pikachu18]
        
        for pikachu in normalPikachus {
            pikachu?.image = normalSkin
        }
        
        for darkPikachu in darkSidePikachus {
            darkPikachu?.image = darkSideSkin
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let skinsVC = segue.destination as? SkinsVC {
            skinsVC.delegate = self
            if let normalSkin = normalSkin,
               let normalName = normalSkinImages.first(where: { UIImage(named: $0) == normalSkin }) {
                skinsVC.selectedIndex = normalSkinImages.firstIndex(of: normalName)
            }
        }
    }
}
