import UIKit

struct AppTheme {
    // MARK: - Colors
    static let primaryColor = UIColor(red: 30/255, green: 55/255, blue: 153/255, alpha: 1) // Pokemon mavi
    static let secondaryColor = UIColor(red: 255/255, green: 203/255, blue: 5/255, alpha: 1) // Pokemon sarı
    static let backgroundColor = UIColor(red: 30/255, green: 55/255, blue: 153/255, alpha: 1)
    static let textColor = UIColor.white
    static let shadowColor = UIColor.black
    
    // MARK: - Shadows
    static func applyDefaultShadow(to view: UIView) {
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.3
    }
    
    // MARK: - Backgrounds
    static func applyGradientBackground(to view: UIView) {
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "pokemon_background")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        
        let overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.insertSubview(overlayView, at: 1)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 100)
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.6).cgColor,
            UIColor.clear.cgColor
        ]
        view.layer.insertSublayer(gradientLayer, at: 2)
    }
    
    // MARK: - UI Elements
    static func styleButton(_ button: UIButton) {
        button.backgroundColor = secondaryColor
        button.setTitleColor(primaryColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 10
        applyDefaultShadow(to: button)
    }
    
    static func styleTextField(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        textField.textColor = primaryColor
        textField.font = .systemFont(ofSize: 18)
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = secondaryColor.cgColor
        applyDefaultShadow(to: textField)
        
        // Padding için
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    static func styleTableView(_ tableView: UITableView) {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    static func styleTableViewCell(_ cell: UITableViewCell) {
        cell.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        
        // Hücre seçim efekti
        let selectedView = UIView()
        selectedView.backgroundColor = secondaryColor.withAlphaComponent(0.3)
        cell.selectedBackgroundView = selectedView
    }
}
