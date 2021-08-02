import Foundation
import UIKit

// 實機
// let URL_SERVER = "http://192.168.0.101:8080/Spot_MySQL_Web/"
// 模擬器
let common_url = "http://127.0.0.1:8080/iamin_JavaServlet/"

func executeTask(_ url_server: URL, _ requestParam: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    // 檢查將要request的資料
    print("output: \(requestParam)")
    // 建立JSON data -> (請求參參數 轉 JSON data)
    // requestParam值為Any就必須使用JSONSerialization.data()，而非JSONEncoder.encode()
    let jsonData = try! JSONSerialization.data(withJSONObject: requestParam)
    // 建立請求物件
    var request = URLRequest(url: url_server)
    // 設定請求⽅方式 -> (POST)
    request.httpMethod = "POST"
    // 設定cache⽅方式 -> (不使用cache)
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    // 請求參數為JSON data，無需再轉成JSON字串
    request.httpBody = jsonData
    // 建立連線並發出請求，取得結果後會呼叫closure執行後續處理
    let sessionData = URLSession.shared
    let task = sessionData.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
}
