
import UIKit

class AdminLogin: UIViewController {

    let userDefault = UserDefaults()
    
    @IBOutlet weak var tfAccount: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tvResult: UITextView!
    
//    let url_server = URL(string: "http://192.168.0.79:8080/iamin_JavaServlet/memberController")
    let url_server = URL(string: common_url + "memberController")
    

    
    var id: Int?
    var account: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(userDefault.value(forKey: "Account") ?? "nothing")
        print(userDefault.value(forKey: "Password") ?? "nothing")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        autoLogin()
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        
        account = tfAccount.text == nil ? "" : tfAccount.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        password = tfPassword.text == nil ? "" : tfPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if account!.isEmpty || password!.isEmpty {
            tvResult.text = "請輸入帳號及密碼"
            return
        }
        
        let admin = Admin(0, account!, password!)

        var requestParam = [String: String]()
        requestParam["action"] = "adminLogin"
        requestParam["member"] = try! String(data: JSONEncoder().encode(admin), encoding: .utf8)
        executeTask(url_server!, requestParam)
        
        
        
    }
    
    @IBAction func clickClear(_ sender: Any) {
        tfAccount.text = ""
        tfPassword.text = ""
        tvResult.text = ""
    }
    
    //連線
    func executeTask(_ url_server: URL, _ requestParam: [String: String]) {
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
                    
                    
                    
                    // 將結果顯示在UI元件上必須轉給main thread
                    DispatchQueue.main.async {
                        self.showResult(data!)
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        task.resume()
    }
    
    func showResult(_ jsonData: Data) {
        do{
            let result = try JSONDecoder().decode(Admin.self, from: jsonData)
            tvResult.text = "id: \(result.id)\nAccount: \(result.account)"
            if(result.id > 0){
                if(account != nil){
                    userDefault.setValue(account, forKey: "Account")
                    userDefault.setValue(password, forKey: "Password")
                }
                if let groupNav = storyboard?.instantiateViewController(withIdentifier: "functionPage") {
                    groupNav.modalPresentationStyle = .fullScreen
                    present(groupNav, animated: true, completion: nil)
                }
            }
        }catch{
            print("Decode Error : \(error)")
        }
    }
    
    func autoLogin(){
        let defaultAccount = userDefault.value(forKey: "Account") as? String
        let defaultPassword = userDefault.value(forKey: "Password") as? String
        let admin = Admin(0, defaultAccount ?? "", defaultPassword ?? "")
        var requestParam = [String: String]()
        requestParam["action"] = "adminLogin"
        requestParam["member"] = try! String(data: JSONEncoder().encode(admin), encoding: .utf8)
        executeTask(url_server!, requestParam)
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
