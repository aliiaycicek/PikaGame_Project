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
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(red: 30/255, green: 55/255, blue: 153/255, alpha: 1)
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = isSelected ? 4 : 0
            contentView.layer.borderColor = isSelected ? UIColor(red: 30/255, green: 55/255, blue: 153/255, alpha: 1).cgColor : nil
            
            if isSelected {
                UIView.animate(withDuration: 0.2) {
                    self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                }
            } else {
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
        contentView.backgroundColor = UIColor(red: 255/255, green: 203/255, blue: 5/255, alpha: 0.9)
        contentView.layer.cornerRadius = 15
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        contentView.layer.shadowRadius = 6
        contentView.layer.shadowOpacity = 0.3
        
        // Add subviews
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        // Setup constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with character: CharacterAssets) {
        imageView.image = UIImage(named: character.rawValue)
        nameLabel.text = character.rawValue
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
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Select Pokemon"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor(red: 30/255, green: 55/255, blue: 153/255, alpha: 1),
            .font: UIFont.systemFont(ofSize: 22, weight: .bold)
        ]
        
        // Background image
        let backgroundImage = UIImageView(frame: view.bounds)
        backgroundImage.image = UIImage(named: "pokemon_background")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        
        // Setup CollectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SkinCollectionViewCell.self, forCellWithReuseIdentifier: SkinCollectionViewCell.identifier)
        collectionView.allowsMultipleSelection = false
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
