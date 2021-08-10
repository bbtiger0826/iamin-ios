//
//  ResetPhone.swift
//  iamin
//
//  Created by 王靖渝 on 2021/8/5.
//

import UIKit

class ResetPhoneTVC: UITableViewController {

    var resetPhone: ResetPhone!
    var resetPhones = [ResetPhone]()
    var member: Member!
    
    let url_server = URL(string: common_url + "memberController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showMember()
    }
    
    @IBAction func clickHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showMember(){
        var requestParam = [String: String]()
        requestParam["action"] = "getResetMemberInfo"
        requestParam["member"] = try! String(data: JSONEncoder().encode(member), encoding: .utf8)
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    do {
                        let result = try JSONDecoder().decode([ResetPhone].self, from: data!)
                        self.resetPhones = result
                        // 將結果顯示在UI元件上必須轉給main thread (取得資料後才設定，以避免view沒有資料可顯示)
                        DispatchQueue.main.async {

                            
                            // 抓到資料後重刷table view
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("Decode Error: \(error)")
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resetPhones.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "ResetPhoneCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ResetPhoneCell
        let resetPhone = resetPhones[indexPath.row]
        cell.lbEmail.text = "電子郵件: \(resetPhone.email!)"
        cell.lbId.text = String(resetPhone.member_id)
        cell.lbName.text = "會員名稱: \(resetPhone.nickname)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "重置") { (action, view, bool) in
            let url_server_member = URL(string: common_url + "memberController")
            var requestParam = [String: Any]()
            requestParam["action"] = "resetPhoneNumber"
            requestParam["member"] = try! String(data: JSONEncoder().encode(self.member), encoding: .utf8)
            requestParam["resetPhone"] = try! String(data: JSONEncoder().encode(self.resetPhones[indexPath.row]), encoding: .utf8)
            executeTask(url_server_member!, requestParam) { data, response, error in
                if error == nil {
                    if data != nil {
                        // 查看回傳的資料
                        print("input: \(String(data: data!, encoding: .utf8)!)")
                        if let result = String(data: data!, encoding: .utf8) {
                            if let count = Int(result) {
                                // 確定server端刪除資料後，才將client端資料刪除
                                if count != 0 {
                                    // resetPhones - remove
                                    self.resetPhones.remove(at: indexPath.row)
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
        
        
        let swipeActions = UISwipeActionsConfiguration(actions: [edit])
        // true代表滑到底視同觸發第一個動作；false代表滑到底也不會觸發任何動作
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}