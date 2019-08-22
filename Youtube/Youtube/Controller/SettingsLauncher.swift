//
//  SettingsLauncher.swift
//  Youtube
//
//  Created by 宋超 on 2019/8/22.
//  Copyright © 2019 宋超. All rights reserved.
//

import UIKit

class SettingsLauncher: NSObject {
    
    let height:CGFloat = 200
    //    let y:CGFloat = UIScreen.main.bounds.height - height!
    
    let y: CGFloat = UIScreen.main.bounds.height - 200
    override init() {
        super.init()
        
    }
    
    let blackView = UIView()
    

    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    
    func showSettings() {
        //显示设置选项
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDissmiss)))
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            
            
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: self.y, width: window.frame.width, height: self.height)
            })
        }
    }
    
    @objc func handleDissmiss() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            self.collectionView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: self.height)
        })
    }
    
    
    
}

