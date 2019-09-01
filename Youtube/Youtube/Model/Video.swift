//
//  Video.swift
//  Youtube
//
//  Created by 宋超 on 2019/8/21.
//  Copyright © 2019 宋超. All rights reserved.
//

import UIKit


class Video: Decodable {
    
    var thumbnailImageName: String?
    var title: String?
    var numberOfViews: Int?
    var uploadDate: Date?
    
    var channel: Channel?
}


class Channel: Decodable {
    var name: String?
    var profileImageName: String?
    
}
