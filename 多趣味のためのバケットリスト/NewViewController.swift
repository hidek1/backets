//
//  NewViewController.swift
//  多趣味のためのバケットリスト
//
//  Created by 吉永秀和 on 2018/07/25.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class NewViewController: UIViewController, UITextFieldDelegate ,GADBannerViewDelegate  {
    var memo: String?
    var maxId: Int { return try! Realm().objects(Hobby.self).sorted(byKeyPath: "id").last?.id ?? 0 }
    var bannerView: GADBannerView!
    
    @IBOutlet weak var addCategory: UINavigationItem!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-1673671818946203/6393002202"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        addCategory.title = NSLocalizedString("addCategory", comment: "")
        
        if let memo = self.memo {
            self.TextField.text = memo
            self.navigationItem.title = "Edit Memo"
        }
        TextField.delegate = self
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
            }
            // 表示の大元がViewControllerかNavigationControllerかで戻る場所を判断する
            if self.presentingViewController is UINavigationController {
                //  表示の大元がNavigationControllerの場合
                let nc = self.presentingViewController as! UINavigationController
                // 前画面のViewControllerを取得
                let vc = nc.topViewController as! ViewController
                // 前画面のViewControllerの値を更新
                vc.loadView()
                self.dismiss(animated: true, completion: nil)
                
            }
            self.dismiss(animated: true, completion: nil)
        } catch {
            print("エラーだよ")
        }
    }
    func textFieldShouldReturn(_ TextField: UITextField) -> Bool{
        // キーボードを閉じる
        TextField.resignFirstResponder()
        return true
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
