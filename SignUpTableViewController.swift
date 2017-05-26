//
//  SignUpTableViewController.swift
//  SinbiDemo21
//
//  Created by SUNG HAO LIN on 2017/5/26.
//  Copyright © 2017年 GanNaSong. All rights reserved.
//

import UIKit

class SignUpTableViewController: UITableViewController {

    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userAccountTF: UITextField!
    @IBOutlet weak var userPassTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTF.clearButtonMode = .whileEditing
        userAccountTF.clearButtonMode = .whileEditing
        userPassTF.clearButtonMode = .whileEditing
        
    }

    
    //註冊
    @IBAction func signUpButton(_ sender: UIButton) {
    }
    
    
    
        
    //BackButton
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //
}
