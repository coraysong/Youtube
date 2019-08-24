//
//  APIService.swift
//  Youtube
//
//  Created by 宋超 on 2019/8/24.
//  Copyright © 2019 宋超. All rights reserved.
//

import UIKit

class APIService: NSObject {
    static let shareInstance = APIService()
    func fetchVideos(complete:@escaping ([Video]) -> ()) {
        if let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json"){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    
                    var videos = [Video]()
                    
                    for dictionary in  json as! [[String:AnyObject]] {
                        let video = Video()
                        video.title = dictionary["title"]! as? String
                        video.thumnailImageName = dictionary["thumbnail_image_name"] as? String
                        
                        let channelDict = dictionary["channel"] as? [String:AnyObject]
                        
                        let channel = Channel()
                        channel.name = channelDict!["name"] as? String
                        channel.profileImageName = channelDict!["profile_image_name"] as? String
                        
                        video.channel = channel
                        
                        videos.append(video)
                    }
                    
                    DispatchQueue.main.async {
                        complete(videos)
                    }
                    
                } catch let jsonError {
                    print(jsonError)
                }
                }.resume()
        }
    }
}
