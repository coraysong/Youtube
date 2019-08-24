//
//  SettingsLauncher.swift
//  Youtube
//
//  Created by 宋超 on 2019/8/22.
//  Copyright © 2019 宋超. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: String
    let imageName: String
    
    init(name: SettingName, imageName: String) {
        self.name = name.rawValue
        self.imageName = imageName
    }
}

enum SettingName: String{
    case Cancel = "Cancel"
    case Setting = "Settings"
    case TermPrivacy = "Terms & privacy policy"
    case FeedBack = "Send Feedback"
    case Help = "Help"
    case SwitchAccount = "Switch Account"
}

class SettingsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let cellHeight: CGFloat = 50
    
    var homeController: HomeController?
    
    
    let settings: [Setting] = {
        return [
            Setting(name: SettingName.Setting, imageName: "settings"),
            Setting(name: SettingName.TermPrivacy, imageName: "privacy"),
            Setting(name: SettingName.FeedBack, imageName: "feedback"),
            Setting(name: SettingName.Help, imageName: "help"),
            Setting(name: SettingName.SwitchAccount, imageName: "switch_account"),
            Setting(name: SettingName.Cancel, imageName: "cancel")
        ]
    }()
    
    
    
    //    let y:CGFloat = UIScreen.main.bounds.height - height!
    
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    
    func showSettings() {
        //显示设置选项
        let safeInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom
        let height:CGFloat = CGFloat(settings.count) * cellHeight + CGFloat(safeInset ?? 0)
        let y: CGFloat = UIScreen.main.bounds.height - height
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handle)))
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: window.frame.width, height: height)
            })
        }
    }
    
    
    @objc func handle() {
        handleDissmiss(setting: nil)
    }
    
    @objc func handleDissmiss(setting: Setting?) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                }
            }, completion: { (_) in
                if let name = setting?.name {
                    if name != "Cancel"{
                        //self.homeController?.showControllerForSettings(setting: setting!)
                    }
                }
            })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        cell.setting = settings[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let setting = settings[indexPath.item]
        handleDissmiss(setting: setting)
        
    }
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }
    
}

