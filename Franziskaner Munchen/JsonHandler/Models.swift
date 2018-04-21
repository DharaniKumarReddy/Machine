//
//  Models.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 16/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation

// MARK:- News
struct NewsObject {
    internal var id: String
    internal var image: String
    internal var title: String
    internal var date: Date
    internal var description: String
    internal var updated_date: String
}
struct News {
    internal var news: [NewsObject]
    internal var success: Int
    internal var message: String
}

// MARK:- Dashboard
struct Photo {
    internal var id: String
    internal var img: String
    internal var updatedDate: String
}
struct DashboardCover {
    internal var coverPhoto: [Photo]
    internal var success: Int
    internal var message: String
}

// MARK:- Notifications
struct Notification {
    internal var id: String
    internal var title: String
    internal var description: String
    internal var date: Date
    internal var updatedDate: String
}

struct Notifications {
    internal var shortNotifications: [Notification]
    internal var success: Int
    internal var message: String
}

// MARK:- Photos
struct Photos {
    internal var gallery: [Photo]
    internal var success: Int
    internal var message: String
}

// MARK:- Videos
struct Video {
    internal var id: String
    internal var vTitle: String
    internal var vId: String
    internal var vDate: String
    internal var vDescription: String
    internal var updatedDate: String
}
struct Videos {
    internal var video: [Video]
    internal var success: Int
    internal var message: String
}

// MARK:- Project Data
struct Project {
    internal var id: String
    internal var title: String
    internal var desc: String
    internal var image: String
    internal var date: Date
    internal var updatedDate: String
    internal var createdDate: String
}
struct ProjectData {
    internal var data: [Project]
    internal var success: Int
}
