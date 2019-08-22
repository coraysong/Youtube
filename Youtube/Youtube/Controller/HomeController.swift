//
//  HomeController.swift
//  Youtube
//
//  Created by 宋超 on 2019/8/21.
//  Copyright © 2019 宋超. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    var videos: [Video] = {
        
        var jayChannel = Channel()
        jayChannel.name = "KayChannel"
        jayChannel.profileImageName = "home"
        
        var blankSpaceVideo = Video()
        blankSpaceVideo.title = "Jay Chou -dsjfklsdjlfkdsjlkfjdslkjfsdlkjlfkdsjklfdsjlkfjdslkfsdkljfklsdjlfkds 龙卷风j"
        blankSpaceVideo.thumnailImageName = "home"
        blankSpaceVideo.channel = jayChannel
        blankSpaceVideo.numberOfViews = 11121217219
        
        var bloodSpaceVideo = Video()
        bloodSpaceVideo.title = "Jay Chou - 听妈妈的话"
        bloodSpaceVideo.thumnailImageName = "subscriptions"
        bloodSpaceVideo.channel = jayChannel
        bloodSpaceVideo.numberOfViews = 111212111219
        
        var paceVideo = Video()
        paceVideo.title = "Jay Chou - 听妈妈的话"
        paceVideo.thumnailImageName = "subscriptions"
        paceVideo.channel = jayChannel
        paceVideo.numberOfViews = 111212111219
        
        return [blankSpaceVideo,bloodSpaceVideo,paceVideo]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: view.frame.width - 32,height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        collectionView.backgroundColor = .white
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView.contentInset = UIEdgeInsets(top: 50,left: 0,bottom: 0,right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        setupMenuBar()
        setupNavBarButtons()
    }

    let menuBar : MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]|", views: menuBar)
    }
    
    private func setupNavBarButtons() {
        
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreImage = UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal)
        let moreButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [moreButtonItem,searchBarButtonItem]
    }
    
    @objc func handleMore() {
        print(123)
    }
    
    @objc func handleSearch() {
        print(123)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let hegiht = (view.frame.width - 16 - 16) * 9 / 16
        
        return .init(width: view.frame.size.width, height: hegiht + 16 + 68)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! VideoCell
        cell.video = videos[indexPath.item]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}



