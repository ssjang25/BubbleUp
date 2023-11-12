import Foundation
struct Account: Codable{
    var _id:String = ""
    var phoneNumber:String = ""
    var username: String = ""
    var password: String = ""
    var friends:[String]
    var __v: Int = 0
    var currentPost:String = ""
}
