//
//  LoginViewController.swift
//  SinbiDemo21
//
//  Created by SUNG HAO LIN on 2017/5/24.
//  Copyright © 2017年 GanNaSong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import SVProgressHUD

class LoginViewController: UIViewController,UITextFieldDelegate, GIDSignInUIDelegate, GIDSignInDelegate{

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    //要在configure初始化完才能叫下面
    lazy var ref = Database.database().reference()
    lazy var uid = Auth.auth().currentUser!.uid
    lazy var storage = Storage.storage().reference()
    
    //存放FB Google個資
    var FBdata: [String:Any]?
    var Googledata: [String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        getUserDefaults()
        tFDelegate()
        
        
        //Google登入要加入步驟
        GIDSignIn.sharedInstance().clientID = "837636834311-piegf21051rhqbuohahovguhik6bpcvu.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }

    
    
    func tFDelegate() {
        //委派鍵盤縮回
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.clearButtonMode = .whileEditing
        passwordTextField.clearButtonMode = .whileEditing
    }
    
    func getUserDefaults() {
        //userDefault取使用者資料
        if let userEmail = UserDefaults.standard.object(forKey: "UserEmail") {
            emailTextField.text = userEmail as? String
        }
        if let userPass = UserDefaults.standard.object(forKey: "UserPass") {
            passwordTextField.text = userPass as? String
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
            return false
        } else {
            passwordTextField.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //Firbase登入
    @IBAction func loginButton(_ sender: UIButton) {
        SVProgressHUD.show(withStatus: "登入中")
        //網路測試
        if Library.checkInterNet() == false {
            present(Library.alert(message: "網路異常"), animated: true, completion: nil)
            SVProgressHUD.dismiss()
        }
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            present(Library.alert(message: "請確實輸入帳號及密碼"), animated: true, completion: nil)
        } else {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    //userDefauts-記下使用者的帳號密碼
                    UserDefaults.standard.set(self.emailTextField.text, forKey: "UserEmail")
                    UserDefaults.standard.set(self.passwordTextField.text, forKey: "UserPass")
                    //同步強制存檔
                    UserDefaults.standard.synchronize()

                    
                    self.performSegue(withIdentifier: "toMainVC", sender: self)
                    SVProgressHUD.showSuccess(withStatus: "登入成功")
                    SVProgressHUD.dismiss(withDelay: 1.5)
                }
            })
        }
    }
    
    //忘記密碼
    @IBAction func getPwButton(_ sender: UIButton) {
        guard emailTextField.text != "" else {
           present(Library.alert(message: "請輸入驗證信箱"), animated: true, completion: nil)
            return
        }
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                self.present(Library.alert(title: "", message: "請至指定信箱重設密碼"), animated: true, completion: nil)
            }
        }
    }
    
    
    //轉場註冊頁
    @IBAction func SignUpButton(_ sender: UIButton) {
    }
    
    
    //FB登入
    @IBAction func fbLoginButton(_ sender: UIButton) {
        
        //網路測試
        if Library.checkInterNet() == false {
            present(Library.alert(message: "網路狀況異常"), animated: true, completion: nil)
            SVProgressHUD.dismiss()
        }
        
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                //沒拿到
                print("Failed to get access token")
                return
            }
            
           let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            //login by Firebase-簡化
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                
                if  error != nil {
                    print(error!.localizedDescription)
                    self.present(Library.alert(message: "登入錯誤"), animated: true, completion: nil)
                    return
                } else {
                    print("FB登入成功")
                }
                
                //將fb資料存入firebase
                if let data = self.FBdata {
                    let FbID = self.ref.child("FBUser").child(self.uid)
                    FbID.setValue(data)
                }
            })
            self.getFbUserInfo()
            
            //轉場
            SVProgressHUD.showSuccess(withStatus: "登入成功")
            SVProgressHUD.dismiss(withDelay: 1.5)
            self.performSegue(withIdentifier: "toMainVC", sender: self)
        }
    }
    
    //Fb獲取使用者資料
    func getFbUserInfo() {
        let parameters = ["fields":"email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            if error != nil {
                print(error!.localizedDescription)
                SVProgressHUD.dismiss()
            }
         
            if let results = result as? NSDictionary {
                guard let email = results["email"] else { return }
                print("email = \(email)")
                
                guard let firstName = results["first_name"] as? String, let lastName = results["last_name"] as? String else { return }
                let name = firstName + " " + lastName
                print("name = \(name)")
                
                guard let picture = results["picture"] as? NSDictionary,
                       let data = picture["data"] as? NSDictionary,
                    let url = data["url"] as? String else { return }
                print("URL = \(url)")
                
                //把FB資料存在Firebase裡
                self.FBdata = ["email":email, "password":"xxxxxx", "name":name, "avatar":url]
            }
        }
        
        
    }
    
    
    
    //Google登入
    @IBAction func GoogleLoginButton(_ sender: UIButton) {
       
        //網路測試
        if Library.checkInterNet() == false {
            present(Library.alert(message: "網路狀況異常"), animated: true, completion: nil)
            SVProgressHUD.dismiss()
        }
        SVProgressHUD.show(withStatus: "登入中")
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
        
        //
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if  error != nil {
                print(error!.localizedDescription)
                self.present(Library.alert(message: "登入錯誤"), animated: true, completion: nil)
                return
            } else {
                print("Google登入成功")
            }
        })
        //轉場
        SVProgressHUD.showSuccess(withStatus: "登入成功")
        SVProgressHUD.dismiss(withDelay: 1.5)
        self.performSegue(withIdentifier: "toMainVC", sender: self)

    }

    

  //
}
