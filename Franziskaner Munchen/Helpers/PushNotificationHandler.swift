//
//  PushNotificationHandler.swift
//  AlwaysOn
//
//  Created by Muralitharan on 14/07/15.
//  Copyright (c) 2015 Onlife Health. All rights reserved.
//

import Foundation

class PushNotificationHandler : NSObject {
    
    static let sharedInstance = PushNotificationHandler()
    
    var isControlByNotification: Bool = false
    
    var isNotificationRecievedInForeground:Bool = false
    
    var isLanchedByNotification:Bool = false
    
    var typeOfNotification:String = ""
    
    var isPushNotificationRecieved:Bool = false
    
    var notificationMessage:String = ""
    
    var goalTypeName:String = ""
    
    var customTypeName:String = ""
    
    var isNotificationReachedItsDestination:Bool = true
    
    var isGoalCreationInProgress:Bool = false
    
    var isMenuViewControllerVisible:Bool = false
    
    var isHealthAssessmentIsATopViewController:Bool = false
    
    var currentTopVCGoalName:String = ""
    
    var isNotificationWhilePinIsVisible:Bool = false
    
    var topViewController = ""
    
    var isDeeplinkInitiatedWhileUserLoggedOff:Bool = false
    
    var isDeeplinkInitiatedFromDEP:Bool = false
    
    var deepLinkApplicationSourceName:String = ""

    var isViewControllerTriggeredByDashboardTileVC = false

    var actorId:Int = 0
}
