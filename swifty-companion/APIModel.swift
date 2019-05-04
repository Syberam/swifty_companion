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
    var expire_date: Date?
}

struct UserInfo: Codable {
    var id: Int?
    var email: String?
    var login: String?
    var first_name: String?
    var last_name: String?
    var url: String?
    var phone: String?
    var displayname: String?
    var image_url: String?
    var staff: Bool?
    var correction_point: Int?
    var pool_month: String?
    var pool_year: String?
    var location: String?
    var wallet: Int?
    var groups: [Group]?
    var cursus_users: [CursusUser]?
    var achievements: [Achievement]?
    var titles: [Titles]?
    var titles_users: [TitlesUsers]?
    var expertises_users: [Expertise]?
    var campus: [Campus]?
    var campus_users: [CampusUsers]?
}

struct Titles: Codable {
    var id: Int?
    var name: String?
}

struct TitlesUsers: Codable {
    var id: Int?
    var user_id: Int?
    var title_id: Int?
    var selected: Bool?
}

struct CampusUsers: Codable{
    var id: Int?
    var user_id: Int?
    var campus_id: Int?
    var is_primary: Bool?
}

struct Campus: Codable{
    var id: Int?
    var name: String?
    var country: String?
}

struct Expertise: Codable {
    var id: Int?
    var expertise_id: Int?
    var interested: Bool?
    var value: Int?
    var contact_me: Bool?
    var created_at: String?
    var user_id: Int?
}


struct Group: Codable {
    var id: Int?
    var name: String?
}

struct CursusUser: Codable {
    var grade: String?
    var level: Float?
    var skills: [Skills]?
    var id: Int?
    var begin_at: String?
    var end_at: String?
    var cursus_id: Int?
    var has_coalition: Bool?
    var user: UserShort?
    var cursus: Cursus?
}

struct Skills: Codable {
    var id: Int?
    var name: String?
    var level: Float?
}

struct UserShort: Codable {
    var id: Int?
    var login: String?
    var url: String?
}

struct Cursus: Codable{
    var id: Int?
    var created_at: String?
    var name: String?
    var slug: String?
}

struct ProjectsUser: Codable{
    var id: Int?
    var occurrence: Int?
    var final_mark: Int?
    var status: String?
    var validated: Bool?
    var current_team_id: Int?
    var project: Project?
    var cursus_ids: [Int]?
    var marked_at: String?
    var marked: Bool?
}

struct Project: Codable{
    var id: Int
    var name: String?
    var slug: String?
    var parent_id: String?
}

struct Achievement: Codable{
    var id: Int?
    var name: String?
    var description: String?
    var tier: String?
    var kind: String?
    var visible: Bool?
    var image: String?
    var nbr_of_success: Int?
    var users_url: String?
}
