//
//  IntroViewController.swift
//  SinbiDemo21
//
//  Created by SUNG HAO LIN on 2017/5/24.
//  Copyright © 2017年 GanNaSong. All rights reserved.
//

import UIKit
import CHIPageControl
class IntroViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var introPageControl: CHIBasePageControl!
    @IBOutlet weak var introHeadLabel: UILabel!
    @IBOutlet weak var introMessageLabel: UILabel!
    @IBOutlet weak var introCollectionView: UICollectionView!
    @IBOutlet weak var introStartButton: UIButton!
    @IBOutlet weak var introSkipButton: UIButton!
    @IBOutlet weak var introNextButton: UIButton!
    
    var progress = 0.0
    var pageIndexPath:IndexPath?
    let introPageNumbers = 4
    var introPageData:[IntroPage] = [
        IntroPage(head: "Sinbi", message: "多久沒有充滿自信的笑容了？", image: "intro0"),
        IntroPage(head: "Sinbi", message: "也想擁有白到透光的牙齒嗎？", image: "intro1"),
        IntroPage(head: "Sinbi", message: "審美給您最專業的美齒SPA", image: "intro2"),
        IntroPage(head: "Sinbi", message: "美齒從這一刻開始！", image: "intro3")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        introMessageLabel.text = introPageData[0].message
        //init page number
        self.introPageControl.numberOfPages = self.introPageNumbers
    }

    
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "introCell", for: indexPath) as! IntroCollectionViewCell
        cell.introBackgroundImage.image = UIImage(named: "intro\(indexPath.row)")
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.bounds.size
    }
    
    
    
    //scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let total = scrollView.contentSize.width - scrollView.bounds.width
        let offset = scrollView.contentOffset.x
        let percent = Double(offset / total)
        print(percent)
        progress = percent * Double(self.introPageNumbers - 1)
        self.introPageControl.progress = progress
        //print(progress)
        if progress != 3 {
            introNextButton.isHidden = false
            introSkipButton.isHidden = false
            introStartButton.isHidden = true
            introMessageLabel.text = introPageData[Int(progress)].message
            
        } else {
            introNextButton.isHidden = true
            introSkipButton.isHidden = true
            introStartButton.isHidden = false
            introMessageLabel.text = introPageData[3].message
        }
    }
    
    
    
    @IBAction func introNextButton(_ sender: UIButton) {
        let pageIndexPath = IndexPath(row: Int(progress) + 1, section: 0)
        if pageIndexPath.row != 4 {
            introCollectionView.scrollToItem(at: pageIndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        }
    }
    
    
    
    @IBAction func introStartButton(_ sender: UIButton) {
      //切換畫面
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let dvc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    
    
    @IBAction func introSkipButton(_ sender: UIButton) {
        let pageIndexPath = IndexPath(row: 3, section: 0)
        introCollectionView.scrollToItem(at: pageIndexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        
    }
    

    //
}
