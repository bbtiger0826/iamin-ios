import UIKit

class ReportVC: UITableViewController {
    @IBOutlet weak var lbMessage: UILabel!
    var repoet: Report!
    var member: Member!
    var requestParam = [String: String]()
    var reports = [Report]()
    let url_server = URL(string: common_url + "Report")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var reportedid = member.id
        requestParam["action"] = "membersreport"
        requestParam["reportedid"] = String(reportedid!)
        showMembers(requestParam)
    }
    
    func showMembers(_ requestParam: [String: String]) {
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? JSONDecoder().decode([Report].self, from: data!) {
                        self.reports = result
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
        return reports.count
    }
    
    /* UITableViewDataSource的方法，將資料顯示在儲存格上 */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* cellId必須與storyboard內UITableViewCell的Identifier相同(Attributes inspector) */
        let cellId = "reportCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ReportCell
        let report = reports[indexPath.row]
        cell.lb_title.text = "檢舉項目:"
        cell.lb_title.textColor = UIColor.blue
        cell.lb_report_title.text = report.report_item
        cell.lb_message.text = "檢舉說明:"
        cell.lb_message.textColor = UIColor.blue
        cell.lb_report_message.text = report.report_message
        return cell
    }

}
