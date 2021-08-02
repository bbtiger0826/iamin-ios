import Foundation

class Group: Codable, Equatable {
    var groupId: Int
    var memberId: Int
    var name: String // 標題
    var progress: Int // 目標進度
    var goal: Int // 目標
    var categoryId: Int // 類別ID
    var groupItem: String // 團購項目
    var contactNumber: String // 聯絡電話
    var paymentMethod: Int // 收款方式 (1.面交 2.信用卡 3.兩者皆可)
    var groupStatus: Int // 團購狀態 (1.揪團中 2.達標 3.失敗or放棄)
    var caution: String? // 注意事項
    var privacyFlag: Bool // 隱私設定
    var totalAmount: Int // 總金額
    var amount: Int // 目前收款金額
    var conditionCount: Int // 停單條件(份數)
    var conditionTime: String? // 停單條件(時間)
    
    public init(
        _ groupId: Int,
        _ memberId: Int,
        _ name: String,
        _ progress: Int,
        _ goal: Int,
        _ categoryId: Int,
        _ groupItem: String,
        _ contactNumber: String,
        _ paymentMethod: Int,
        _ groupStatus: Int,
        _ caution: String,
        _ privacyFlag: Bool,
        _ totalAmount: Int,
        _ amount: Int,
        _ conditionCount: Int,
        _ conditionTime: String
    ) {
        self.groupId = groupId
        self.memberId = memberId
        self.name = name
        self.progress = progress
        self.goal = goal
        self.categoryId = categoryId
        self.groupItem = groupItem
        self.contactNumber = contactNumber
        self.paymentMethod = paymentMethod
        self.groupStatus = groupStatus
        self.caution = caution
        self.privacyFlag = privacyFlag
        self.totalAmount = totalAmount
        self.amount = amount
        self.conditionCount = conditionCount
        self.conditionTime = conditionTime
    }
    
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.name == rhs.name
    }
}
