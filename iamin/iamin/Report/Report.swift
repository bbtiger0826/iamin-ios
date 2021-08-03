class Report: Codable{
    
    
    var report_ID: Int?             //檢舉id
    var report_member_id: Int?      //檢舉的會員id
    var reported_member_id: Int?    //"被"檢舉的會員id
    var report_item: String?        //檢舉項目
    var report_message: String?     //檢舉說明
    
    internal init(report_ID: Int? = nil, report_member_id: Int? = nil, reported_member_id: Int? = nil, report_item: String? = nil, report_message: String? = nil) {
        self.report_ID = report_ID
        self.report_member_id = report_member_id
        self.reported_member_id = reported_member_id
        self.report_item = report_item
        self.report_message = report_message
    }
}
