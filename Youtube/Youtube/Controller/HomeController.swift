//
//  HomeController.swift
//  Youtube
//
//  Created by 宋超 on 2019/8/21.
//  Copyright © 2019 宋超. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var videos: [Video]?
    
    func fetchVideos() {
        
        if let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json"){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    
                    self.videos = [Video]()
                    
                    for dictionary in  json as! [[String:AnyObject]] {
                        let video = Video()
                        video.title = dictionary["title"]! as? String
                        video.thumnailImageName = dictionary["thumbnail_image_name"] as? String
                        
                        let channelDict = dictionary["channel"] as? [String:AnyObject]
                        
                        let channel = Channel()
                        channel.name = channelDict!["name"] as? String
                        channel.profileImageName = channelDict!["profile_image_name"] as? String
                        
                        video.channel = channel
                        
                        self.videos?.append(video)
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                } catch let jsonError {
                    print(jsonError)
                }
            }.resume()
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
    
    func showControllerForSettings(setting: Setting) {
        
        let dummyController = UIViewController()
        dummyController.view.backgroundColor = .white
        dummyController.navigationItem.title = setting.name
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.pushViewController(dummyController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let hegiht = (view.frame.width - 16 - 16) * 9 / 16
        
        return .init(width: view.frame.size.width, height: hegiht + 16 + 68)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! VideoCell
        cell.video = videos?[indexPath.item]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}



