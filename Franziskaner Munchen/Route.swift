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
        }
    }
}
