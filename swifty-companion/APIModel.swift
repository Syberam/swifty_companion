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
    var created_at: Double?
    var expires_in: Double?
    var expires_in_seconds: Int?
    var expire_date: Date?
}
