//
//  AllMemberTVC.swift
//  iamin
//
//  Created by 王靖渝 on 2021/8/4.
//

import UIKit

class AllMemberTVC: UITableViewController, UISearchBarDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var member: Member!
    var members = [Member]()
    // 儲存要呈現的資料
    var searchMembers = [Member]()
    let url_server = URL(string: common_url + "memberController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showMembers()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text ?? ""
            print("text: \(text)")
        if text.isEmpty{
            searchMembers = members
        }else{
            // 搜尋原始資料內有無包含關鍵字(不區別大小寫)
            searchMembers = members.filter({ (member) -> Bool in
                return member.email!.uppercased().contains(text.uppercased())
            })
        }
        tableView.reloadData()
    }
    
    func showMembers() {
        var requestParam = [String: String]()
        requestParam["action"] = "selectAllSuspendMember"
        requestParam["member"] = try! String(data: JSONEncoder().encode(member), encoding: .utf8)
        executeTask(url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    // 將輸入資料列印出來除錯用
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    if let result = try? JSONDecoder().decode([Member].self, from: data!) {
                        self.members = result
                        self.searchMembers = self.members
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow
        let member = searchMembers[indexPath!.row]
        let suspendMemberVC = segue.destination as! SuspendMemberVC
        suspendMemberVC.member = member
    }
    
    @IBAction func clickHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchMembers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "allMemberCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! AllMemberCell
        let member = searchMembers[indexPath.row]
//        let member = members[indexPath.row]
//        let index = indexPath.row + 1
//        cell.lbID.text = String (member.id!)
        cell.lbEmail.text = member.email!
        cell.lbName.text = member.nickname!
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
}
