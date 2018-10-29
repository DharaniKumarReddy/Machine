//
//  HomeViewController.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 13/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

let screenWidth     = UIScreen.main.bounds.width
let screenHeight    = UIScreen.main.bounds.height
let iPhoneX         = screenHeight == 812.0
let iPhonePlus      = screenHeight == 736.0
let iPhoneSE        = screenHeight == 568.0

class DashboardViewController: UIViewController {
    
    // MARK:- Variables
    private var currentIndex = 0
    private var tabs: [UIViewController] = []
    private var isNotifiedAlertDismissed = true
    
    // MARK:- IBOutlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var tabBarView: UIView!
    @IBOutlet private weak var indicatorLeadingConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.tintColor = .white
        tabs = [loadHome(), loadNews(), loadNotifications(), loadWeb()]
        (UIApplication.shared.delegate as? AppDelegate)?.dashboard = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = false
        containerView.isHidden = false
        tabBarView.isHidden = false
        isNotificationYetToReachItsDestination()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK:- Bar Button Action
    @IBAction func menuButton_Tapped(_ sender: Any) {
        slideMenuController()?.changeLeftViewWidth(screenWidth-screenWidth/5)
        SlideMenuOptions.contentViewScale = 1
        (slideMenuController()?.leftViewController as! MenuViewController).shouldAnimate = true
        slideMenuController()?.openLeft()
    }
    
    // MARK:- IBActions
    @IBAction func tabBarButtons_Tapped(button: UIButton) {
        animateIndicator(position: CGFloat(button.tag) * button.frame.size.width)
        loadTabs(index: button.tag)
    }
    
    @IBAction func swipeGestureRecognizer(swipeGesture: UISwipeGestureRecognizer) {
        let direction = swipeGesture.direction
        if (indicatorLeadingConstraint.constant <= 0 && direction == .right) || (indicatorLeadingConstraint.constant >= screenWidth-screenWidth/4 && direction == .left) {
            return
        }
        let position = direction == .left ? indicatorLeadingConstraint.constant + screenWidth/4 : indicatorLeadingConstraint.constant - screenWidth/4
        animateIndicator(position: position)
        loadTabs(index: Int(roundf(Float(position/(screenWidth/4)))))
    }
    
    // MARK:- Private Methods
    private func animateIndicator(position: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: {
            self.indicatorLeadingConstraint.constant = position
            self.view.layoutIfNeeded()
        })
    }
    
    private func loadTabs(index: Int) {
        guard index != currentIndex else {
            return
        }
        if index < 0 || index >= tabs.count {
            return
        }
        loadContainer(controller: tabs[index])
        currentIndex = index
    }
    
    private func loadHome() -> UIViewController {
        return UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: HomeViewController.self))
    }
    
    private func loadNews() -> UIViewController {
        return UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: NewsViewController.self))
    }
    
    private func loadNotifications() -> UIViewController {
        return UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: NotificationsViewController.self))
    }
    
    private func loadWeb() -> UIViewController {
        return UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: MyWebViewController.self))
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    private func loadContainer(controller: UIViewController) {
        if let lastController = children.last {
            remove(asChildViewController: lastController)
        }
        addChild(controller)
        containerView.addSubview(controller.view)
        controller.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: UIHelper.shared.getDashboardContainerHeight(view))
        //controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.didMove(toParent: self)
    }
}

extension DashboardViewController {
    /**
     Before notification going to invoke its controller, basic checks needs to be verified and notificaton will be fired.
     */
    internal func postRemoteNotification() {
        
        // Check Notification is recieved while app is foreground
        if PushNotificationHandler.sharedInstance.isNotificationRecievedInForeground && isNotifiedAlertDismissed {
            PushNotificationHandler.sharedInstance.isNotificationRecievedInForeground = false
            self.isNotifiedAlertDismissed = false
            // Pop's up the alertview and notifiy user to whether he/she wants to reach notified controller
            guard TopViewController.isNotifiedController() else {
                showAlertViewController(getAlertTitle(), message: truncateCharactersInNotificationMessage(PushNotificationHandler.sharedInstance.notificationMessage as NSString), cancelButton: "Close", destructiveButton: "", otherButtons: "Open", onDestroyAction: {
                    self.isNotifiedAlertDismissed = true
                    PushNotificationHandler.sharedInstance.isNotificationReachedItsDestination = true
                    self.presentNotifiedViewController()
                }, onCancelAction: {
                    self.isNotifiedAlertDismissed = true
                    // Making sure app is reached its destination view controller, so that future notifications will show
                    PushNotificationHandler.sharedInstance.isNotificationReachedItsDestination = true
                })
                return
            }
            isNotifiedAlertDismissed = true
            PushNotificationHandler.sharedInstance.isNotificationReachedItsDestination = true
        } else if isNotifiedAlertDismissed {
            
            //Looks for destined notification controller
            presentNotifiedViewController()
        } else {
            // Making sure app is reached its destination view controller, so that future notifications will show
            PushNotificationHandler.sharedInstance.isNotificationReachedItsDestination = true
        }
    }
    /**
     To confirm whether notification reached its destined controller.
     */
    private func isNotificationYetToReachItsDestination() {
        if PushNotificationHandler.sharedInstance.isPushNotificationRecieved {
            postRemoteNotification()
        }
    }
    
    internal func presentNotifiedViewController() {
        //8 Notification
        //4 News
        //5 magazines
        //1 Mission from Dashboard
        //3 Projektbispiele
        //6 missionteam in menu
        //2 Bolivian
        
        print(PushNotificationHandler.sharedInstance.notificationType)
        PushNotificationHandler.sharedInstance.isPushNotificationRecieved = false
        let type = PushNotificationHandler.sharedInstance.notificationType
        if [8, 4].contains(type) {
            loadTabBars(type)
        } else {
            switch type {
            case 1, 2, 3:
                navigateToController(type: type)
            case 5:
                openMagazines([])
            case 6:
                openWebPage(url: Route.missionsTeam.absoluteURL.absoluteString)
            default:
                break
            }
        }
    }
    
    private func loadTabBars(_ type: Int) {
        let index = [4:1, 8:2][type] ?? 0
        animateIndicator(position: CGFloat(index) * screenWidth/4)
        loadTabs(index: index)
    }
    
    private func navigateToController(type: Int) {
        guard let controller = UIStoryboard(name: Constant.StoryBoard.Main, bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: ProjectViewController.self)) as? ProjectViewController else { return }
        //controller?.projectType
        switch type {
        case 1:
            controller.projectType = .mission
        case 2:
            controller.projectType = .bolivien
        default:
            controller.projectType = .project
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func getAlertTitle() -> String {
        switch PushNotificationHandler.sharedInstance.notificationType {
        case 4:
            return "News"
        case 2:
            return "Bolivian"
        case 5:
            return "Magazines"
        case 8:
            return "Notifications"
        case 6:
            return "Missions Team"
        case 1:
            return "Mission"
        case 3:
            return "Projektbispiele"
        default:
            return "Franziskaner"
        }
    }
}
