//
//  LoginScreenVC.swift
//  Pika Game Project
//
//  Created by Ali Ayçiçek on 19.07.2023.
//

import UIKit

class LoginScreenVC: UIViewController {
    
    var userName = " "
    @IBOutlet weak var gameNameLabel: UILabel!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidDisappear(_ animated: Bool) {
        print ("viewDidDisappear function called")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        print ("viewWillAppear function called")
        usernameTextField.text = " "
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print ("viewWillDisappear function called")
    }
    override func viewDidAppear(_ animated: Bool) {
        print ("viewDidAppear function called")
    }
    
    @IBAction func leaderBoardButton(_ sender: Any) {
        performSegue(withIdentifier: "rankingVC" , sender: nil)
        
        
    }
    @IBAction func settingsButton(_ sender: Any) {
        performSegue(withIdentifier: "settingsVC" , sender: nil)
    }
    
    
    @IBAction func playButton(_ sender: Any) {
        userName = usernameTextField.text!
        if usernameTextField.text == " " {
            alertFunction(titleInput: "Error!", massageInput: "Username not found!")
        }
        else {
            performSegue(withIdentifier: "nextScreenVC", sender: nil)  }
    }
    
    
    func alertFunction (titleInput: String, massageInput: String) {
        
        let alert = UIAlertController(title: titleInput , message: massageInput , preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Okey", style: UIAlertAction.Style.default) { UIAlertAction in
            print("button clicked");
        }
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "nextScreenVC" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.playerNames = userName
        }
    }
    
    
    
}
