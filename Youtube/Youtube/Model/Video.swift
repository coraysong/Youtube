//
//  Video.swift
//  Youtube
//
//  Created by 宋超 on 2019/8/21.
//  Copyright © 2019 宋超. All rights reserved.
//

import UIKit


class Video: NSObject {
    var thumnailImageName: String?
    var title: String?
    var channel: Channel?
    var numberOfViews: NSNumber?
    var uploadDate: NSDate?
    
}


class Channel: NSObject {
    var name: String?
    var profileImageName: String?
    
}
