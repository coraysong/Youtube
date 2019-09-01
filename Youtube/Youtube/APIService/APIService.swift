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
    
    let baseUrl = "https://s3-us-west-2.amazonaws.com/youtubeassets/"
    
    
    func fetchVideos(complete:@escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)home.json") { (videos) in
            complete(videos)
        }
            
    }
    
    func fetchTrending(complete:@escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)trending.json") { (videos) in
            complete(videos)
        }
    }
    
    func fetchSubscriptionFeed(complete:@escaping ([Video]) -> ()) {
        fetchFeedForUrlString(urlString: "\(baseUrl)subscriptions.json") { (videos) in
            complete(videos)
        }
    }
    
    func fetchFeedForUrlString(urlString: String, complete:@escaping ([Video]) -> ())  {
        if let url = URL(string: urlString){
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                do{
                    guard let data = data else { return }
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let videos = try decoder.decode([Video].self, from: data)
                    
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
