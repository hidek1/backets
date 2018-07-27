//
//  ListViewController.swift
//  多趣味のためのバケットリスト
//
//  Created by 吉永秀和 on 2018/07/25.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var TableView: UITableView!
    var lists:Results<Backet>?
//    var receive = Hobby()
    var lt:Results<Backet>? = nil
    var Ct:Results<Backet>? = nil
    
    var twoDimArray = [Results<Backet>?]()
    var mySections = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mySections = ["未達成", "達成済み"]
        if lt == nil && Ct == nil {
        // Realmのインスタンスを取得
        let realm = try! Realm()
        // Realmに保存されてるDog型のオブジェクトを全て取得
        lists = realm.objects(Backet.self)
        print(lists)
        print("yes", send)
//            lt = lists?.filter { $0.id == send.id && $0.complete == false }
            lt = lists?.filter("id == %@", send.id ?? NSNull()).filter("complete == false")
            Ct = lists?.filter("id == %@", send.id ?? NSNull()).filter("complete == true")
            twoDimArray.append(lt)
            twoDimArray.append(Ct)
            print("は",Ct)
            print("ひ",lt)
            print("ふ", twoDimArray)
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackButton(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //セクションの数を返す.
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mySections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twoDimArray[section]!.count
    }
    //セクションのタイトルを返す.
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mySections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listTableViewCell", for: indexPath)
        cell.textLabel?.text = twoDimArray[indexPath.section]?[indexPath.row].name
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor.clear
        if indexPath.section == 1 {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    // セルが選択された時に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        cell?.selectionStyle = .none
        if indexPath.section == 1 {
            // Realmのインスタンスを取得
            let realm = try! Realm()
//            let bkt = realm.objects(Backet.self).filter("backetId == %@", twoDimArray[indexPath.section]?[indexPath.row].backetId ?? NSNull()).first
            try! realm.write {
                twoDimArray[indexPath.section]?[indexPath.row].complete = false
            }
            updateArray()
            tableView.reloadData()
        } else {
            // Realmのインスタンスを取得
            let realm = try! Realm()
//            let bkt = realm.objects(Backet.self).filter("backetId == %@", twoDimArray[indexPath.section]?[indexPath.row].backetId ?? NSNull()).first
            try! realm.write {
                twoDimArray[indexPath.section]?[indexPath.row].complete = true
            }
            print(twoDimArray)
            updateArray()
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let realm = try! Realm()
            try! realm.write() {
                realm.delete((twoDimArray[indexPath.section]?[indexPath.row])!)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func updateArray() {
        // Realmのインスタンスを取得
        let realm = try! Realm()
        // Realmに保存されてるDog型のオブジェクトを全て取得
        lists = realm.objects(Backet.self)
        lt = lists?.filter("id == %@", send.id ?? NSNull()).filter("complete == false")
        Ct = lists?.filter("id == %@", send.id ?? NSNull()).filter("complete == true")
        twoDimArray[0] = lt
        twoDimArray[1] = Ct
        print(lt)
        print(Ct)
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
