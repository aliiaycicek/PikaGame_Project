// MARK: - SkinsVC

import UIKit
class SkinsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: SkinsSelectionDelegate?
    
    let normalSkinImages = ["Pikachu 2", "Bulbasaur", "Rattata", "Squirtle", "Jigglypuff", "Charmander"]
    let darkSideSkinImages = ["darkSide Pikachu 1", "DarkSide Bulbasaur", "DarkSide Rattata", "DarkSide Squirtle", "DarkSide Jigglypuff", "DarkSide Charmander"]
    
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SkinCell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(confirmSelection))
        
        // Mevcut seçili skin'i kontrol et
        if let savedSkinName = UserDefaults.standard.string(forKey: "selectedNormalSkin") {
            selectedIndex = normalSkinImages.firstIndex(of: savedSkinName)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return normalSkinImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SkinCell", for: indexPath)
        
        let normalImageName = normalSkinImages[indexPath.row]
        cell.imageView?.image = UIImage(named: normalImageName)
        cell.textLabel?.text = normalImageName
        cell.accessoryType = selectedIndex == indexPath.row ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
    
    @objc func confirmSelection() {
        guard let index = selectedIndex else {
            let alert = UIAlertController(title: "Seçim Yapılmadı", message: "Lütfen bir karakter seçin", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Seçilen skinleri UserDefaults'a kaydet
        UserDefaults.standard.set(normalSkinImages[index], forKey: "selectedNormalSkin")
        UserDefaults.standard.set(darkSideSkinImages[index], forKey: "selectedDarkSideSkin")
        UserDefaults.standard.synchronize()
        
        let normalSkin = UIImage(named: normalSkinImages[index])
        let darkSideSkin = UIImage(named: darkSideSkinImages[index])
        
        delegate?.didSelectSkins(normalSkin: normalSkin, darkSideSkin: darkSideSkin)
        navigationController?.popViewController(animated: true)
    }

}
