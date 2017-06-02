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
import Firebase

class SideMenuTableViewController: UITableViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userImage.layer.cornerRadius = userImage.frame.width / 2
        userImage.clipsToBounds = true
        userImage.contentMode = .scaleAspectFill
        
        isFBLogin = false
        isGoogleLogin = false
        checkWhoLogin()
    }

    //確認從哪個管道進來
    func checkWhoLogin() {
        //let currentID = Auth.auth().currentUser?.uid
        
        if let user = Auth.auth().currentUser {
            //可以判斷由哪個管道登入
            for profile in user.providerData {
                print("profile = \(profile)")
                let providerId = profile.providerID
                print("userproviderId = \(providerId)")
                if providerId != "facebook.com" && providerId != "google.com" {
                    //讀取資料未打func
                    ///////////////////////////
                    loadProfile()
                } else {
                    guard let name = profile.displayName else { return }
                    guard let email = profile.email else { return }
                    guard let photoUrl = profile.photoURL else { return }
                    if providerId == "facebook.com" {
                        print("從FB管道進入")
                        isFBLogin = true
                        fbUsers = FBUsers(name: name, email: email, pictureURL: photoUrl)
                    } else {
                        print("從google管道進入")
                        isGoogleLogin = true
                        googleUsers = GoogleUsers(name: name, email: email, pictureURL: photoUrl)
                    }
                }
            }
        }
    }
    
    //讀取側邊欄資料
    func loadProfile() {
        
        let currentID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()

        ref.child("VIPUser").child(currentID!).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            print("snapshot==\(snapshot)")
            let snap = snapshot.value as! [String:String]
            var userName = snap["Name"]
            var userImageURL = snap["avatar"]
            print("userImageURL = \(String(describing: userImageURL))")
            if userImageURL == nil {
                userImageURL = "https://firebasestorage.googleapis.com/v0/b/sinbidemo21.appspot.com/o/VipImage%2F1BtbzW2OebQbNtS8YWcfAXvInr22.jpg?alt=media&token=873eef61-3070-43e3-afbf-5abb2c902e94"
            }
            
            if userName == nil {
                userName = "未命名"
            }
            sideNameInfo = userName
            
            let storage = Storage.storage()
            let imageURL = storage.reference(forURL: userImageURL!)
            
            imageURL.downloadURL(completion: { (url, error) in
                if error != nil {
                    print("downloadURL Error:\(String(describing: error?.localizedDescription))")
                }
                
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error ?? "")
                    }
                    
                    guard let imageData = UIImage(data: data!) else { return }
                    sideImageInfo = imageData
                }).resume()
            })
        }
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //如果是fb登入才去載fb照片
        if isFBLogin {
            userName.text = fbUsers?.name
            userImage.image = try! UIImage(data: Data(contentsOf: (fbUsers?.pictureURL)!))
        } else if isGoogleLogin {
            userName.text = googleUsers?.name
            userImage.image = try! UIImage(data: Data(contentsOf: (googleUsers?.pictureURL)!))
        }
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
            try! Auth.auth().signOut()
           
            isFBLogin = false
            isGoogleLogin = false
            
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
