//
//  SignUpTableViewController.swift
//  SinbiDemo21
//
//  Created by SUNG HAO LIN on 2017/5/26.
//  Copyright © 2017年 GanNaSong. All rights reserved.
//

import UIKit

class SignUpTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userAccountTF: UITextField!
    @IBOutlet weak var userPassTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView底下隔線消失
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        userTFDelegate()
        userTFClean()
    }

    
    func userTFClean() {
        userNameTF.clearButtonMode = .whileEditing
        userAccountTF.clearButtonMode = .whileEditing
        userPassTF.clearButtonMode = .whileEditing
    }
    
    func userTFDelegate() {
        userNameTF.delegate = self
        userAccountTF.delegate = self
        userPassTF.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1:
            userAccountTF.becomeFirstResponder()    //跳到AcTF
        case 2:
            userPassTF.becomeFirstResponder()       //跳到PaTF
        case 3:
            userPassTF.resignFirstResponder()       //取消游標
        default:
            break
        }
        return true
    }
    
    //選取照片庫(記得plist要增加使用權限)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    //從照片庫選取照片後在image顯示
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userImage.image = selectedImage
            userImage.contentMode = .scaleAspectFit
            userImage.layer.cornerRadius = userImage.frame.width / 2
            userImage.clipsToBounds = true
            
            dismiss(animated: true, completion: nil)
        }
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
