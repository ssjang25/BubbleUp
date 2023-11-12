//
//  Post.swift
//  BubbleUp
//
//  Created by sarah jang on 11/11/23.
//

import Foundation

struct Post: Codable {
    var user: String = ""
    var content: String = ""
    var eventTime: String = ""
    var participants: [String]?
    var location: [Int]?
}
