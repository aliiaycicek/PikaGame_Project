import UIKit
import AVFoundation

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
    var audioPlayer: AVAudioPlayer?
    
    // MARK: - IBOutlets
    @IBOutlet private weak var timerLable: UILabel! {
        didSet {
            timerLable.text = "Time: 0"
        }
    }
    
    @IBOutlet private weak var scoreLable: UILabel! {
        didSet {
            scoreLable.text = "Score: 0"
        }
    }
    
    @IBOutlet private weak var highscoreLable: UILabel! {
        didSet {
            highscoreLable.text = "High Score: 0"
        }
    }
    
    @IBOutlet private weak var playerNameLable: UILabel! {
        didSet {
            playerNameLable.text = "Player: Guest"
        }
    }
    
    // MARK: - Pikachu Image Views
    @IBOutlet private weak var pikachu1: UIImageView!
    @IBOutlet private weak var pikachu2: UIImageView!
    @IBOutlet private weak var pikachu3: UIImageView!
    @IBOutlet private weak var pikachu4: UIImageView!
    @IBOutlet private weak var pikachu5: UIImageView!
    @IBOutlet private weak var pikachu6: UIImageView!
    @IBOutlet private weak var pikachu7: UIImageView!
    @IBOutlet private weak var pikachu8: UIImageView!
    @IBOutlet private weak var pikachu9: UIImageView!
    @IBOutlet private weak var pikachu10: UIImageView!
    @IBOutlet private weak var pikachu11: UIImageView!
    @IBOutlet private weak var pikachu12: UIImageView!
    @IBOutlet private weak var pikachu13: UIImageView!
    @IBOutlet private weak var pikachu14: UIImageView!
    @IBOutlet private weak var pikachu15: UIImageView!
    @IBOutlet private weak var pikachu16: UIImageView!
    @IBOutlet private weak var pikachu17: UIImageView!
    @IBOutlet private weak var pikachu18: UIImageView!
    
    var playerNames = " "
    
    var clickCounts = [UIImageView: Int]()
    
    // Skin variables
    var normalSkin: UIImage?
    var darkSideSkin: UIImage?
    
    let normalSkinImages = ["Pikachu 2", "Bulbasaur", "Rattata", "Squirtle", "Jigglypuff", "Charmander"]
    let darkSideSkinImages = ["darkSide Pikachu 1", "DarkSide Bulbasaur", "DarkSide Rattata", "DarkSide Squirtle", "DarkSide Jigglypuff", "DarkSide Charmander"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        loadSavedSkins()
        setupGame()
    }

    private func setupDesign() {
        guard let timerLable = timerLable,
              let scoreLable = scoreLable,
              let highscoreLable = highscoreLable,
              let playerNameLable = playerNameLable else {
            print("Error: One or more labels are not connected in Interface Builder")
            return
        }
        
        // Arka plan
        AppTheme.applyGradientBackground(to: view)
        
        // Label'ların temel özelliklerini ayarla
        [timerLable, scoreLable, highscoreLable, playerNameLable].forEach { label in
            label.textColor = AppTheme.textColor
            if let customFont = UIFont(name: "Electric", size: 18) {
                label.font = customFont
            }
        }
        
        // Pikachu'ları ayarla
        let allPikachus = [pikachu1, pikachu2, pikachu3, pikachu4, pikachu5, pikachu6,
                          pikachu7, pikachu8, pikachu9, pikachu10, pikachu11, pikachu12,
                          pikachu13, pikachu14, pikachu15, pikachu16, pikachu17, pikachu18]
        
        pikachuArray = allPikachus.compactMap { $0 }
        
        // Pikachu'ların temel özelliklerini ayarla
        pikachuArray.forEach { imageView in
            imageView.isUserInteractionEnabled = true
            imageView.alpha = 0
        }
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
            
            // Play catch sound effect
            playSound(isDarkSide ? "dark_catch" : "catch_sound")
            
            // Yeni skor yüksek skordan büyükse kaydet
            if score > highScore {
                highScore = score
                highscoreLable?.text = "High Score: \(highScore)"
                UserDefaults.standard.set(highScore, forKey: "highscore")
                
                // Veritabanına kaydet
                if let playerName = playerNameLable?.text?.replacingOccurrences(of: "Player: ", with: "") {
                    DatabaseManager.shared.saveHighScore(playerName: playerName, score: highScore, difficulty: selectedDifficulty)
                }
            }
        }
    }
    
    private func playSound(_ soundName: String) {
        // Only play if sound effects are enabled
        if UserDefaults.standard.bool(forKey: "soundEffectsEnabled") {
            if let soundURL = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    audioPlayer?.play()
                } catch {
                    print("Error: Couldn't play sound file.")
                }
            }
        }
    }
    
    @objc func hidePika() {
        if maxHide <= 5 {
            // Önce tüm Pikachu'ları gizle
            for pikachu in pikachuArray {
                pikachu.isHidden = true
                pikachu.alpha = 0
            }
            
            // Rastgele bir Pikachu seç ve göster
            let random = Int(arc4random_uniform(UInt32(pikachuArray.count)))
            let selectedPikachu = pikachuArray[random]
            
            // Seçilen Pikachu'yu göster ve animasyonla belirt
            selectedPikachu.isHidden = false
            selectedPikachu.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            UIView.animate(withDuration: 0.3) {
                selectedPikachu.alpha = 1
                selectedPikachu.transform = .identity
            }
            
            clickCounts[selectedPikachu] = 0
        }
    }
    
    @objc func timerFunction() {
        guard let timerLable = timerLable,
              let highscoreLable = highscoreLable else { return }
        
        timerLable.text = "Time: \(counter)"
        counter -= 1
        
        // Score animasyonu
        if score > highScore {
            highScore = score
            highscoreLable.text = "High Score: \(highScore)"
            UserDefaults.standard.set(highScore, forKey: "highscore")
            
            // Yeni yüksek skor animasyonu
            UIView.animate(withDuration: 0.2) {
                self.highscoreLable.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            } completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.highscoreLable.transform = .identity
                }
            }
        }
        
        // Oyun bittiğinde sadece bir kez çalışacak
        if counter == 0 {
            // Zamanlayıcıları durdur
            timer.invalidate()
            hideTimer.invalidate()
            
            // Skoru kaydet
            if let playerName = playerNameLable?.text?.replacingOccurrences(of: "Player: ", with: "") {
                print("Skor kaydediliyor: \(playerName), \(score), \(selectedDifficulty)")
                DatabaseManager.shared.saveHighScore(playerName: playerName, score: score, difficulty: selectedDifficulty)
            }
            
            // Süre doldu uyarısı
            let alert = UIAlertController(title: "Süre Doldu!", message: "Skorun: \(score). Ne yapmak istersin?", preferredStyle: .alert)
            
            // Alert tasarımı
            alert.view.tintColor = AppTheme.primaryColor
            alert.view.layer.cornerRadius = 15
            
            if let title = alert.title {
                let customFont = UIFont(name: "Electric", size: 24) ?? UIFont.systemFont(ofSize: 24)
                let attributedString = NSAttributedString(string: title, attributes: [
                    .font: customFont,
                    .foregroundColor: AppTheme.primaryColor
                ])
                alert.setValue(attributedString, forKey: "attributedTitle")
            }
            
            // Alert mesajının fontunu da güncelle
            if let message = alert.message {
                let customFont = UIFont(name: "Electric", size: 16) ?? UIFont.systemFont(ofSize: 16)
                let attributedMessage = NSAttributedString(string: message, attributes: [
                    .font: customFont,
                    .foregroundColor: AppTheme.textColor
                ])
                alert.setValue(attributedMessage, forKey: "attributedMessage")
            }
            
            let scoreButton = UIAlertAction(title: "Skorları Gör", style: .default) { _ in
                self.performSegue(withIdentifier: "toRankingVC", sender: nil)
            }
            
            let okButton = UIAlertAction(title: "Ana Menü", style: .default) { _ in
                self.performSegue(withIdentifier: "backLoginScreen", sender: nil)
            }
            
            let replayButton = UIAlertAction(title: "Tekrar Oyna", style: .default) { _ in
                self.zorlukSeciminiGoster()
            }
            
            alert.addAction(scoreButton)
            alert.addAction(okButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true)
        }
    }
    
    func zorlukSeciminiGoster() {
        let alert = UIAlertController(title: "Zorluk Seç", message: "Oyun zorluğunu seçin", preferredStyle: .alert)
        
        let easyAction = UIAlertAction(title: "Kolay", style: .default) { _ in
            self.selectedDifficulty = "Easy"
            self.resetGame()
        }
        
        let hardAction = UIAlertAction(title: "Zor", style: .default) { _ in
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
    
    // MARK: - SkinsSelectionDelegate
    func didSelectSkins(normalSkin: UIImage?, darkSideSkin: UIImage?) {
        self.normalSkin = normalSkin
        self.darkSideSkin = darkSideSkin
        applySkinsToPikachus()
    }
    
    func applySkinsToPikachus() {
        // Normal Pikachus
        let normalPikachus = [pikachu1, pikachu2, pikachu3, pikachu4, pikachu5, pikachu6, pikachu7, pikachu8, pikachu9]
        for pikachu in normalPikachus {
            pikachu?.image = normalSkin
        }
        
        // Dark Side Pikachus
        let darkSidePikachus = [pikachu10, pikachu11, pikachu12, pikachu13, pikachu14, pikachu15, pikachu16, pikachu17, pikachu18]
        for pikachu in darkSidePikachus {
            pikachu?.image = darkSideSkin
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

extension UIFont {
    static func customFont(size: CGFloat) -> UIFont {
        if let font = UIFont(name: "Electric", size: size) {
            return font
        }
        return .systemFont(ofSize: size)
    }
}
