//
//  StringExtension.swift
//  Franziskaner Munchen
//
//  Created by Dharani Reddy on 19/04/18.
//  Copyright © 2018 Integro Infotech. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func downloadImage(completion: @escaping (UIImage) -> ()) {
        URLSession.shared.dataTask(with: NSURL(string:self)! as URL) {
            (data, response, error) in
            if let data = data {
                completion(UIImage(data: data) ?? UIImage())
            } else {
                completion(#imageLiteral(resourceName: "no_image"))
            }
        }.resume()
    }
}
