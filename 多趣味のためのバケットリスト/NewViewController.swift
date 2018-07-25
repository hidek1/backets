//
//  NewViewController.swift
//  多趣味のためのバケットリスト
//
//  Created by 吉永秀和 on 2018/07/25.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//

import UIKit
import RealmSwift

class NewViewController: UIViewController {
    var send = Hobby()
    var memo: String?
    var maxId: Int { return try! Realm().objects(Hobby.self).sorted(byKeyPath: "id").last?.id ?? 0 }
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let memo = self.memo {
            self.TextField.text = memo
            self.navigationItem.title = "Edit Memo"
        }
        self.updateSaveButtonState()
        // Do any additional setup after loading the view.
    }
    
    private func updateSaveButtonState() {
        let memo = self.TextField.text ?? ""
        self.saveButton.isEnabled = !memo.isEmpty
    }
    
    
    @IBAction func textChanged(_ sender: Any) {
        self.updateSaveButtonState()
    }
    
    @IBAction func SaveHobby(_ sender: Any) {
        guard let Text = TextField.text, !Text.isEmpty else { return }
        //Realmのインスタンス取得
        do {
            let realm = try Realm()
            let hobby = Hobby() //Habitモデルのオブジェクトを取得
            hobby.id = maxId + 1
            hobby.name = Text
            try! realm.write {
                realm.add(hobby)
                print("成功だよ", hobby)
                send = hobby
            }
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("エラーだよ")
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
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
