import UIKit

class ReportVC: UITableViewController {
    @IBOutlet weak var lbMessage: UILabel!
    var repoet: Report!
    var member: Member!
    var requestParam = [String: String]()
    //儲存所有資料
    var allreports = [Report]()
    
    let url_server = URL(string: common_url + "Report")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var reportedid = member.id
        requestParam["action"] = "membersreport"
        requestParam["reportedid"] = String(reportedid!)
        showMembers(requestParam)
    }

    
    // 左滑修改與刪除資料
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 左滑時顯示Edit按鈕
        let edit = UIContextualAction(style: .normal, title: "封鎖") { (action, view, bool) in
            let url_server_member = URL(string: common_url + "memberController")
            var requestParam = [String: Any]()
            
            requestParam["action"] = "delete"
            requestParam["member"] = try! String(data: JSONEncoder().encode(self.member), encoding: .utf8)
            requestParam["reportid"] = self.allreports[indexPath.row].report_id
            executeTask(url_server_member!, requestParam) { data, response, error in
                if error == nil {
                    if data != nil {
                        // 查看回傳的資料
                        print("input: \(String(data: data!, encoding: .utf8)!)")
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                // 確定server端刪除資料後，才將client端資料刪除
                                if count != 0 {
                                    // allGroups - remove
                                    self.allreports.remove(at: indexPath.row)
                                    // UI - remove
                                    DispatchQueue.main.async {
                                        tableView.deleteRows(at: [indexPath], with: .fade)
                                    }
                                }
                            }
                        }
                    }
                }else {
                    print("Response Error: \(error!)")
                }
            }
        }

        edit.backgroundColor = UIColor(red: 141/255, green: 64/255, blue: 255/255, alpha: 1) // 改變背景色
        
        // 左滑時顯示Delete按鈕
        let delete = UIContextualAction(style: .normal, title: "刪除") { (action, view, bool) in
            var requestParam = [String: Any]()
            requestParam["action"] = "deleteByreportid"
            requestParam["reportid"] = self.allreports[indexPath.row].report_id
            executeTask(self.url_server!, requestParam) { data, response, error in
                if error == nil {
                    if data != nil {
                        // 查看回傳的資料
                        print("input: \(String(data: data!, encoding: .utf8)!)")
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                // 確定server端刪除資料後，才將client端資料刪除
                                if count != 0 {
                                    // allGroups - remove
                                    self.allreports.remove(at: indexPath.row)
                                    // UI - remove
                                    DispatchQueue.main.async {
                                        tableView.deleteRows(at: [indexPath], with: .fade)
                                    }
                                }
                            }
                        }
                    }
                }else {
                    print("Response Error: \(error!)")
                }
            }
        }
        delete.backgroundColor = .red

        let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit])
        // true代表滑到底視同觸發第一個動作；false代表滑到底也不會觸發任何動作
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
        
    
    func showMembers(_ requestParam: [String: String]) {
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? JSONDecoder().decode([Report].self, from: data!) {
                        self.allreports = result
                        DispatchQueue.main.async {
                            /* 抓到資料後重刷table view */
                            self.tableView.reloadData()
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    
    /* UITableViewDataSource的方法，定義表格的區塊數，預設值為1 */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /* UITableViewDataSource的方法，定義一個區塊的列數 (required) */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allreports.count
    }
    
    /* UITableViewDataSource的方法，將資料顯示在儲存格上 */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* cellId必須與storyboard內UITableViewCell的Identifier相同(Attributes inspector) */
        let cellId = "reportCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ReportCell
        let report = allreports[indexPath.row]
        let index = indexPath.row + 1
        cell.lb_number.text = String(index)
        cell.lb_title.text = "檢舉項目:"
        cell.lb_title.textColor = UIColor.link
        cell.lb_report_title.text = report.report_item
        cell.lb_message.text = "檢舉說明:"
        cell.lb_message.textColor = UIColor.link
        cell.lb_report_message.text = report.report_message
        cell.lb_repoer_member.text = "檢舉人ID:"
        cell.lb_repoer_member.textColor = UIColor.link
        cell.lb_report_member_id.text = String(report.member_id!)
        return cell
    }
}
