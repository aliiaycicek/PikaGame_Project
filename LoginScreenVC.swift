//
//  LoginScreenVC.swift
//  Pika Game Project
//
//  Created by Ali Ayçiçek on 19.07.2023.
//

import UIKit
import AVFoundation

class LoginScreenVC: UIViewController {

    var audioPlayer: AVAudioPlayer?
    var userName = ""
    var selectedDifficulty = "Easy"
    
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func leaderBoardButton(_ sender: Any) {
        playSound()
        performSegue(withIdentifier: "rankingVC", sender: nil)
    }
    
    @IBAction func settingsButton(_ sender: Any) {
        playSound()
        performSegue(withIdentifier: "settingsVC", sender: nil)
    }
    
    @IBAction func playButton(_ sender: Any) {
        playSound()
        userName = usernameTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        
        if userName.isEmpty {
            alertFunction(titleInput: "Error!", messageInput: "Username not found!")
        } else {
            // Zorluk seçimi için alert
            let alert = UIAlertController(title: "Select Difficulty", message: "Please select the difficulty level.", preferredStyle: .alert)
            
            let easyAction = UIAlertAction(title: "Easy", style: .default) { _ in
                self.selectedDifficulty = "Easy"
                self.performSegue(withIdentifier: "nextScreenVC", sender: nil)
            }
            
            let hardAction = UIAlertAction(title: "Hard", style: .default) { _ in
                self.selectedDifficulty = "Hard"
                self.performSegue(withIdentifier: "nextScreenVC", sender: nil)
            }
            
            alert.addAction(easyAction)
            alert.addAction(hardAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func alertFunction(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextScreenVC" {
            let destinationVC = segue.destination as! ViewController
            destinationVC.playerNames = userName
            destinationVC.selectedDifficulty = selectedDifficulty
        }
    }
    
    func playSound() {
        if let soundURL = Bundle.main.url(forResource: "pikaeffect", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.play()
            } catch {
                print("Error: Couldn't play sound file.")
            }
        }
    }
}
