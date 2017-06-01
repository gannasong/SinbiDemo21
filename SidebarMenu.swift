//
//  SidebarMenu.swift
//  SinbiDemo21
//
//  Created by SUNG HAO LIN on 2017/6/2.
//  Copyright © 2017年 GanNaSong. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addSideBarMenu(leftMenuButton: UIBarButtonItem?) {
        if revealViewController() != nil {
            if let menuButton = leftMenuButton {
                revealViewController().rearViewRevealWidth = 180
                menuButton.target = revealViewController()
                menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            }
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}

