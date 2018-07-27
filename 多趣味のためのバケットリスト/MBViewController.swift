//
//  MBViewController.swift
//  多趣味のためのバケットリスト
//
//  Created by 吉永秀和 on 2018/07/26.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//

import UIKit
import RealmSwift

class MBViewController: UIViewController {

    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var maxId: Int { return try! Realm().objects(Backet.self).sorted(byKeyPath: "backetId").last?.backetId ?? 0 }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateSaveButtonState()

        // Do any additional setup after loading the view.
    }

 
    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    private func updateSaveButtonState() {
        let memo = self.TextField.text ?? ""
        self.saveButton.isEnabled = !memo.isEmpty
    }
    @IBAction func textChanged(_ sender: Any) {
        self.updateSaveButtonState()
    }
    
    @IBAction func addBacket(_ sender: Any) {
        guard let Text = TextField.text, !Text.isEmpty else { return }
        //Realmのインスタンス取得
        do {
            let realm = try Realm()
            let backet = Backet() //Habitモデルのオブジェクトを取得
            backet.id = send.id
            backet.name = Text
            backet.backetId = maxId + 1
            backet.complete = false
            try! realm.write {
                realm.add(backet)
                print("成功だよ", backet)
            }
            // 表示の大元がViewControllerかNavigationControllerかで戻る場所を判断する
            if self.presentingViewController is UINavigationController {
                //  表示の大元がNavigationControllerの場合
                let nc = self.presentingViewController as! UINavigationController
                // 前画面のViewControllerを取得
                let vc = nc.topViewController as! ListViewController
                // 前画面のViewControllerの値を更新
                vc.loadView()
                self.dismiss(animated: true, completion: nil)
                
            }
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("エラーだよ")
        }
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
