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
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var hobbys:Results<Hobby>?
    var send = Hobby()
    @IBOutlet weak var TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Realmのインスタンスを取得
        let realm = try! Realm()
//                // 全てのデータを削除
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
        cell.textLabel!.text = "\(hobbys![indexPath.row].name)"
        cell.detailTextLabel?.text = "日目"
        cell.detailTextLabel?.textColor = UIColor.black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        send = hobbys![indexPath.row]
        self.performSegue(withIdentifier: "toSecond", sender: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

