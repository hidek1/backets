//
//  AppDelegate.swift
//  多趣味のためのバケットリスト
//
//  Created by 吉永秀和 on 2018/07/25.
//  Copyright © 2018年 吉永秀和. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-1673671818946203~1523818904")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        var lists:Results<Backet>?
        var ntDates:[Date] = []
        // Realmのインスタンスを取得
        let realm = try! Realm()
        // Realmに保存されてるDog型のオブジェクトを全て取得
        lists = realm.objects(Backet.self)
        let limitDates = ["one day before","one week before", "one month before"]
        for i in 0..<lists!.count {
            if lists![i].nTime == limitDates[0]{
                ntDates.append(lists![i].deadLine - 60*60*24)
            } else if lists![i].nTime == limitDates[1] {
                ntDates.append(lists![i].deadLine - 60*60*24*7)
            } else if lists![i].nTime == limitDates[2] {
                ntDates.append(lists![i].deadLine - 60*60*24*30)
            }
       
            let today : Date = Date()
            print("期限", ntDates)
            print(today)
            //　通知設定に必要なクラスをインスタンス化
            let trigger: UNNotificationTrigger
            let content = UNMutableNotificationContent()
            
            // トリガー設定
            let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: ntDates[i])
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            // 通知内容の設定
            content.title = ""
            content.body = "Today is \(lists![i].nTime as! String) \(lists![i].name as! String)'s deadline!"
            content.sound = UNNotificationSound.default()
            
            // 通知スタイルを指定
            let request = UNNotificationRequest(identifier: "uuid", content: content, trigger: trigger)
            // 通知をセット
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

