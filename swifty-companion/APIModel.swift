//
//  APIModel.swift
//  swifty-companion
//
//  Created by Sylvain BONNEFON on 4/25/19.
//  Copyright © 2019 sbonnefo. All rights reserved.
//

import Foundation


struct TokenAPI: Codable {
    var access_token: String?
    var created_at: Int
    var expires_in: Int
}


