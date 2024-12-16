import UIKit

class SkinsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: SkinsSelectionDelegate?
    
    let normalSkinImages = ["Pikachu 2", "Bulbasaur", "Rattata", "Squirtle", "Jigglypuff", "Charmander"]
    let darkSideSkinImages = ["darkSide Pikachu 1", "DarkSide Bulbasaur", "DarkSide Rattata", "DarkSide Squirtle", "DarkSide Jigglypuff", "DarkSide Charmander"]
    
    var selectedNormalSkin: UIImage?
    var selectedDarkSideSkin: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
      
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SkinCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return normalSkinImages.count + darkSideSkinImages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SkinCell", for: indexPath)
        
        let imageName = indexPath.row < normalSkinImages.count ? normalSkinImages[indexPath.row] : darkSideSkinImages[indexPath.row - normalSkinImages.count]
        cell.imageView?.image = UIImage(named: imageName)
        cell.textLabel?.text = imageName

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < normalSkinImages.count {
            selectedNormalSkin = UIImage(named: normalSkinImages[indexPath.row])
            selectedDarkSideSkin = UIImage(named: darkSideSkinImages[indexPath.row])
        } else {
            selectedDarkSideSkin = UIImage(named: darkSideSkinImages[indexPath.row - normalSkinImages.count])
            selectedNormalSkin = UIImage(named: normalSkinImages[indexPath.row - normalSkinImages.count])
        }
        
  
        delegate?.didSelectSkins(normalSkin: selectedNormalSkin, darkSideSkin: selectedDarkSideSkin)

        dismiss(animated: true, completion: nil)
    }
}

        
    
    

