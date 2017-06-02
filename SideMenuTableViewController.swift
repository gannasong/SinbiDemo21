//
//  SideMenuTableViewController.swift
//  SinbiDemo21
//
//  Created by SUNG HAO LIN on 2017/6/2.
//  Copyright © 2017年 GanNaSong. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth
import SVProgressHUD

class SideMenuTableViewController: UITableViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.clipsToBounds = true
        userImage.contentMode = .scaleAspectFill
        
    }

    //回主頁
    @IBAction func backMainPage(_ sender: UIButton) {
    }
    
    
    //聯絡我們
    @IBAction func conectUs(_ sender: UIButton) {
    }
    
    //系統設定
    @IBAction func settingInfo(_ sender: UIButton) {
    }
    
    
    //會員登出
    @IBAction func logoutButton(_ sender: UIButton) {
        
        let exitAlert = UIAlertController(title: "確認登出", message: "您是否要登出？", preferredStyle: .alert)
        //轉場動作要寫在action裡面，寫在其他地方不會有效果
        let okAction = UIAlertAction(title: "確定", style: .cancel) { _ in
            FBSDKLoginManager().logOut()
            GIDSignIn.sharedInstance().signOut()
            do {
                try Auth.auth().signOut()
            } catch {
                print("error")
            }
            
            self.dismiss(animated: true, completion: nil)
            SVProgressHUD.showSuccess(withStatus: "登出成功")
            SVProgressHUD.dismiss(withDelay: 1.0)

        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .default, handler: nil)
        exitAlert.addAction(okAction)
        exitAlert.addAction(cancelAction)
        present(exitAlert, animated: true, completion: nil)
        
    }
    
    

   //
}
