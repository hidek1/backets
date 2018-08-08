//
//  MBViewController.swift
//  多趣味のためのバケットリスト
//
//  Created by 吉永秀和 on 2018/07/26.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications
import GoogleMobileAds

class MBViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource , UNUserNotificationCenterDelegate, UITextFieldDelegate ,GADBannerViewDelegate, GADInterstitialDelegate {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var DatePicker: UIDatePicker!
    
    
    @IBOutlet weak var fTitle: UILabel!
    @IBOutlet weak var Deadline: UILabel!
    @IBOutlet weak var Notification: UILabel!
    
    var limitDates = [NSLocalizedString("one day before", comment: ""),NSLocalizedString("one week before", comment: ""), NSLocalizedString("one month before", comment: "")]
    var maxId: Int { return try! Realm().objects(Backet.self).sorted(byKeyPath: "backetId").last?.backetId ?? 0 }
    var notiTime = "one day before"
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fTitle.text = NSLocalizedString("Title", comment: "")
        Deadline.text = NSLocalizedString("Deadline", comment: "")
        Notification.text = NSLocalizedString("Notification", comment: "")
        interstitial = createAndLoadInterstitial()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-1673671818946203/6393002202"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        self.updateSaveButtonState()
        pickerView.delegate = self
        pickerView.dataSource = self
        TextField.delegate = self
        DatePicker.setValue(UIColor.white, forKey: "textColor")

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
    func textFieldShouldReturn(_ TextField: UITextField) -> Bool{
        // キーボードを閉じる
        TextField.resignFirstResponder()
        return true
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
            backet.deadLine = DatePicker.date
            backet.nTime = notiTime
            try! realm.write {
                realm.add(backet)
                print("成功だよ", backet)
            }
            if #available(iOS 10.0, *) {
                // iOS 10
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                    if error != nil {
                        return
                    }
                    
                    if granted {
                        print("通知許可")
                        
                        let center = UNUserNotificationCenter.current()
                        center.delegate = self
                        
                    } else {
                        print("通知拒否")
                    }
                })
                
            } else {
                // iOS 9以下
                let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
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
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
                self.dismiss(animated: true, completion: nil)
            }
        } catch {
            print("エラーだよ")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createAndLoadInterstitial() -> GADInterstitial {
        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-1673671818946203/1219608713")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        self.dismiss(animated: true, completion: nil)
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
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return limitDates.count
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 80))
        label.textAlignment = .center
        label.textColor = .white
        label.text = limitDates[row]
        label.font = label.font.withSize(22)
        return label
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return limitDates[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(limitDates[row])
        notiTime = limitDates[row]
        
    }
    /* delegate method ⑧*/
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
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
