//
//  LoginScreenVC.swift
//  Pika Game Project
//
//  Created by Ali Ayçiçek on 19.07.2023.
//

import UIKit
import AVFoundation

class LoginScreenVC: UIViewController {

    var audioPlayer: AVAudioPlayer?
    var backgroundMusicPlayer: AVAudioPlayer?
    var userName = ""
    var selectedDifficulty = "Easy"
    
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var playButton: UIButton! {
        didSet {
            playButton?.backgroundColor = Theme.secondaryColor
            playButton?.setTitleColor(Theme.primaryColor, for: .normal)
            playButton?.layer.cornerRadius = 10
            Theme.applyDefaultShadow(to: playButton)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setupAudio()
        setupNotifications()
        setupUI()
    }
    
    private func setupAudio() {
        // Background music setup
        if let musicURL = Bundle.main.url(forResource: "pokemon_background_music", withExtension: "mp3") {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
                backgroundMusicPlayer?.numberOfLoops = -1 // Sonsuz döngü
                if UserDefaults.standard.bool(forKey: "backgroundMusicEnabled") {
                    backgroundMusicPlayer?.play()
                }
            } catch {
                print("Error: Couldn't load background music")
            }
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(handleBackgroundMusic(_:)),
                                             name: Notification.Name("backgroundMusicEnabled"),
                                             object: nil)
        
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(handleSoundEffects(_:)),
                                             name: Notification.Name("soundEffectsEnabled"),
                                             object: nil)
    }
    
    private func setupUI() {
        // Label ayarları
        if let label = gameNameLabel {
            label.textColor = Theme.textColor
            label.font = .systemFont(ofSize: 32, weight: .bold)
            Theme.applyDefaultShadow(to: label)
        }
        
        // TextField ayarları
        if let textField = usernameTextField {
            Theme.styleTextField(textField)
        }
    }
    
    @objc private func handleBackgroundMusic(_ notification: Notification) {
        if UserDefaults.standard.bool(forKey: "backgroundMusicEnabled") {
            backgroundMusicPlayer?.play()
        } else {
            backgroundMusicPlayer?.stop()
        }
    }
    
    @objc private func handleSoundEffects(_ notification: Notification) {
        // Sound effects will be handled when playing sound
    }
    
    @IBAction func leaderBoardButton(_ sender: Any) {
        playSound()
        performSegue(withIdentifier: "rankingVC", sender: nil)
    }
    
    @IBAction func settingsButton(_ sender: Any) {
        playSound()
        performSegue(withIdentifier: "settingsVC", sender: nil)
    }
    
    @IBAction func skinsVC(_ sender: Any) {
        playSound()
        performSegue(withIdentifier: "SkinsVC", sender: nil)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        // Ses efekti
        playButtonSound()
        
        // Oyuncu adını kaydet
        userName = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if userName.isEmpty {
            alertFunction(titleInput: "Error!", messageInput: "Please enter a username!")
        } else {
            // Zorluk seviyesi seçim alert'ini göster
            showDifficultySelectionAlert()
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextScreenVC" {
            if let difficulty = sender as? String {
                let destinationVC = segue.destination as! ViewController
                destinationVC.playerNames = userName
                destinationVC.selectedDifficulty = difficulty
            }
        } else if segue.identifier == "SkinsVC" {
            if let skinsVC = segue.destination as? SkinsVC {
                // Mevcut seçili skin'i kontrol et
                if let savedSkinName = UserDefaults.standard.string(forKey: "selectedNormalSkin") {
                    skinsVC.selectedIndex = CharacterAssets.allCases.firstIndex { $0.rawValue == savedSkinName }
                }
                
                // ViewController'ı bul ve delegate olarak ata
                if let navigationController = self.navigationController,
                   let viewController = navigationController.viewControllers.first(where: { $0 is ViewController }) as? ViewController {
                    skinsVC.delegate = viewController
                }
            }
        }
    }
    
    private func showDifficultySelectionAlert() {
        let alert = UIAlertController(title: "Select Difficulty", message: "Choose game difficulty", preferredStyle: .alert)
        
        let easyAction = UIAlertAction(title: "Easy", style: .default) { [weak self] _ in
            self?.startGame(difficulty: "Easy")
        }
        
        let hardAction = UIAlertAction(title: "Hard", style: .default) { [weak self] _ in
            self?.startGame(difficulty: "Hard")
        }
        
        alert.addAction(easyAction)
        alert.addAction(hardAction)
        
        present(alert, animated: true)
    }
    
    private func startGame(difficulty: String) {
        performSegue(withIdentifier: "nextScreenVC", sender: difficulty)
    }
    
    private func playButtonSound() {
        guard let path = Bundle.main.path(forResource: "pikaeffect", ofType: "mp3") else { return }
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    func alertFunction(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
  
    func playSound() {
        // Only play if sound effects are enabled
        if UserDefaults.standard.bool(forKey: "soundEffectsEnabled") {
            if let soundURL = Bundle.main.url(forResource: "pikaeffect", withExtension: "mp3") {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    audioPlayer?.play()
                } catch {
                    print("Error: Couldn't play sound file.")
                }
            }
        }
    }
}
