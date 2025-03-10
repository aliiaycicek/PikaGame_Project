// MARK: - SkinsVC

import UIKit

// MARK: - Character Assets
enum CharacterAssets: String, CaseIterable {
    case pikachu = "Pikachu 2"
    case bulbasaur = "Bulbasaur"
    case rattata = "Rattata"
    case squirtle = "Squirtle"
    case jigglypuff = "Jigglypuff"
    case charmander = "Charmander"
    
    var darkSideVersion: String {
        switch self {
        case .pikachu:
            return "darkSide Pikachu 1"
        default:
            return "DarkSide \(self.rawValue)"
        }
    }
}

// MARK: - SkinCell
class SkinCollectionViewCell: UICollectionViewCell {
    static let identifier = "SkinCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        // Özel font (eğer varsa)
        if let pokemonFont = UIFont(name: "Electric", size: 16) {
            label.font = pokemonFont
        } else {
            label.font = .systemFont(ofSize: 16, weight: .bold)
        }
        
        label.textColor = Theme.primaryColor
        label.shadowColor = UIColor.white
        label.shadowOffset = CGSize(width: 1, height: 1)
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = Theme.darkPurple
        label.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            let selectedColor = Theme.lightningOrange
            contentView.layer.borderWidth = isSelected ? 4 : 0
            contentView.layer.borderColor = isSelected ? selectedColor.cgColor : nil
            
            if isSelected {
                // Parlama efekti
                contentView.layer.shadowColor = Theme.pikachuYellow.cgColor
                contentView.layer.shadowRadius = 10
                contentView.layer.shadowOpacity = 0.8
                
                UIView.animate(withDuration: 0.2) {
                    self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                }
            } else {
                // Normal gölge
                contentView.layer.shadowColor = UIColor.black.cgColor
                contentView.layer.shadowRadius = 6
                contentView.layer.shadowOpacity = 0.3
                
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        // Gradient arka plan
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = contentView.bounds
        gradientLayer.colors = [Theme.electricBlue.withAlphaComponent(0.7).cgColor, Theme.pikachuYellow.withAlphaComponent(0.7).cgColor]
        gradientLayer.cornerRadius = 20
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        contentView.layer.cornerRadius = 20
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowRadius = 6
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.masksToBounds = false
        
        // Add subviews
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(typeLabel)
        
        // Setup constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            typeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            typeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            typeLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with character: CharacterAssets) {
        imageView.image = UIImage(named: character.rawValue)
        nameLabel.text = character.rawValue
        
        // Pokemon tipini belirle
        switch character {
        case .pikachu:
            typeLabel.text = "Elektrik"
            typeLabel.backgroundColor = Theme.lightningOrange.withAlphaComponent(0.7)
        case .bulbasaur:
            typeLabel.text = "Çim"
            typeLabel.backgroundColor = Theme.leafGreen.withAlphaComponent(0.7)
        case .squirtle:
            typeLabel.text = "Su"
            typeLabel.backgroundColor = Theme.waterBlue.withAlphaComponent(0.7)
        case .charmander:
            typeLabel.text = "Ateş"
            typeLabel.backgroundColor = Theme.pokemonRed.withAlphaComponent(0.7)
        case .jigglypuff:
            typeLabel.text = "Peri"
            typeLabel.backgroundColor = Theme.darkPurple.withAlphaComponent(0.7)
        case .rattata:
            typeLabel.text = "Normal"
            typeLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        }
    }
}

class SkinsVC: UIViewController {
    
    // MARK: - Properties
    weak var delegate: SkinsSelectionDelegate?
    var selectedIndex: Int?
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSavedSelection()
        addBackButton()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Pokemon Seçimi"
        
        // Başlık stili
        if let pokemonFont = UIFont(name: "Electric", size: 24) {
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.black.withAlphaComponent(0.5)
            shadow.shadowOffset = CGSize(width: 1, height: 2)
            shadow.shadowBlurRadius = 3
            
            navigationController?.navigationBar.titleTextAttributes = [
                .foregroundColor: Theme.pikachuYellow,
                .font: pokemonFont,
                .shadow: shadow
            ]
        } else {
            navigationController?.navigationBar.titleTextAttributes = [
                .foregroundColor: Theme.pikachuYellow,
                .font: UIFont.systemFont(ofSize: 24, weight: .bold)
            ]
        }
        
        // Modern gradient arka plan
        Theme.applyGradientBackground(to: view)
        
        // Yıldırım efekti ekle
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Theme.addLightningEffect(to: self.view)
        }
        
        // Setup CollectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 25
        layout.sectionInset = UIEdgeInsets(top: 25, left: 20, bottom: 100, right: 20)
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SkinCollectionViewCell.self, forCellWithReuseIdentifier: SkinCollectionViewCell.identifier)
        collectionView.allowsMultipleSelection = false
        
        // Hafif yansıma efekti
        collectionView.showsVerticalScrollIndicator = false
    }
    
    private func loadSavedSelection() {
        if let savedSkinName = UserDefaults.standard.string(forKey: "selectedNormalSkin"),
           let index = CharacterAssets.allCases.firstIndex(where: { $0.rawValue == savedSkinName }) {
            selectedIndex = index
            collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: [])
        }
    }
    
    private func selectSkin(at index: Int) {
        let character = CharacterAssets.allCases[index]
        let normalSkinName = character.rawValue
        let darkSideSkinName = character.darkSideVersion
        
        guard let normalSkin = UIImage(named: normalSkinName),
              let darkSideSkin = UIImage(named: darkSideSkinName) else {
            showAlert(title: "Error", message: "Failed to load character")
            return
        }
        
        // Save selection
        UserDefaults.standard.set(normalSkinName, forKey: "selectedNormalSkin")
        UserDefaults.standard.set(darkSideSkinName, forKey: "selectedDarkSideSkin")
        UserDefaults.standard.synchronize()
        
        // Notify delegate and dismiss
        delegate?.didSelectSkins(normalSkin: normalSkin, darkSideSkin: darkSideSkin)
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func addBackButton() {
        let button = UIButton(type: .system)
        button.setTitle("🏠 Ana Menü", for: .normal)
        
        // Özel font (eğer varsa)
        if let pokemonFont = UIFont(name: "Electric", size: 18) {
            button.titleLabel?.font = pokemonFont
        } else {
            button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        }
        
        // Modern buton tasarımı
        button.backgroundColor = Theme.pikachuYellow
        button.setTitleColor(Theme.primaryColor, for: .normal)
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        
        // Gölge efekti
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.4
        button.layer.masksToBounds = false
        
        // Basınca küçülme efekti
        button.addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button.widthAnchor.constraint(equalToConstant: 220),
            button.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func buttonReleased(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
        }
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension SkinsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CharacterAssets.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SkinCollectionViewCell.identifier, for: indexPath) as? SkinCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let character = CharacterAssets.allCases[indexPath.item]
        cell.configure(with: character)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 32 // Total horizontal padding
        let minimumSpacing: CGFloat = 20
        let availableWidth = collectionView.bounds.width - padding
        let itemWidth = (availableWidth - minimumSpacing) / 2
        return CGSize(width: itemWidth, height: itemWidth * 1.3) // 1.3 aspect ratio for the card
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        selectSkin(at: indexPath.item)
    }
}
