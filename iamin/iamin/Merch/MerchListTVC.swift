//
//  MerchListTVC.swift
//  2020072601
//
//  Created by 陳柏文 on 2021/7/26.
//

import UIKit

class MerchListTVC: UITableViewController {
    var group: Group!
    var merchs = [Merch]()
    let url_server = URL(string: common_url + "Merch")
    var pageNum = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showAllMerchs()
    }
    
    // @objc - 可以使用Objective-C
    @objc func showAllMerchs() {
        var requestParam = [String: Any]()
        requestParam["action"] = "getAllByGroupId"
        requestParam["groupId"] = group.groupId
        executeTask(url_server!, requestParam) { data, response, error in
            if error == nil {
                if data != nil {
                    // 查看回傳的資料
                    print("input: \(String(data: data!, encoding: .utf8)!)")
                    // 解碼成功後(Group.class格式)，data寫入至table view
                    do {
                        let result = try JSONDecoder().decode([Merch].self, from: data!)
                        self.merchs = result
                        // 將結果顯示在UI元件上必須轉給main thread (取得資料後才設定，以避免view沒有資料可顯示)
                        DispatchQueue.main.async {
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
    @objc func showImage(_ requestParam: [String: Any], _ cell: MerchCell) {
        var image: UIImage?
        executeTask(url_server!, requestParam) { data, response, error in
            if error == nil {
                if data != nil {
                    // 查看回傳的資料
                    image = UIImage(data: data!)
                    if image != nil {
                        switch requestParam["number"] as! Int {
                        case 1:
                            DispatchQueue.main.async { cell.image1.image = image }
                            DispatchQueue.main.async { cell.page.numberOfPages = 1 }
                        case 2:
                            DispatchQueue.main.async { cell.image2.image = image }
                            DispatchQueue.main.async { cell.page.numberOfPages = 2 }
                        case 3:
                            DispatchQueue.main.async { cell.image3.image = image }
                            DispatchQueue.main.async { cell.page.numberOfPages = 3 }
                        case 4:
                            DispatchQueue.main.async { cell.image4.image = image }
                            DispatchQueue.main.async { cell.page.numberOfPages = 4 }
                        case 5:
                            DispatchQueue.main.async { cell.image5.image = image }
                            DispatchQueue.main.async { cell.page.numberOfPages = 5 }
                        default:
                            break
                        }
                    }else {
                        print("image not found")
                        switch requestParam["number"] as! Int {
                        case 1:
                            DispatchQueue.main.async { cell.image1.isHidden = true }
                        case 2:
                            DispatchQueue.main.async { cell.image2.isHidden = true }
                        case 3:
                            DispatchQueue.main.async { cell.image3.isHidden = true }
                        case 4:
                            DispatchQueue.main.async { cell.image4.isHidden = true }
                        case 5:
                            DispatchQueue.main.async { cell.image5.isHidden = true }
                        default:
                            break
                        }
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
        return merchs.count
    }

    // 將資料顯示在儲存格上
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 綁定UI畫面的ID(要去storyboard設定)，轉型GroupCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MerchCell") as! MerchCell
        let merch = merchs[indexPath.row]

        // 設定Cell
        cell.lableName.text = merch.name
        cell.lablePrice.text = "\(String(merch.price)) 元"
        cell.lableMerchDesc.text = merch.merchDesc
        
        var requestParam = [String: Any]()
        //  圖片1
        requestParam["action"] = "getImageForIos"
        requestParam["id"] = merch.merchId
        requestParam["number"] = 1
        showImage(requestParam, cell)
        //  圖片2
        requestParam["action"] = "getImageForIos"
        requestParam["id"] = merch.merchId
        requestParam["number"] = 2
        showImage(requestParam, cell)
        //  圖片3
        requestParam["action"] = "getImageForIos"
        requestParam["id"] = merch.merchId
        requestParam["number"] = 3
        showImage(requestParam, cell)
        //  圖片4
        requestParam["action"] = "getImageForIos"
        requestParam["id"] = merch.merchId
        requestParam["number"] = 4
        showImage(requestParam, cell)
        //  圖片5
        requestParam["action"] = "getImageForIos"
        requestParam["id"] = merch.merchId
        requestParam["number"] = 5
        showImage(requestParam, cell)
        //
        cell.scrollView.tag = indexPath.row
        // add border and color
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }
    //
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNum = scrollView.contentOffset.x / scrollView.bounds.width
        let cell = tableView.cellForRow(at: IndexPath(row: scrollView.tag, section: 0)) as! MerchCell
        cell.page.currentPage = Int(pageNum)
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
}
