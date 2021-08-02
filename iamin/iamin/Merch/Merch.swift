import Foundation

class Merch: Codable {
    var merchId: Int
    var memberId: Int // 會員ID
    var name: String // 名稱
    var price: Int // 價格
    var merchDesc: String // 商品說明
    var lockCount: Int // 團購選擇了此商品的次數
    
    public init (
        _ merchId: Int,
        _ memberId: Int,
        _ name: String,
        _ price: Int,
        _ merchDesc: String,
        _ lockCount: Int
    ) {
        self.merchId = merchId
        self.memberId = memberId
        self.name = name
        self.price = price
        self.merchDesc = merchDesc
        self.lockCount = lockCount
    }
}
