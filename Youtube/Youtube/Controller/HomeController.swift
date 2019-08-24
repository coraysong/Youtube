//
//  HomeController.swift
//  Youtube
//
//  Created by 宋超 on 2019/8/21.
//  Copyright © 2019 宋超. All rights reserved.
//

import UIKit
import SDWebImage

class HomeController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var videos: [Video]?
    let cellId = "CellId"
    
    func fetchVideos() {
        
        APIService.shareInstance.fetchVideos { (videos:[Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchVideos()
        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: view.frame.width - 32,height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        setupCollectionView()
        setupMenuBar()
        setupNavBarButtons()
    }

    lazy var menuBar : MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    
    func setupCollectionView() {
        
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView.backgroundColor = .white
//        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "CellId")
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.contentInset = UIEdgeInsets(top: 50,left: 0,bottom: 0,right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.isPagingEnabled = true
    }
    
    private func setupMenuBar() {
        
        navigationController?.hidesBarsOnSwipe = true
        
        let redView = UIView()
        redView.backgroundColor = .rgb(red: 230, green: 32, blue: 31)
        view.addSubview(redView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    private func setupNavBarButtons() {
        
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreImage = UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal)
        let moreButtonItem = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        
        navigationItem.rightBarButtonItems = [moreButtonItem,searchBarButtonItem]
    }
    
    lazy var settingsLauncher: SettingsLauncher = {
       
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    
    @objc func handleMore() {
        //显示设置选项
        settingsLauncher.showSettings()
    }
    
    @objc func handleSearch() {
        print(123)
    }
    
    func scrollToMenuIndex(menuIndex:Int) {
        
        let index = NSIndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: index as IndexPath, at: [], animated: true)
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        menuBar.horizontalBarConstraint?.constant = scrollView.contentOffset.x * 0.25
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        let color: [UIColor] = [UIColor.blue,UIColor.red,UIColor.yellow,UIColor.purple]
        cell.backgroundColor = color[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        
        let index = NSIndexPath(item: Int(targetContentOffset.pointee.x / view.frame.width), section: 0)
        menuBar.collectionView.selectItem(at: index as IndexPath, animated: true, scrollPosition: [])
        
    }
    
//    func showControllerForSettings(setting: Setting) {
//
//        let dummyController = UIViewController()
//        dummyController.view.backgroundColor = .white
//        dummyController.navigationItem.title = setting.name
//        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
//        navigationController?.pushViewController(dummyController, animated: true)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let hegiht = (view.frame.width - 16 - 16) * 9 / 16
//
//        return .init(width: view.frame.size.width, height: hegiht + 16 + 68)
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return videos?.count ?? 0
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! VideoCell
//        cell.video = videos?[indexPath.item]
//        return cell
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
}



