class Member: Codable{
    
    var id: Int?
    var nickname: String?
    var email: String?
    var password: String?
    var phoneNumber: String?
    var rating: Int?
    var follow_count: Int?
    var followed_count: Int?
    
    internal init(member_Id: Int? = nil, nickname: String? = nil, email: String? = nil, password: String? = nil, phoneNumber: String? = nil, rating: Int? = nil, follow_count: Int? = nil, followed_count: Int? = nil) {
        self.id = member_Id
        self.nickname = nickname
        self.email = email
        self.password = password
        self.phoneNumber = phoneNumber
        self.rating = rating
        self.follow_count = follow_count
        self.followed_count = followed_count
    }
}
