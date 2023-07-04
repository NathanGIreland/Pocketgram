//
//  Post.swift
//  PocketGram
//
//  Created by Nathan Ireland on 5/21/23.
//

import Foundation

struct postModel{
    var postId = ""
    var userId: String
    var imgUrl: String
    var timestamp: Double
    var username: String
    var userPfp: String
    var comments = [[String: String]]()
    var likedBy = [String]()
    var caption: String
}
