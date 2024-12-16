//
//  SettingVC.swift
//  Pika Game Project
//
//  Created by Ali Ayçiçek on 19.10.2024.
//

import UIKit

class SettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func backButton(_ sender: Any) {
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
    


    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
