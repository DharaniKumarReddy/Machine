//
//  NewsParser.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 16/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import SwiftyJSON

class Parser {
    static let sharedInstance = Parser()
    private init() {}
    
    func parseNews(jsonString: String, onSuccess: (News?)->(Void)) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let success = json?["success"].intValue ?? 0
            let message = json?["message"].stringValue ?? ""
            let news = json?["news"].arrayValue
            var newsArray: [NewsObject] = []
            
            for newsObject in news ?? [] {
                let id = newsObject["id"].stringValue
                let image = newsObject["image"].stringValue
                let title = newsObject["title"].stringValue
                let date = DateFormatters.defaultDateFormatter().date(from:  newsObject["date"].stringValue) ?? Date()
                let desc = newsObject["description"].stringValue
                let updatedDate = newsObject["updated_date"].stringValue
                let newsObject = NewsObject(id: id, image: image, title: title, date: date, description: desc, updated_date: updatedDate)
                newsArray.append(newsObject)
            }
            onSuccess(News(news: newsArray, success: success, message: message))
        }
    }
    
    func parseDashboardCover(jsonString: String, onSuccess: (DashboardCover?) -> (Void)) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let success = json?["success"].intValue ?? 0
            let message = json?["message"].stringValue ?? ""
            let photos = json?["coverphoto"].arrayValue
            var coverPhotosArray: [Photo] = []
            
            for photo in photos ?? [] {
                let id = photo["id"].stringValue
                let image = photo["img"].stringValue
                let updatedDate = photo["updated_date"].stringValue
                let photo = Photo(id: id, img: image, updatedDate: updatedDate)
                coverPhotosArray.append(photo)
            }
            onSuccess(DashboardCover(coverPhoto: coverPhotosArray, success: success, message: message))
        }
    }
    
    func parseNotifications(jsonString: String, onSuccess: (Notifications?) -> (Void)) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let success = json?["success"].intValue ?? 0
            let message = json?["message"].stringValue ?? ""
            let shortNotification = json?["shortnotification"].arrayValue
            var notifications: [Notification] = []
            
            for notification in shortNotification ?? [] {
                let id = notification["id"].stringValue
                let title = notification["title"].stringValue
                let desc = notification["description"].stringValue
                let date = DateFormatters.defaultDateFormatter().date(from:  notification["date"].stringValue) ?? Date()
                let updatedDate = notification["updated_date"].stringValue
                let notification = Notification(id: id, title: title, description: desc, date: date, updatedDate: updatedDate)
                notifications.append(notification)
            }
            onSuccess(Notifications(shortNotifications: notifications, success: success, message: message))
        }
    }
    
    func parseGalleryPhotos(jsonString: String, onSuccess: (Photos?) -> (Void)) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let success = json?["success"].intValue ?? 0
            let message = json?["message"].stringValue ?? ""
            let photos = json?["gallery"].arrayValue
            var photosArray: [Photo] = []
            
            for photo in photos ?? [] {
                let id = photo["id"].stringValue
                let image = photo["image"].stringValue
                let updatedDate = photo["updated_date"].stringValue
                let photo = Photo(id: id, img: image, updatedDate: updatedDate)
                photosArray.append(photo)
            }
            onSuccess(Photos(gallery: photosArray, success: success, message: message))
        }
    }
    
    func parseGalleryVideos(jsonString: String, onSuccess: (Videos?) -> Void) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
            let json = try? JSON(data: dataFromString)
            let success = json?["success"].intValue ?? 0
            let message = json?["message"].stringValue ?? ""
            let videos = json?["videos"].arrayValue ?? []
            var videosArray: [Video] = []
            
            for video in videos {
                let id = video["id"].stringValue
                let vTitle = video["v_title"].stringValue
                let vId = video["v_id"].stringValue
                let vDate = video["v_date"].stringValue
                let vDesc = video["v_description"].stringValue
                let updatedDate = video["updated_date"].stringValue
                let video = Video(id: id, vTitle: vTitle, vId: vId, vDate: vDate, vDescription: vDesc, updatedDate: updatedDate)
                videosArray.append(video)
            }
            onSuccess(Videos(video: videosArray, success: success, message: message))
        }
    }
}
