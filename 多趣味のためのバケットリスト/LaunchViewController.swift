//
//  LaunchViewController.swift
//  多趣味のためのバケットリスト
//
//  Created by 吉永秀和 on 2018/07/26.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    
    @IBOutlet weak var logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        //少し縮小するアニメーション
        UIView.animate(withDuration: 0.3,
                       delay: 1.0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: { () in
                        self.logo.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { (Bool) in
            
        })
        
        //拡大させて、消えるアニメーション
        UIView.animate(withDuration: 0.2,
                       delay: 1.3,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: { () in
                        self.logo.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        self.logo.alpha = 0
        }, completion: { (Bool) in
            self.logo.removeFromSuperview()
            self.start()
        })
    }
    func start() {
        performSegue(withIdentifier: "start", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
