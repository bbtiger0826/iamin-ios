//
//  SuspendMember.swift
//  iamin
//
//  Created by 王靖渝 on 2021/8/4.
//

import UIKit

class SuspendMemberVC: UIViewController {

    var member: Member!
    
    let url_server = URL(string: common_url + "memberController")
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lbID: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbID.text = "會員編號: \(String(member.id!))"
        lbName.text = "會員名稱: \(member.nickname!)"
        lbEmail.text = "電子郵件: \(member.email!)"
        getImage()
    }
    
    
    
    func getImage(){
        var requestParam = [String: String]()
        var image: UIImage?
        requestParam["action"] = "getImage"
        requestParam["member"] = try! String(data: JSONEncoder().encode(member), encoding: .utf8)
        executeTask(self.url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    image = UIImage(data: data!)
                    if image != nil {
                        DispatchQueue.main.async {self.imageView.maskCircle(anyImage: image!)}
                    }else{
                        print("no image")
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func clickRemoveSuspend(_ sender: Any) {
        var requestParam = [String: String]()
        requestParam["action"] = "RemoveSuspend"
        requestParam["member"] = try! String(data: JSONEncoder().encode(member), encoding: .utf8)
        executeTask_removeSuspend(url_server!, requestParam)
        
    }
    
    //連線
    func executeTask_removeSuspend(_ url_server: URL, _ requestParam: [String: String]) {
        // 將輸出資料列印出來除錯用
        print("output: \(requestParam)")
        // 編碼成json
        let jsonData = try! JSONEncoder().encode(requestParam)
        var request = URLRequest(url: url_server)
        request.httpMethod = "POST"
        // 不使用cache
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
        // 請求參數為JSON data，無需再轉成JSON字串
        request.httpBody = jsonData
        let session = URLSession.shared
        // 建立連線並發出請求，取得結果後會呼叫closure執行後續處理
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    //回上一頁
                    DispatchQueue.main.async {
                     self.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        task.resume()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//UIimage變圓
extension UIImageView {
  public func maskCircle(anyImage: UIImage) {
    self.contentMode = UIView.ContentMode.scaleAspectFill
    self.layer.cornerRadius = self.frame.height / 2
    self.layer.masksToBounds = false
    self.clipsToBounds = true

   // make square(* must to make circle),
   // resize(reduce the kilobyte) and
   // fix rotation.
   self.image = anyImage
  }
}
