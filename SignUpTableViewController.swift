//
//  SignUpTableViewController.swift
//  SinbiDemo21
//
//  Created by SUNG HAO LIN on 2017/5/26.
//  Copyright © 2017年 GanNaSong. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import FirebaseStorage
class SignUpTableViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userAccountTF: UITextField!
    @IBOutlet weak var userPassTF: UITextField!
    
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser!.uid
    let storage = Storage.storage().reference()
    
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
            userImage.contentMode = .scaleAspectFill
            userImage.layer.cornerRadius = userImage.frame.width / 2
            userImage.clipsToBounds = true
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    
    //註冊
    @IBAction func signUpButton(_ sender: UIButton) {
        SVProgressHUD.show(withStatus: "會員資料註冊中")
        
        guard userImage.image != nil && userNameTF.text != "" && userAccountTF.text != "" && userPassTF.text != "" else {
            present(Library.alert(title: "註冊錯誤", message: "會員資料不得為空白"), animated: true, completion: nil)
            SVProgressHUD.dismiss()
            return
        }
        
        //註冊會員
        Auth.auth().createUser(withEmail: userAccountTF.text!, password: userPassTF.text!) { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
                //將資料存到database
                let VipID = self.ref.child("VIPUser").child(self.uid)
                VipID.setValue(["Name": self.userNameTF.text!, "Email": self.userAccountTF.text!, "PassWord": self.userPassTF.text!], withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                })
        }
        //照片上傳storage
        let imageData = UIImageJPEGRepresentation(userImage.image!, 0.5)
        let tempData = imageData as! NSData
        let imageLength = tempData.length
        guard imageLength < 1 * 1024 * 1024 else {
            present(Library.alert(message: "照片檔案請勿超過1M"), animated: true, completion: nil)
            SVProgressHUD.dismiss()
            return
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        storage.child("VipImage/\(uid).jpg").putData(imageData!, metadata: metadata) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            self.userImage.image = UIImage(named: "photoalbum@2x 拷貝")
            self.userNameTF.text = ""
            self.userAccountTF.text = ""
            self.userPassTF.text = ""
            SVProgressHUD.show(withStatus: "註冊成功，請重新登入")
            SVProgressHUD.dismiss(withDelay: 1)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
        
    //BackButton
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //
}
