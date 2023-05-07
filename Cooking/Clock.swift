//
//  Clock.swift
//  Cooking
//
//  Created by Jiang LinShan on 2023/5/7.
//

import Foundation
import UIKit

enum CookingState: Int {
case Soaking,PreCooking1,PreCooking2,PostCooking
}

struct CookingTime {
    var soakingTime : Int = 1
    var pre1 : Int = 1
    var pre2 : Int = 1
    var post : Int = 1

}

let notifiCenter = UNUserNotificationCenter.current()

class Clock: NSObject ,UNUserNotificationCenterDelegate{
    var state: CookingState? {
        didSet {
            addClock(clock: clockModel[state!]!)
        }
    }
    var clockModel: Dictionary<CookingState, ClockModel> = [:]
    
    override init() {
        super.init()
        checkAut()
        notifiCenter.delegate = self
//        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        
//        var time = CookingTime(soakingTime: 1,pre1: 1,pre2: 1,post: 1)
        var time = CookingTime(soakingTime: 30,pre1: 10,pre2: 10,post: 15)

        
        let soaking = ClockModel(duration: time.soakingTime, des: "侵泡：群药和后药分开侵泡30分钟", clockAlert: "侵泡30分钟到了！")
        let pre1 = ClockModel(duration: time.pre1, des: "先煎：大火熬至水沸腾时开始计时，换小火继续。10分钟后加入后药", clockAlert: "10分钟到了，可以加入后药了！")
        let pre2 = ClockModel(duration: time.pre2, des: "先煎：加入后药后继续小火10分钟结束，倒出汤汁", clockAlert: "10分钟到了，可以倒出汤汁了！")
        let post = ClockModel(duration: time.post, des: "后煎：大火熬至水沸腾，换小火继续。15分钟完成！", clockAlert: "15分钟到了，可以倒出汤汁了！")
        
        clockModel = [.Soaking : soaking, .PreCooking1 : pre1, .PreCooking2 : pre2, .PostCooking : post]
    }
    
    fileprivate func checkAut() {
        notifiCenter.requestAuthorization(options: [.alert,.badge,.sound]) { granted, error in
            if granted {
                print("Yes!")
            } else {
                print("NO!")
            }
        }
    }
    
    fileprivate func addClock(clock:ClockModel) {
//        timer?.cancel()
//        timer?.schedule(deadline: .now() + .seconds(60*clock.duration!))
//        timer?.setEventHandler {
//            
//        }
        
        notifiCenter.removeAllDeliveredNotifications()
        
        let content = UNMutableNotificationContent()
        content.title = "时间到了！！！！！"
        content.body = clock.clockAlert!
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "clock.m4a"))
        content.userInfo = ["State":"P"]
        
        let identifer = "com.jlstmac.notificationIdentifier"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:Double(60*clock.duration!), repeats: false)
        
        print(trigger.nextTriggerDate())
        
        let request = UNNotificationRequest(identifier: identifer, content: content, trigger: trigger)
        
        
        notifiCenter.add(request) { (error) in
            if let error = error {
               // Something went wrong
               print("Error : \(error.localizedDescription)")
           } else {
               // Something went right
               print("Success")
           }
        }
//        notifiCenter.getPendingNotificationRequests { (settings) in
//            for localNotice in settings {
//                var localTrigger = localNotice.trigger as! UNTimeIntervalNotificationTrigger
//                print(localTrigger.nextTriggerDate())
//
//            }
//        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound]);
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print(response.notification.request.content.userInfo)
    }
}
