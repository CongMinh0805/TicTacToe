//
//  ViewController.swift
//  TicTacToe
//
//  Created by Minh Dang Cong on 30/08/2023.
//

import UIKit

class ViewController: UIViewController {
    
    var imageView: UIImageView = {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.image = UIImage(named: "LaunchScreen")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 13) {
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.animation()
        }
    }
    
    func animation(){
        UIView.animate(withDuration: 1) {
            let size = self.view.frame.size.width * 2
            let xposition = size - self.view.frame.width
            let yposition = self.view.frame.height - size
            
            self.imageView.frame = CGRect(x: -(xposition/2), y: yposition/2, width: size, height: size)
            self.imageView.alpha = 0
        }
    }
}
