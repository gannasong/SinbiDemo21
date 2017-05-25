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

class LoginViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //委派鍵盤縮回
        emailTextField.delegate = self
        passwordTextField.delegate = self

        //userDefault取使用者資料
        if let userEmail = UserDefaults.standard.object(forKey: "UserEmail") {
            emailTextField.text = userEmail as? String
        }
        
        if let userPass = UserDefaults.standard.object(forKey: "UserPass") {
            passwordTextField.text = userPass as? String
        }
        
        emailTextField.clearButtonMode = .whileEditing
        passwordTextField.clearButtonMode = .whileEditing
        
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
        if emailTextField.text == "" || passwordTextField.text == "" {
            present(Library.alert(message: "請確實輸入帳號及密碼", needButton: true), animated: true, completion: nil)
        } else {
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    //userDefauts-記下使用者的帳號密碼
                    UserDefaults.standard.set(self.emailTextField.text, forKey: "UserEmail")
                    UserDefaults.standard.set(self.passwordTextField.text, forKey: "UserPass")
                    //同步強制存檔
                    UserDefaults.standard.synchronize()
                    
                    self.present(Library.alert(title: "登入成功", message: "審美會員你好!!", needButton: true), animated: true, completion: {
                       //寫轉場
                        print("登入成功")
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                    })
                }
            })
        }
    }
    
    //忘記密碼
    @IBAction func getPwButton(_ sender: UIButton) {
    }
    
    
    //轉場註冊頁
    @IBAction func SignUpButton(_ sender: UIButton) {
    }
    
    
    //FB登入
    @IBAction func fbLoginButton(_ sender: UIButton) {
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
            
           let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            //login by Firebase
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                if  error != nil {
                    print(error?.localizedDescription)
                    self.present(Library.alert(message: "登入錯誤", needButton: true), animated: true, completion: nil)
                    return
                } else {
                    print("FB登入成功")
                }
            })
            //
            
            
        }
        
    }
    
    //Google登入
    @IBAction func GoogleLoginButton(_ sender: UIButton) {
        
        
    }
    
    
    

  //
}
