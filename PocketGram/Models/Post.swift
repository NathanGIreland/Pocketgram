//
//  Post.swift
//  PocketGram
//
//  Created by Nathan Ireland on 5/21/23.
//

import Foundation

struct postModel{
    var postId = 0
    var userId: String
    var imgUrl: String
    var timestamp: Double
    var username: String
    var userPfp: String
    var commentIds = [String]()
    var likedBy = [String]()
    var caption: String
}
