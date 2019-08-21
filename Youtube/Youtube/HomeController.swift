//
//  HomeController.swift
//  Youtube
//
//  Created by 宋超 on 2019/8/21.
//  Copyright © 2019 宋超. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Home"
        collectionView.backgroundColor = .white
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "CellId")
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.size.width, height: 200)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath)
        return cell
        
    }
}


class VideoCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    
    let thumbnailImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .green
        //类扩展中已经添加，这里就不需要了
        //imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let separatorView:UIView = {
        let view = UIView()
        view.backgroundColor = .black
        //类扩展中已经添加，这里就不需要了
        //view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let userProfileImageView:UIImageView = {
        
        let imageView = UIImageView()
        imageView.backgroundColor = .green
        return imageView
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subtitleLabel:UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .red
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    func setupViews() {
        
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        //水平约束
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstraintsWithFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        //竖直约束
        addConstraintsWithFormat(format: "V:|-16-[v0]-[v1(44)]-[v2(1)]|", views: thumbnailImageView,userProfileImageView,separatorView)
        
        //title
        //top 约束
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))

        addConstraintsWithFormat(format: "V:[v0(20)]", views: titleLabel)
        
        //left约束
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        //right约束
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        //height约束
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))
        
        //subtitle
        //top 约束
        addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 8))
        
        addConstraintsWithFormat(format: "V:[v0(20)]", views: titleLabel)
        
        //left约束
        addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        //right约束
        addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        //height约束
        addConstraint(NSLayoutConstraint(item: subtitleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UIView {
    func addConstraintsWithFormat(format:String,views:UIView...) {
        
        var viewsDictionary = [String:UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views:viewsDictionary))
    }
}
