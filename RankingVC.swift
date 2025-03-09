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
        AppTheme.applyGradientBackground(to: view)
        
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
                .foregroundColor: AppTheme.textColor
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
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        containerView.layer.cornerRadius = 10
        
        let scoreStack = UIStackView()
        scoreStack.axis = .vertical
        scoreStack.spacing = 4
        scoreStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Ana metin: Sıra. Oyuncu Adı - Skor
        let mainLabel = UILabel()
        mainLabel.text = "\(rank). \(score.playerName) - \(score.score) puan"
        mainLabel.textColor = AppTheme.textColor
        if let customFont = UIFont(name: "Electric", size: 18) {
            mainLabel.font = customFont
        }
        
        // Alt metin: Zorluk Seviyesi ve Tarih
        let subLabel = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        subLabel.text = "\(score.difficulty) - \(dateFormatter.string(from: score.date))"
        subLabel.textColor = AppTheme.textColor.withAlphaComponent(0.7)
        if let customFont = UIFont(name: "Electric", size: 14) {
            subLabel.font = customFont
        }
        
        scoreStack.addArrangedSubview(mainLabel)
        scoreStack.addArrangedSubview(subLabel)
        
        containerView.addSubview(scoreStack)
        
        // Constraints
        NSLayoutConstraint.activate([
            scoreStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            scoreStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            scoreStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            scoreStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
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
        backButton.tintColor = AppTheme.textColor
        
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
