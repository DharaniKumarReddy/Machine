//
//  Route.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 16/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation

let Base_Url = "http://franciscansmunich.com"

enum Route {
    case news
    case notifications
    case dashboardCover
    case projectData
    case bolivien
    case mission
    case magazine
    case missionsTeam
    case galleryPhotos
    case galleryVideos
    
    var absoluteURL: URL {
        return URL(string: Base_Url + apiPath)!
    }
    
    fileprivate var apiPath: String {
        switch self {
        case .news:
            return "/franziskaner_news.php"
        case .notifications:
            return "/shortnotification.php"
        case .dashboardCover:
            return "/franziskaner/franziskaner_cphoto.php"
        case .projectData:
            return "/project_jsoncode.php"
        case .bolivien:
            return "/focus_jsoncode.php"
        case .magazine:
            return "/franziskaner_notification.php"
        case .mission:
            return "/mission_jsoncode.php"
        case .missionsTeam:
            return "/franziskaner_mgteam.php"
        case .galleryPhotos:
            return "/franziskanergallery.php"
        case .galleryVideos:
            return "/franziskaner_videos.php"
        }
    }
}
