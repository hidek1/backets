//
//  ListViewController.swift
//  多趣味のためのバケットリスト
//
//  Created by 吉永秀和 on 2018/07/25.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds
class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,GADBannerViewDelegate {
    @IBOutlet weak var TableView: UITableView!
    var lists:Results<Backet>?
//    var receive = Hobby()
    var lt:Results<Backet>? = nil
    var Ct:Results<Backet>? = nil
    var ntDates:[Date] = []
    var twoDimArray = [Results<Backet>?]()
    var mySections = [String]()
    var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-1673671818946203/6393002202"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        // Do any additional setup after loading the view.
        self.title = send.name
        mySections = [NSLocalizedString("NA", comment: ""), NSLocalizedString("A", comment: "")]
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
    
    
    @IBAction func info(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "info") as! UIViewController
        let naviVC = UINavigationController(rootViewController: VC)
        naviVC.modalTransitionStyle = .flipHorizontal
        self.present(naviVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
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
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "listTableViewCell")
//        let cell = tableView.dequeueReusableCell(withIdentifier: "listTableViewCell", for: indexPath)
        if indexPath.section == 0 {
            let limitDates = ["one day before","one week before", "one month before"]
            if twoDimArray[indexPath.section]?[indexPath.row].nTime == limitDates[0]{
                ntDates.append((twoDimArray[indexPath.section]?[indexPath.row].deadLine)! - 60*60*24)
            } else if twoDimArray[indexPath.section]?[indexPath.row].nTime == limitDates[1] {
                ntDates.append((twoDimArray[indexPath.section]?[indexPath.row].deadLine)! - 60*60*24*7)
            } else if twoDimArray[indexPath.section]?[indexPath.row].nTime == limitDates[2] {
                ntDates.append((twoDimArray[indexPath.section]?[indexPath.row].deadLine)! - 60*60*24*30)
            }
            cell.textLabel?.text = twoDimArray[indexPath.section]?[indexPath.row].name
            let today : Date = Date()
            print("期限", ntDates)
            print(today)
            if today.compare((twoDimArray[indexPath.section]?[indexPath.row].deadLine)!) == .orderedDescending  {
                cell.textLabel?.textColor = .red
                cell.detailTextLabel?.textColor = UIColor.red
            } else if today.compare(ntDates[indexPath.row]) == .orderedDescending {
                cell.textLabel?.textColor = .yellow
                cell.detailTextLabel?.textColor = UIColor.yellow
            } else {
                cell.textLabel?.textColor = .white
                cell.detailTextLabel?.textColor = UIColor.white
            }
        } else {
            cell.textLabel?.text = "✔︎ \(twoDimArray[indexPath.section]?[indexPath.row].name as! String)"
            cell.textLabel?.textColor = .white
            cell.detailTextLabel?.textColor = UIColor.white
        }
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd"
        cell.detailTextLabel?.text = format.string(from: (twoDimArray[indexPath.section]?[indexPath.row].deadLine)!)
        cell.backgroundColor = UIColor.clear
//        if indexPath.section == 1 {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
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
            ntDates.remove(at: indexPath.row)
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
