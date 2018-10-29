//
//  APICaller.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 16/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation

typealias OnSuccessResponse = (String) -> Void
typealias OnDestroySuccess = () -> Void
typealias OnCancelSuccess = () -> Void
typealias OnErrorMessage = (String) -> Void

typealias JSONDictionary = [String : AnyObject]

private enum RequestMethod: String, CustomStringConvertible {
    case GET = "GET"
    case PUT = "PUT"
    case POST = "POST"
    case DELETE = "DELETE"
    case PATCH  = "PATCH"
    
    var description: String {
        return rawValue
    }
}

class APICaller {
    let MAX_RETRIES = 2
    
    fileprivate var urlSession: URLSession
    
    class func getInstance() -> APICaller {
        struct Static {
            static let instance = APICaller()
        }
        return Static.instance
    }
    
    fileprivate init() {
        urlSession = APICaller.createURLSession()
    }
    
    fileprivate class func createURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.urlCache = nil
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
//        configuration.httpAdditionalHeaders = [
//            "Accept"       : "application/json",
//        ]
        
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    fileprivate func resetURLSession() {
        urlSession.invalidateAndCancel()
        urlSession = APICaller.createURLSession()
    }
    
    fileprivate func createRequest(_ requestMethod: RequestMethod, _ route: Route, params: JSONDictionary? = nil, sectionName: String? = nil) -> URLRequest {
        let request = NSMutableURLRequest(url: route.absoluteURL as URL)
        request.httpMethod = requestMethod.rawValue
        
        if let params = params {
            switch requestMethod {
            case .GET, .DELETE:
                var queryItems: [URLQueryItem] = []
                
                for (key, value) in params {
                    queryItems.append(URLQueryItem(name: "\(key)", value: "\(value)"))
                }
                
                if queryItems.count > 0 {
                    var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
                    components?.queryItems = queryItems
                    request.url = components?.url
                }
                
            case .POST, .PUT, .PATCH:
                
                var error: NSError?
                do {
                    let body = try JSONSerialization.data(withJSONObject: params, options: [])
                    request.httpBody = body
                } catch let error1 as NSError {
                    error = error1
                    if let errorMessage = error?.localizedDescription {
                        print(errorMessage)
                    } else {
                        print("Unexpected JSON Parse Error requestWithOperation: \(requestMethod) \(route.absoluteURL)")
                    }
                }
            }
        }
        return request as URLRequest
    }
    
    fileprivate func enqueueRequest(_ requestMethod: RequestMethod, _ route: Route, params: JSONDictionary? = nil, sectionName: String? = nil, retryCount: Int = 0, onSuccessResponse: @escaping (String) -> Void, onErrorMessage: @escaping OnErrorMessage) {
        
        let urlRequest = createRequest(requestMethod, route, params: params, sectionName: sectionName)
        print("URL-> \(urlRequest)")
        let dataTask = urlSession.dataTask(with: urlRequest, completionHandler: { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                var statusCode = httpResponse.statusCode
                var responseString:String = ""
                if let responseData = data {
                    responseString = NSString(data: responseData, encoding: String.Encoding.utf8.rawValue) as String? ?? ""
                }else {
                    statusCode = 450
                }
                print(responseString)
                switch statusCode {
                case 200...299:
                    // Success Response
                    
                    onSuccessResponse(responseString)
                    
                    
                default:
                    // Failure Response
                    let errorMessage = "Error Code: \(statusCode)"
                    onErrorMessage(errorMessage)
                }
                
            } else if let error = error {
                var errorMessage: String
                switch error._code {
                case NSURLErrorNotConnectedToInternet:
                    errorMessage = "Net Lost"//Constant.ErrorMessage.InternetConnectionLost
                case NSURLErrorNetworkConnectionLost:
                    if retryCount < self.MAX_RETRIES {
                        self.enqueueRequest(requestMethod, route, params: params, retryCount: retryCount + 1, onSuccessResponse: onSuccessResponse, onErrorMessage: onErrorMessage)
                        return
                        
                    } else {
                        errorMessage = error.localizedDescription
                    }
                default:
                    errorMessage = error.localizedDescription
                }
                onErrorMessage(errorMessage)
                
            } else {
                assertionFailure("Either an httpResponse or an error is expected")
            }
        })
        dataTask.resume()
    }
    
    internal func getNews(onSuccess: @escaping (News?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.GET, .news, onSuccessResponse: { response in
            Parser.sharedInstance.parseNews(jsonString: response, onSuccess: { news in
                onSuccess(news)
            })
        }, onErrorMessage: { error  in
            onError(error)
        })
    }
    
    internal func getNotifications(onSuccess: @escaping (Notifications?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.GET, .notifications, onSuccessResponse: { response in
            Parser.sharedInstance.parseNotifications(jsonString: response, onSuccess: { notifications in
                onSuccess(notifications)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getDashboardCover(onSuccess: @escaping (DashboardCover?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.GET, .dashboardCover, onSuccessResponse: { response in
            Parser.sharedInstance.parseDashboardCover(jsonString: response, onSuccess: { cover in
                onSuccess(cover)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getProjectData(onSuccess: @escaping (ProjectData?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.GET, .projectData, onSuccessResponse: { response in
            Parser.sharedInstance.parseProjectData(jsonString: response, onSuccess: { data in
                onSuccess(data)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getBolivienData(onSuccess: @escaping (Bolivien?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.GET, .bolivien, onSuccessResponse: { response in
            Parser.sharedInstance.parseBolivienData(jsonString: response, onSuccess: { bolivien in
                onSuccess(bolivien)
            })
        }, onErrorMessage: { error in
            
        })
    }
    
    internal func getMissionData(onSuccess: @escaping (Mission?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.GET, .mission, onSuccessResponse: { response in
            Parser.sharedInstance.parseMissionData(jsonString: response, onSuccess: { missionData in
                onSuccess(missionData)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getMagazines(onSuccess: @escaping (Magazines?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.GET, .magazine, onSuccessResponse: { response in
            Parser.sharedInstance.parseMagazine(jsonString: response, onSuccess: { magazines in
                onSuccess(magazines)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getPhotos(onSuccess: @escaping (Photos?) -> Void,onError: @escaping OnErrorMessage) {
        enqueueRequest(.GET, .galleryPhotos, onSuccessResponse: { response in
            Parser.sharedInstance.parseGalleryPhotos(jsonString: response, onSuccess: { photos in
                onSuccess(photos)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
    
    internal func getVideos(onSuccess: @escaping (Videos?) -> Void, onError: @escaping OnErrorMessage) {
        enqueueRequest(.GET, .galleryVideos, onSuccessResponse: { response in
            Parser.sharedInstance.parseGalleryVideos(jsonString: response, onSuccess: { videos in
                onSuccess(videos)
            })
        }, onErrorMessage: { error in
            onError(error)
        })
    }
}
