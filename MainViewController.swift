//
//  MainViewController.swift
//  SinbiDemo21
//
//  Created by SUNG HAO LIN on 2017/5/28.
//  Copyright © 2017年 GanNaSong. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    
    @IBOutlet weak var whiteLine: UIView!
    
    let menuIcon = ["new", "home", "message"]
    var isWhiteIcon: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whiteLine.frame.size = CGSize(width: UIScreen.main.bounds.width/3, height: 5.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    //設定menucollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuIcon.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as! MainCollectionViewCell
        //將icon顏色變成預設顏色
        cell.iconImage.image = UIImage(named: menuIcon[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        if indexPath.item == 0 {
            cell.iconImage.tintColor = UIColor.white
        } else {
            cell.iconImage.tintColor = UIColor.darkGray
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width/3, height: collectionView.frame.height)
    }
    
   
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MainCollectionViewCell
        //
        
        let cell0 = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! MainCollectionViewCell
        cell0.iconImage.tintColor = UIColor.white
        
        switch indexPath.item {
        case 0:
            print(indexPath.item)

            UIView.animate(withDuration: 0.3, animations: {
                self.whiteLine.frame.origin.x = 0
                
                let cell1 = collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as! MainCollectionViewCell
                cell1.iconImage.tintColor = UIColor.darkGray
                let cell2 = collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as! MainCollectionViewCell
                cell2.iconImage.tintColor = UIColor.darkGray
                
                cell.iconImage.tintColor = UIColor.white
            })
        case 1:
            print(indexPath.item)
            //超笨
            let cell0 = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! MainCollectionViewCell
            cell0.iconImage.tintColor = UIColor.darkGray
            let cell2 = collectionView.cellForItem(at: IndexPath(item: 2, section: 0)) as! MainCollectionViewCell
            cell2.iconImage.tintColor = UIColor.darkGray
            
            UIView.animate(withDuration: 0.3, animations: {
                self.whiteLine.frame.origin.x = self.whiteLine.frame.width
                
                cell.iconImage.tintColor = UIColor.white
                
            })
            
        case 2:
            print(indexPath.item)
            
            let cell0 = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as! MainCollectionViewCell
            cell0.iconImage.tintColor = UIColor.darkGray
            let cell1 = collectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as! MainCollectionViewCell
            cell1.iconImage.tintColor = UIColor.darkGray
            
            UIView.animate(withDuration: 0.3, animations: {
                self.whiteLine.frame.origin.x = self.whiteLine.frame.width * 2
                
                cell.iconImage.tintColor = UIColor.white
            })
            
        default:
            break
        }
    }
   //
}
