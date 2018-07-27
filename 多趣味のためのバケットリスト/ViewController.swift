//
//  ViewController.swift
//  多趣味のためのバケットリスト
//
//  Created by 吉永秀和 on 2018/07/25.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//

import UIKit
import RealmSwift


class Hobby: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    // idをプライマリキーに設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
class Backet: Object {
    @objc dynamic var id = 0
    @objc dynamic var backetId = 0
    @objc dynamic var name = ""
    @objc dynamic var complete = false
    // idをプライマリキーに設定
    override static func primaryKey() -> String? {
        return "backetId"
    }
}
var send = Hobby()
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var hobbys:Results<Hobby>?
    
    @IBOutlet weak var TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Realmのインスタンスを取得
        let realm = try! Realm()
//               // 全てのデータを削除
//                try! realm.write() {
//                    realm.deleteAll()
//                }
        // Realmに保存されてるDog型のオブジェクトを全て取得
        hobbys = realm.objects(Hobby.self)
        print(hobbys)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hobbys!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "titleTableViewCell")
        // セルに表示する値を設定する
        cell.textLabel!.text = "⭐︎ \(hobbys![indexPath.row].name)"
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor.clear
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        send = hobbys![indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "listView") as! UIViewController
        let naviVC = UINavigationController(rootViewController: nextVC)
        // まずセグエで接続されているUINavigationControllerを取得する
        // UINavigationControllerにぶら下がっているSecondViewControllerを取得する
//        let second = ListViewController()
        
//        second.receive = send
        // ここで遷移アニメーションを指定する
        naviVC.modalTransitionStyle = .flipHorizontal
        self.present(naviVC, animated: true, completion: nil)
//        self.performSegue(withIdentifier: "toSecond", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let realm = try! Realm()
            try! realm.write() {
                realm.delete(hobbys![indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

