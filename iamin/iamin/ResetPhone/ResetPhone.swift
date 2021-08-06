//
//  ResetPhone.swift
//  iamin
//
//  Created by 王靖渝 on 2021/8/5.
//
import Foundation

class ResetPhone : Codable{
    
    var reset_id: Int
    var member_id: Int
    var nickname: String
    var email: String?
    var startTime: String
    
    init(reset_id: Int, member_id: Int, nickname: String, email: String, startTime: String) {
        self.reset_id = reset_id
        self.member_id = member_id
        self.nickname = nickname
        self.email = email
        self.startTime = startTime
    }
    
}
