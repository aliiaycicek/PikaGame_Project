//
//  WellcomeVC.swift
//  Pika Game Project
//
//  Created by Ali Ayçiçek on 31.10.2023.
//

import UIKit

class WellcomeVC: UIViewController {
    
    @IBOutlet weak var Logo: UIImageView!
    private var initialLogoFrame: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Arka plan gradientini ayarla
        Theme.applyGradientBackground(to: view)
        
        // Logo ayarları
        Logo.contentMode = .scaleAspectFit
        Logo.alpha = 0
        
        // Animasyonları başlat
        startWelcomeAnimations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if initialLogoFrame == nil {
            initialLogoFrame = Logo.frame
            Logo.center = view.center
        }
    }
    
    private func startWelcomeAnimations() {
        // Logo'yu göster
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut) {
            self.Logo.alpha = 1
            self.Logo.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            // Logo'yu hafifçe hareket ettir
            self.pulseAnimation()
        }
        
        // 4 saniye sonra bitiş animasyonunu başlat
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.finishAnimation()
        }
    }
    
    private func pulseAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.Logo.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    private func finishAnimation() {
        // Pulse animasyonunu durdur
        self.Logo.layer.removeAllAnimations()
        
        // Final animasyonu
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseIn) {
            self.Logo.transform = CGAffineTransform(scaleX: 3, y: 3)
            self.Logo.alpha = 0
            
            // Ekranı parlat
            let whiteOverlay = UIView(frame: self.view.bounds)
            whiteOverlay.backgroundColor = .white
            whiteOverlay.alpha = 0
            self.view.addSubview(whiteOverlay)
            whiteOverlay.alpha = 0.6
            
        } completion: { _ in
            self.performSegue(withIdentifier: "loginScreen", sender: nil)
        }
    }
}
