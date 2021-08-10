//
//  GroupListTVC.swift
//  2020072601
//
//  Created by 陳柏文 on 2021/7/26.
//

import UIKit

class GroupListTVC: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let url_server = URL(string: common_url + "Group")
    // 儲存所有資料
    var allGroups = [Group]()
    // 儲存要呈現的資料
    var searchedGroups = [Group]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 下拉刷新
        tableViewAddRefreshControl()
    }
    
    // tableView加上下拉更新功能
    func tableViewAddRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新")
        refreshControl.addTarget(self, action: #selector(showAllGroups), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.text = ""
        showAllGroups()
    }
    
    // searchBar功能
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 如果搜尋條件為空字串，就顯示原始資料；否則就顯示搜尋後結果
        if searchText.isEmpty {
            searchedGroups = allGroups
        } else {
            // 搜尋原始資料內有無包含關鍵字(不區別大小寫)
            searchedGroups = allGroups.filter({ group in
                group.name.uppercased().contains(searchText.uppercased())
            })
        }
        tableView.reloadData()
    }
    
    // 點擊鍵盤上的Search按鈕時將鍵盤隱藏
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // @objc - 可以使用Objective-C
    @objc func showAllGroups() {
        let requestParam = ["action" : "getAll"]
        executeTask(url_server!, requestParam) { data, response, error in
            if error == nil {
                if data != nil {
                    // 查看回傳的資料
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    // 解碼成功後(Group.class格式)，data寫入至table view
                    do {
                        let result = try JSONDecoder().decode([Group].self, from: data!)
                        self.allGroups = result
                        self.searchedGroups = self.allGroups
                        // 將結果顯示在UI元件上必須轉給main thread (取得資料後才設定，以避免view沒有資料可顯示)
                        DispatchQueue.main.async {
                            // 停止下拉更新動作
                            if let control = self.tableView.refreshControl {
                                // 是否刷新動畫進行中
                                if control.isRefreshing {
                                    control.endRefreshing()
                                }
                            }
                            // 抓到資料後重刷table view
                            self.tableView.reloadData()
                        }
                    } catch {
                        print("Decode Error: \(error)")
                    }
                }
            }else {
                print("Response Error: \(error!)")
            }
        }
    }
    
    // @objc - 可以使用Objective-C
    @objc func showFirstMerchImg(_ groupId: Int, _ cell: GroupCell) {
        var image: UIImage?
        var requestParam = [String: Any]()
        requestParam["action"] = "getFirstImageByGroupId"
        requestParam["groupId"] = groupId
        requestParam["number"] = 1
        executeTask(URL(string: common_url + "Merch")!, requestParam) { data, response, error in
            if error == nil {
                if data != nil {
                    // 查看回傳的資料
                    image = UIImage(data: data!)
                    if image != nil {
                        DispatchQueue.main.async { cell.imageGroup.image = image }
                    }else {
                        print("image not found")
                    }
                }
            }else {
                print("Response Error: \(error!)")
            }
        }
    }

    // MARK: - Table view data source
    
    // 定義表格的區塊數，預設值為1
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // 定義一個區塊的列數
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedGroups.count
    }

    // 將資料顯示在儲存格上
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 綁定UI畫面的ID(要去storyboard設定)，轉型GroupCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell") as! GroupCell
        let group = searchedGroups[indexPath.row]
        showFirstMerchImg(group.groupId, cell);

        // add border and color
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        // 設定Cell
        cell.lableName.text = group.name
        cell.lableContactNumber.text = "聯絡電話：\(group.contactNumber)"
        return cell
    }
    
    // Set the spacing between sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    // Make the background color show through
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
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
    
    // 左滑修改與刪除資料
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 左滑時顯示Edit按鈕
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, bool) in
            
        }
        edit.backgroundColor = UIColor.lightGray // 改變背景色
        
        // 左滑時顯示Delete按鈕
        let delete = UIContextualAction(style: .normal, title: "封鎖") { (action, view, bool) in
            // 開啟文字方塊的對話訊息
            let alertController = UIAlertController(title: "封鎖", message: "請輸入封鎖的原因", preferredStyle: .alert)
            
            /* 呼叫addTextField()，系統會自動建立文字方塊 */
            alertController.addTextField {
                /* textField代表系統建立的文字方塊 */
                (textField) in
                /* 設定文字方塊的提示文字 */
                textField.placeholder = "封鎖原因"
            }
            // 進行封鎖
            let ok = UIAlertAction(title: "Ok", style: .default) {_ in
                // 封鎖原因字串
                let reason = alertController.textFields?[0].text ?? ""
                // 封鎖這筆
                var requestParam = [String: Any]()
                requestParam["action"] = "blockadeById"
                requestParam["id"] = self.searchedGroups[indexPath.row].groupId
                requestParam["memberId"] = self.searchedGroups[indexPath.row].memberId
                requestParam["name"] = self.searchedGroups[indexPath.row].name
                requestParam["reason"] = reason
                executeTask(self.url_server!, requestParam) { data, response, error in
                    if error == nil {
                        if data != nil {
                            // 查看回傳的資料
                            print("input: \(String(data: data!, encoding: .utf8)!)")
                            if let result = String(data: data!, encoding: .utf8) {
                                if let count = Int(result) {
                                    // 確定server端刪除資料後，才將client端資料刪除
                                    if count != 0 {
                                        // 抓取要刪除的物件，給allGroups判斷
                                        let group = self.searchedGroups[indexPath.row]
                                        // searchedGroups - remove
                                        self.searchedGroups.remove(at: indexPath.row)
                                        // allGroups - remove
                                        if let index = self.allGroups.firstIndex(of: group) {
                                            self.allGroups.remove(at: index)
                                        }
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
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) {_ in
            }
            alertController.addAction(ok)
            alertController.addAction(cancel)
            // 呈現Alert Controller
            self.present(alertController, animated: true, completion: nil)
        }
        delete.backgroundColor = .red

        // let swipeActions = UISwipeActionsConfiguration(actions: [delete, edit])
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        // true代表滑到底視同觸發第一個動作；false代表滑到底也不會觸發任何動作
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }

    /* 因為拉UITableViewCell與detail頁面連結，所以sender是UITableViewCell */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow
        let group = searchedGroups[indexPath!.row]
        let merchListTVC = segue.destination as! MerchListTVC
        merchListTVC.group = group
    }
    
    @IBAction func clickBackHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
