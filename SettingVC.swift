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
        AppTheme.applyGradientBackground(to: view)
        
        // Navigation bar ayarları
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = AppTheme.secondaryColor
        
        if let titleLabel = navigationController?.navigationBar.topItem?.titleView as? UILabel {
            titleLabel.textColor = AppTheme.textColor
            titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        }
    }
    
    private func setupTableView() {
        AppTheme.styleTableView(settingsTableView)
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
        AppTheme.styleTableViewCell(cell)
        
        if let items = settings[indexPath.section]["items"] as? [[String: String]] {
            let item = items[indexPath.row]
            
            cell.textLabel?.text = item["title"]
            cell.textLabel?.font = .systemFont(ofSize: 17)
            
            if let key = item["key"] {
                // Switch'li hücreler
                let toggle = UISwitch()
                toggle.onTintColor = AppTheme.secondaryColor
                toggle.isOn = UserDefaults.standard.bool(forKey: key)
                toggle.tag = indexPath.row
                toggle.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
                cell.accessoryView = toggle
                cell.selectionStyle = .none
            } else if let detail = item["detail"] {
                // Detay metinli hücreler
                cell.detailTextLabel?.text = detail
                cell.detailTextLabel?.font = .systemFont(ofSize: 15)
                cell.detailTextLabel?.textColor = AppTheme.textColor.withAlphaComponent(0.7)
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = AppTheme.primaryColor.withAlphaComponent(0.3)
        
        let label = UILabel()
        label.text = settings[section]["section"] as? String
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = AppTheme.secondaryColor
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
}
