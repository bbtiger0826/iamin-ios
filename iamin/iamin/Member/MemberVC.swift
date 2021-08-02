//
//  ViewController.swift
//  MyApp_report
//
//  Created by 林以樂 on 2021/7/28.
//

import UIKit

class MemberVC: UITableViewController {

    var members = [Member]()
    let url_server = URL(string: common_url + "Report")
    override func viewDidLoad() {
        super.viewDidLoad()
        let requestParam = ["action" : "reportedmember"]
        showMembers(requestParam)
    }
    
    func showMembers(_ requestParam: [String: String]) {
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    
                    if let result = try? JSONDecoder().decode([Member].self, from: data!) {
                        self.members = result
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
        return members.count
    }
    
    /* UITableViewDataSource的方法，將資料顯示在儲存格上 */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* cellId必須與storyboard內UITableViewCell的Identifier相同(Attributes inspector) */
        let cellId = "memberCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MemberCell
        let member = members[indexPath.row]
        cell.memberimage.image = UIImage(named: "google")
        cell.lbnickname.text = member.nickname
        cell.lbemail.text = member.email
        cell.lbphoneNumber.text = member.phoneNumber
        return cell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let indexPath = tableView.indexPathForSelectedRow {
//            let book = members[indexPath.row]
//            let detailVC = segue.destination as! DetailVC
//            detailVC.book = book
//        }
//    }

}

