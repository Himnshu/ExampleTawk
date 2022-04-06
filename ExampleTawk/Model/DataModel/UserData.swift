//
//  UserData.swift
//  ExampleTawk
//
//  Created by Himanshu on 29/03/22.
//

import Foundation

struct UserData : Codable {
    var login : String?
    var id : Int?
    var node_id :String?
    var avatar_url : String?
    var gravatar_id :String?
    var url : String?
    var html_url :String?
    var followers_url : String?
    var following_url :String?
    var gists_url : String?
    var starred_url :String?
    var subscriptions_url : String?
    var organizations_url :String?
    var repos_url : String?
    var events_url :String?
    var received_events_url :String?
    var type : String?
    var site_admin :Bool?
    var name : String?
    var company : String?
    var blog : String?
    var location : String?
    var email : String?
    var hireable : Bool?
    var bio : String?
    var twitter_username : String?
    var public_repos : Int?
    var public_gists : Int?
    var followers : Int?
    var following : Int?
    var created_at : String?
    var updated_at : String?
    var isNote: Bool?
    var Note: String?
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case id = "id"
        case node_id = "node_id"
        case avatar_url = "avatar_url"
        case gravatar_id = "gravatar_id"
        case url = "url"
        case html_url = "html_url"
        case followers_url = "followers_url"
        case following_url = "following_url"
        case gists_url = "gists_url"
        case starred_url = "starred_url"
        case subscriptions_url = "subscriptions_url"
        case organizations_url = "organizations_url"
        case repos_url = "repos_url"
        case events_url = "events_url"
        case received_events_url = "received_events_url"
        case type = "type"
        case site_admin = "site_admin"
        case name = "name"
        case company = "company"
        case blog = "blog"
        case location = "location"
        case email = "email"
        case hireable = "hireable"
        case bio = "bio"
        case twitter_username = "twitter_username"
        case public_repos = "public_repos"
        case public_gists = "public_gists"
        case followers = "followers"
        case following = "following"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case isNote = "isNote"
        case Note = "Note"
    }
}
