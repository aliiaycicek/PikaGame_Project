import UIKit
import AVFoundation

struct Theme {
    // MARK: - Colors
    static let primaryColor = UIColor(red: 30/255, green: 55/255, blue: 153/255, alpha: 1) // Pokemon mavi
    static let secondaryColor = UIColor(red: 255/255, green: 203/255, blue: 5/255, alpha: 1) // Pokemon sarı
    static let backgroundColor = UIColor(red: 30/255, green: 55/255, blue: 153/255, alpha: 0.9)
    static let textColor = UIColor.white
    static let shadowColor = UIColor.black
    
    // Yeni modern renkler
    static let pikachuYellow = UIColor(red: 255/255, green: 213/255, blue: 0/255, alpha: 1) // Pikachu sarısı
    static let electricBlue = UIColor(red: 35/255, green: 174/255, blue: 255/255, alpha: 1) // Elektrik mavisi
    static let lightningOrange = UIColor(red: 255/255, green: 153/255, blue: 0/255, alpha: 1) // Yıldırım turuncu
    static let pokemonRed = UIColor(red: 255/255, green: 45/255, blue: 45/255, alpha: 1) // Pokemon kırmızı
    static let leafGreen = UIColor(red: 0/255, green: 204/255, blue: 102/255, alpha: 1) // Yaprak yeşili
    static let waterBlue = UIColor(red: 0/255, green: 153/255, blue: 255/255, alpha: 1) // Su mavisi
    static let darkPurple = UIColor(red: 102/255, green: 0/255, blue: 204/255, alpha: 1) // Koyu mor
    
    // MARK: - Shadows
    static func applyDefaultShadow(to view: UIView) {
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.3
    }
    
    // MARK: - Backgrounds
    static func applyGradientBackground(to view: UIView) {
        // Arka plan gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [electricBlue.cgColor, pikachuYellow.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Pokeball deseni overlay
        let patternOverlay = UIImageView(frame: view.bounds)
        patternOverlay.image = UIImage(named: "pokeball_pattern") // Eğer bu görsel yoksa, oluşturmanız gerekebilir
        patternOverlay.contentMode = .scaleAspectFill
        patternOverlay.alpha = 0.1
        view.insertSubview(patternOverlay, at: 1)
    }
    
