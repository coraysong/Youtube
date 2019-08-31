//
//  SubscriptionCell.swift
//  Youtube
//
//  Created by 宋超 on 2019/8/31.
//  Copyright © 2019 宋超. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {
    override func fetchVideos() {
        APIService.shareInstance.fetchSubscriptionFeed { (videos:[Video]) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
