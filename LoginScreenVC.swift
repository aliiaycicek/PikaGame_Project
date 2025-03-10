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
    
    // Yıldırım efekti için timer
    private var lightningTimer: Timer?
    
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
        setupLightningEffect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Ekrandan ayrılırken timer'ı durdur
        lightningTimer?.invalidate()
        lightningTimer = nil
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
        // Modern gradient arka plan
        Theme.applyGradientBackground(to: view)
        
        // Label ayarları
        if let label = gameNameLabel {
            label.textColor = Theme.pikachuYellow
            
            // Özel font (eğer varsa)
            if let pokemonFont = UIFont(name: "Electric", size: 36) {
                label.font = pokemonFont
            } else {
                label.font = .systemFont(ofSize: 36, weight: .bold)
            }
            
            // Gölge efekti
            label.layer.shadowColor = Theme.lightningOrange.cgColor
            label.layer.shadowOffset = CGSize(width: 0, height: 3)
            label.layer.shadowRadius = 6
            label.layer.shadowOpacity = 0.8
        }
        
        // TextField ayarları
        if let textField = usernameTextField {
            textField.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
            textField.textColor = Theme.pikachuYellow
            textField.tintColor = Theme.pikachuYellow
            textField.layer.cornerRadius = 15
            textField.layer.borderWidth = 2
            textField.layer.borderColor = Theme.pikachuYellow.cgColor
            textField.attributedPlaceholder = NSAttributedString(
                string: "Pokemon Eğiticisi Adınız",
                attributes: [NSAttributedString.Key.foregroundColor: Theme.pikachuYellow.withAlphaComponent(0.6)]
            )
            
            // Text alanı için padding ekle
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = .always
            
            // Gölge efekti
            textField.layer.shadowColor = Theme.pikachuYellow.cgColor
            textField.layer.shadowOffset = CGSize(width: 0, height: 2)
            textField.layer.shadowRadius = 4
            textField.layer.shadowOpacity = 0.3
            textField.layer.masksToBounds = false
            
            // Font ayarı
            if let customFont = UIFont(name: "Electric", size: 18) {
                textField.font = customFont
            } else {
                textField.font = .systemFont(ofSize: 18, weight: .medium)
            }
        }
        
        // Buton ayarları
        if let button = playButton {
            button.backgroundColor = Theme.pikachuYellow
            button.setTitleColor(Theme.primaryColor, for: .normal)
            button.layer.cornerRadius = 25
            button.clipsToBounds = true
            Theme.applyDefaultShadow(to: button)
            
            // Özel font (eğer varsa)
            if let pokemonFont = UIFont(name: "Electric", size: 20) {
                button.titleLabel?.font = pokemonFont
            } else {
                button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
            }
        }
        
        // Geliştirici adı etiketi
        let developerLabel = UILabel()
        developerLabel.text = "Developed by Ali Ayçiçek © 2025"
        developerLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        developerLabel.font = .systemFont(ofSize: 12, weight: .medium)
        developerLabel.textAlignment = .center
        developerLabel.shadowColor = UIColor.black
        developerLabel.shadowOffset = CGSize(width: 1, height: 1)
        
        // Animasyon efekti ekle
        developerLabel.alpha = 0
        
        view.addSubview(developerLabel)
        developerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            developerLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            developerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            developerLabel.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        // Fade-in animasyonu
        UIView.animate(withDuration: 1.5, delay: 0.5, options: [], animations: {
            developerLabel.alpha = 1
        }, completion: nil)
        
        // Pokemon logosu ekle
        let logoImageView = UIImageView(image: UIImage(named: "pokemon_logo"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.alpha = 0.9
        
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            logoImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
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
        let alert = UIAlertController(title: "Zorluk Seviyesi", message: "Oyun zorluğunu seçin", preferredStyle: .actionSheet)
        
        let easyAction = UIAlertAction(title: "Kolay", style: .default) { [weak self] _ in
            self?.startGame(difficulty: "Easy")
        }
        
        let mediumAction = UIAlertAction(title: "Orta", style: .default) { [weak self] _ in
            self?.startGame(difficulty: "Medium")
        }
        
        let hardAction = UIAlertAction(title: "Zor", style: .default) { [weak self] _ in
            self?.startGame(difficulty: "Hard")
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel)
        
        // Alert tasarımını güncelle
        alert.view.tintColor = Theme.primaryColor
        if let title = alert.title {
            let attributedString = NSAttributedString(string: title, attributes: [
                .font: UIFont.boldSystemFont(ofSize: 18),
                .foregroundColor: Theme.primaryColor
            ])
            alert.setValue(attributedString, forKey: "attributedTitle")
        }
        
        alert.addAction(easyAction)
        alert.addAction(mediumAction)
        alert.addAction(hardAction)
        alert.addAction(cancelAction)
        
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
    
    // MARK: - Yıldırım Efekti
    private func setupLightningEffect() {
        // 4-5 saniyede bir rastgele yıldırım efekti oluştur
        lightningTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval.random(in: 4...5), repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // Yıldırım efekti ekle
            Theme.addLightningEffect(to: self.view)
            
            // Timer'ı yeniden ayarla (rastgele süre)
            self.lightningTimer?.invalidate()
            self.lightningTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval.random(in: 4...5), repeats: true) { [weak self] _ in
                guard let self = self else { return }
                Theme.addLightningEffect(to: self.view)
            }
        }
    }
}
