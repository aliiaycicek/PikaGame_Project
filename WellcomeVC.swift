//
//  WellcomeVC.swift
//  Pika Game Project
//
//  Created by Ali Ayçiçek on 31.10.2023.
//

import UIKit

class WellcomeVC: UIViewController {
    
    @IBOutlet weak var Logo: UIImageView!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

     
        view.addSubview(Logo)
        DispatchQueue.main.asyncAfter(deadline: .now()+4.75) {
            
            self.performSegue(withIdentifier: "loginScreen", sender: self)
            }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.animation()
            }
        }
    func animation() {
        
        
        UIView.animate(withDuration: 1) {
            
            
            let size = self.view.frame.size.width * 3
            let xpastion = size - self.view.frame.width
            let ypastion = self.view.frame.height - size
          
            self.Logo.frame = CGRect(x: -(xpastion/1.75), y: ypastion/1.5, width:size , height: size)
            
            self.Logo.alpha = 0
            
        }
        
        
    }
}
