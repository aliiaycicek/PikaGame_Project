//
//  RankingVC.swift
//  Pika Game Project
//
//  Created by Ali Ayçiçek on 19.07.2023.
//

import UIKit
//import CoreData

class RankingVC: UIViewController {
    
    
    var playerNames = [String]()
    
    @IBOutlet weak var rankingLable: UILabel!
    
    @IBOutlet weak var rankingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 10
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell()
            var content = cell.defaultContentConfiguration()
            content.text = playerNames[indexPath.row]
            cell.contentConfiguration = content
            return cell
        }
    
}
