//
//  DieView.swift
//  Pallankhuzi
//
//  Created by Namit on 6/25/16.
//  Copyright © 2016 Namit. All rights reserved.
//

import UIKit

class DieView: UIView {
    
    @IBOutlet weak var dieImage:UIImageView!
    
    func showDie(num:Int){
        let fileName = String(format: "dice%d",num)
        dieImage.image = UIImage(named: fileName)
    }
    
    func rollDie(num:Int){
        startAnimation()
        let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {[weak self] in
            if let strongSelf = self{
                strongSelf.stopAnimation()
                strongSelf.showDie(num)
            }
            })
    }
    
    func startAnimation(){
        var animationImages = [UIImage]()
        for index in 1...6{
            animationImages.append(UIImage(named:String(format: "dice%d",index))!)
        }
        dieImage.animationImages = animationImages
        dieImage.animationDuration = 1.0
        dieImage.startAnimating()
    }
    
    func stopAnimation(){
        dieImage.stopAnimating()
    }
}

