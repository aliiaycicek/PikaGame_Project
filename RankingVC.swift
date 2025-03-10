//
//  RankingVC.swift
//  Pika Game Project
//
//  Created by Ali Ayçiçek on 19.07.2023.
//

import UIKit

class RankingVC: UIViewController {
    
    @IBOutlet weak var stackView: UIStackView!
    private var scores: [HighScore] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("RankingVC: viewDidLoad çağrıldı")
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("RankingVC: viewWillAppear çağrıldı")
        fetchScores()
    }
    
    private func setupUI() {
        // Arka plan
        Theme.applyGradientBackground(to: view)
        
        // StackView ayarları
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        // Başlık
        title = "Top 10 Scores"
        if let customFont = UIFont(name: "Electric", size: 24) {
            navigationController?.navigationBar.titleTextAttributes = [
                .font: customFont,
                .foregroundColor: Theme.textColor
            ]
        }
        
        // Back butonu ekle
        addBackButton()
    }
    
    private func fetchScores() {
        print("RankingVC: Skorlar getiriliyor...")
        scores = DatabaseManager.shared.getTopScores()
        print("RankingVC: \(scores.count) skor alındı")
        updateScoreViews()
    }
    
    private func updateScoreViews() {
        // Önceki skorları temizle
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Yeni skorları ekle
        for (index, score) in scores.enumerated() {
            let scoreView = createScoreView(rank: index + 1, score: score)
            stackView.addArrangedSubview(scoreView)
        }
    }
    
    private func createScoreView(rank: Int, score: HighScore) -> UIView {
        let containerView = UIView()
        
        // Gradient arka plan
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 80)
        gradientLayer.colors = [Theme.electricBlue.withAlphaComponent(0.7).cgColor, Theme.pikachuYellow.withAlphaComponent(0.3).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 15
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Gölge efekti
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.cornerRadius = 15
        
        // Madalya ikonu (ilk 3 için)
        if rank <= 3 {
            let medalImageView = UIImageView()
            medalImageView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(medalImageView)
            
            switch rank {
            case 1:
                medalImageView.image = UIImage(systemName: "medal.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
            case 2:
                medalImageView.image = UIImage(systemName: "medal.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
            case 3:
                medalImageView.image = UIImage(systemName: "medal.fill")?.withTintColor(.systemBrown, renderingMode: .alwaysOriginal)
            default: break
            }
            
            NSLayoutConstraint.activate([
                medalImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
                medalImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                medalImageView.widthAnchor.constraint(equalToConstant: 30),
                medalImageView.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
        
        let scoreStack = UIStackView()
        scoreStack.axis = .vertical
        scoreStack.spacing = 6
        scoreStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Ana metin: Sıra. Oyuncu Adı - Skor
        let mainLabel = UILabel()
        mainLabel.text = "\(rank). \(score.playerName) - \(score.score) puan"
        mainLabel.textColor = Theme.textColor
        if let customFont = UIFont(name: "Electric", size: 18) {
            mainLabel.font = customFont
        } else {
            mainLabel.font = .systemFont(ofSize: 18, weight: .bold)
        }
        
        // Alt metin: Zorluk Seviyesi ve Tarih
        let subLabel = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        subLabel.text = "\(score.difficulty) - \(dateFormatter.string(from: score.date))"
        subLabel.textColor = Theme.textColor.withAlphaComponent(0.8)
        if let customFont = UIFont(name: "Electric", size: 14) {
            subLabel.font = customFont
        } else {
            subLabel.font = .systemFont(ofSize: 14, weight: .medium)
        }
        
        scoreStack.addArrangedSubview(mainLabel)
        scoreStack.addArrangedSubview(subLabel)
        
        containerView.addSubview(scoreStack)
        
        // Constraints
        NSLayoutConstraint.activate([
            scoreStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            scoreStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: rank <= 3 ? 55 : 15),
            scoreStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            scoreStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            containerView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        return containerView
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    private func addBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setTitle("Ana Menü", for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backButton.layer.cornerRadius = 10
        backButton.tintColor = Theme.textColor
        
        if let customFont = UIFont(name: "Electric", size: 18) {
            backButton.titleLabel?.font = customFont
        }
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            backButton.widthAnchor.constraint(equalToConstant: 200),
            backButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func backButtonTapped() {
        // Önce navigationController ile deneyelim
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            // Navigation controller yoksa dismiss yapalım
            self.dismiss(animated: true)
        }
    }
}
