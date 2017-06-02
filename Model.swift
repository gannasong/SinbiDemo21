//
//  Model.swift
//  SinbiDemo21
//
//  Created by SUNG HAO LIN on 2017/5/24.
//  Copyright © 2017年 GanNaSong. All rights reserved.
//

import UIKit
//導覽頁面Model
class IntroPage {
    var head = ""
    var message = ""
    var image = ""
    
    init(head: String, message: String, image: String) {
        self.head = head
        self.message = message
        self.image = image
    }
}


class Library {
    static func alert(title: String = "錯誤", message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .cancel, handler: nil))
        return alert
    }
    //測試網路
    //沒有網路時rawValue會是0
    static func checkInterNet() -> Bool {
        let rechability = Reachability(hostName: "https://www.apple.com/tw/")
        if rechability?.currentReachabilityStatus().rawValue == 0 {
            return false
        } else {
            return true
        }
    }
}



var isFBLogin = false
var fbUsers: FBUsers?

class FBUsers {
    
    var name: String?
    var email: String?
    var pictureURL: URL?
    
    init(name: String, email: String, pictureURL: URL) {
        self.name = name
        self.email = email
        self.pictureURL = pictureURL
    }
    
}

















