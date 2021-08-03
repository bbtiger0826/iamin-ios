class Admin: Codable{
    
    var id: Int
    var account: String
    var password: String
    
    public init(_ id: Int,_ account: String,_ password: String) {
        self.id = id
        self.account = account
        self.password = password
    }
    
}
