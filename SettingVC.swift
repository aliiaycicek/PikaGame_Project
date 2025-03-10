import UIKit

class SettingVC: UIViewController {
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    private var settings: [[String: Any]] = [
        [
            "section": "Sound Settings",
            "items": [
                ["title": "Sound Effects", "key": "soundEffectsEnabled"],
                ["title": "Background Music", "key": "backgroundMusicEnabled"]
            ]
        ],
        [
            "section": "About",
            "items": [
                ["title": "Version", "detail": "1.0.0"],
                ["title": "Developer", "detail": "Ali Ayçiçek"]
            ]
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    private func setupUI() {
        // Arka plan
        Theme.applyGradientBackground(to: view)
        
        // Navigation bar ayarları
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = Theme.secondaryColor
        
        if let titleLabel = navigationController?.navigationBar.topItem?.titleView as? UILabel {
            titleLabel.textColor = Theme.textColor
            titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        }
        
        // Back butonu ekle
        addBackButton()
    }
    
    private func setupTableView() {
        Theme.styleTableView(settingsTableView)
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }
}

// MARK: - UITableView DataSource & Delegate
extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = settings[section]["items"] as? [[String: String]] {
            return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        Theme.styleTableViewCell(cell)
        
        if let items = settings[indexPath.section]["items"] as? [[String: String]] {
            let item = items[indexPath.row]
            
            cell.textLabel?.text = item["title"]
            cell.textLabel?.font = .systemFont(ofSize: 17)
            
            if let key = item["key"] {
                // Switch'li hücreler
                let toggle = UISwitch()
                toggle.onTintColor = Theme.secondaryColor
                toggle.isOn = UserDefaults.standard.bool(forKey: key)
                toggle.tag = indexPath.row
                toggle.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
                cell.accessoryView = toggle
                cell.selectionStyle = .none
            } else if let detail = item["detail"] {
                // Detay metinli hücreler
                cell.detailTextLabel?.text = detail
                cell.detailTextLabel?.font = .systemFont(ofSize: 15)
                cell.detailTextLabel?.textColor = Theme.textColor.withAlphaComponent(0.7)
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = Theme.primaryColor.withAlphaComponent(0.3)
        
        let label = UILabel()
        label.text = settings[section]["section"] as? String
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = Theme.secondaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        let section = settings[0]["items"] as! [[String: String]]
        let key = section[sender.tag]["key"]!
        
        UserDefaults.standard.set(sender.isOn, forKey: key)
        NotificationCenter.default.post(name: Notification.Name(key), object: nil)
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
