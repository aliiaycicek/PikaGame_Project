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
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderWidth = isSelected ? 3 : 0
            contentView.layer.borderColor = isSelected ? UIColor.systemBlue.cgColor : nil
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
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.2
        
        // Add subviews
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        // Setup constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
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
        title = "Karakter Seç"
        view.backgroundColor = .systemBackground
        
        // Setup CollectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .systemBackground
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
            showAlert(title: "Hata", message: "Karakter yüklenirken bir hata oluştu")
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
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
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
        let minimumSpacing: CGFloat = 16
        let availableWidth = collectionView.bounds.width - padding
        let itemWidth = (availableWidth - minimumSpacing) / 2
        return CGSize(width: itemWidth, height: itemWidth * 1.3) // 1.3 aspect ratio for the card
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        selectSkin(at: indexPath.item)
    }
}
