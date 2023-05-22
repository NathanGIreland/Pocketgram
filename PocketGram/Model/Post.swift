//
//  Post.swift
//  PocketGram
//
//  Created by Nathan Ireland on 5/21/23.
//

import Foundation

struct postModel{
    var postId = UUID().uuidString
    var userId: String
    var imgUrl: String
    var timestamp: Double
    var username: String
    var userPfp: String
    var commentId = UUID().uuidString
    var likedBy: [String]
    var caption: String
}