    static func applyThematicBackground(to view: UIView, type: String = "electric") {
        var colors: [CGColor] = [electricBlue.cgColor, pikachuYellow.cgColor]
        
        // Pokemon tipine göre arka plan renkleri
        switch type.lowercased() {
        case "fire":
            colors = [pokemonRed.cgColor, lightningOrange.cgColor]
        case "water":
            colors = [waterBlue.cgColor, electricBlue.cgColor]
        case "grass":
            colors = [leafGreen.cgColor, pikachuYellow.cgColor]
        case "psychic":
            colors = [darkPurple.cgColor, electricBlue.cgColor]
        default: // electric
            break
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colors
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - UI Elements
    static func styleButton(_ button: UIButton) {
        // Modern, yuvarlak köşeli buton
        button.backgroundColor = pikachuYellow
        button.setTitleColor(primaryColor, for: .normal)
        
        // Özel font (eğer varsa)
        if let pokemonFont = UIFont(name: "Electric", size: 20) {
            button.titleLabel?.font = pokemonFont
        } else {
            button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        }
        
        // Köşe ve gölge efektleri
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        applyDefaultShadow(to: button)
        
        // Buton basılma efekti
        button.addTarget(self, action: #selector(UIButton.buttonPressed), for: .touchDown)
        button.addTarget(self, action: #selector(UIButton.buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    static func styleTextField(_ textField: UITextField) {
        // Modern, yarı saydam arka planlı metin kutusu
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        textField.textColor = primaryColor
        
        // Özel font (eğer varsa)
        if let pokemonFont = UIFont(name: "Electric", size: 18) {
            textField.font = pokemonFont
        } else {
            textField.font = .systemFont(ofSize: 18)
        }
        
        // Kenar ve köşe tasarımı
        textField.layer.cornerRadius = 20
        textField.layer.borderWidth = 2
        textField.layer.borderColor = electricBlue.cgColor
        applyDefaultShadow(to: textField)
        
        // Padding için
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        // Placeholder rengi
        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: primaryColor.withAlphaComponent(0.6)]
        )
    }
    
    static func styleTableView(_ tableView: UITableView) {
        // Modern, saydam arka planlı tablo
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        // Yuvarlak köşeli tablo
        tableView.layer.cornerRadius = 15
        tableView.clipsToBounds = true
        
        // Hafif gölge efekti
        tableView.layer.shadowColor = shadowColor.cgColor
        tableView.layer.shadowOffset = CGSize(width: 0, height: 5)
        tableView.layer.shadowRadius = 10
        tableView.layer.shadowOpacity = 0.2
    }
    
    static func styleTableViewCell(_ cell: UITableViewCell) {
        // Modern, yarı saydam hücre tasarımı
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        // Özel font (eğer varsa)
        if let pokemonFont = UIFont(name: "Electric", size: 16) {
            cell.textLabel?.font = pokemonFont
            cell.detailTextLabel?.font = UIFont(name: "Electric", size: 14)
        }
        
        // Metin renkleri
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = pikachuYellow
        
        // Hücre köşeleri ve kenarları
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        cell.contentView.layer.cornerRadius = 12
        
        // Hücre seçim efekti
        let selectedView = UIView()
        selectedView.backgroundColor = electricBlue.withAlphaComponent(0.4)
        cell.selectedBackgroundView = selectedView
        
        // Hücreler arası boşluk
        cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    // MARK: - Animasyon Efektleri
    static func addLightningEffect(to view: UIView) {
        // Rastgele konum belirle
        let randomX = CGFloat.random(in: 50...(view.bounds.width - 50))
        let randomY = CGFloat.random(in: 50...(view.bounds.height - 50))
        
        // Yıldırım şekli oluştur
        let lightningPath = UIBezierPath()
        lightningPath.move(to: CGPoint(x: randomX, y: randomY - 40))
        lightningPath.addLine(to: CGPoint(x: randomX - 10, y: randomY - 10))
        lightningPath.addLine(to: CGPoint(x: randomX + 5, y: randomY - 10))
        lightningPath.addLine(to: CGPoint(x: randomX - 5, y: randomY + 20))
        lightningPath.addLine(to: CGPoint(x: randomX + 15, y: randomY - 15))
        lightningPath.addLine(to: CGPoint(x: randomX, y: randomY - 15))
        lightningPath.addLine(to: CGPoint(x: randomX, y: randomY - 40))
        
        // Yıldırım katmanı oluştur
        let lightningLayer = CAShapeLayer()
        lightningLayer.path = lightningPath.cgPath
        lightningLayer.fillColor = pikachuYellow.cgColor
        lightningLayer.strokeColor = lightningOrange.cgColor
        lightningLayer.lineWidth = 2.0
        lightningLayer.opacity = 0
        
        // Katmanı ekrana ekle
        view.layer.addSublayer(lightningLayer)
        
        // Yıldırım animasyonu - daha uzun süre görünür
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0
        fadeIn.toValue = 1
        fadeIn.duration = 0.2
        
        let stayVisible = CABasicAnimation(keyPath: "opacity")
        stayVisible.fromValue = 1
        stayVisible.toValue = 1
        stayVisible.beginTime = 0.2
        stayVisible.duration = 0.8
        
        let fadeOut = CABasicAnimation(keyPath: "opacity")
        fadeOut.fromValue = 1
        fadeOut.toValue = 0
        fadeOut.duration = 0.4
        fadeOut.beginTime = 1.0
        
        let animGroup = CAAnimationGroup()
        animGroup.animations = [fadeIn, stayVisible, fadeOut]
        animGroup.duration = 1.4
        animGroup.isRemovedOnCompletion = false
        animGroup.fillMode = .forwards
        
        lightningLayer.add(animGroup, forKey: "lightningEffect")
        
        // Ses efekti (eğer varsa)
        playThunderSound()
        
        // Animasyon bittikten sonra katmanı kaldır
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            lightningLayer.removeFromSuperlayer()
        }
    }
    
    static func playThunderSound() {
        // AVAudioPlayer kullanarak ses çalma (uygulamada thunder.mp3 dosyası olmalı)
        guard let soundURL = Bundle.main.url(forResource: "thunder", withExtension: "mp3") else { return }
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer.volume = 0.3
            audioPlayer.play()
        } catch {
            print("Ses dosyası çalınamadı: \(error.localizedDescription)")
        }
    }
}

// MARK: - UIButton Extensions
extension UIButton {
    @objc func buttonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc func buttonReleased() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }
}
