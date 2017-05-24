//
//  Model.swift
//  SinbiDemo21
//
//  Created by SUNG HAO LIN on 2017/5/24.
//  Copyright © 2017年 GanNaSong. All rights reserved.
//

import Foundation

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
