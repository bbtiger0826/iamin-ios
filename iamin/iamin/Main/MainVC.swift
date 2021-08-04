import UIKit
import CoreGraphics

class MainVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fullScreenSize :CGSize!
    var mains: [Main]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mains = getMains()
        // 取得螢幕的尺寸
        fullScreenSize = UIScreen.main.bounds.size
        // 設定UICollectionView背景色
//        collectionView.backgroundColor = UIColor.white
        // 取得UICollectionView排版物件
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        // 設定內容與邊界的間距
        layout.sectionInset = UIEdgeInsets(top: 25, left: 5, bottom: 25, right: 5);
        // 設定每一列的間距
        layout.minimumLineSpacing = 25
        // 設定每個項目的尺寸
        layout.itemSize = CGSize(
            width: CGFloat(fullScreenSize.width)/3 - 10.0,
            height: CGFloat(fullScreenSize.width)/3 - 10.0)
        // 設定header及footer的尺寸
        layout.headerReferenceSize = CGSize(
            width: fullScreenSize.width, height: 40)
//        layout.footerReferenceSize = CGSize(
//            width: fullScreenSize.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mains.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let main = mains[indexPath.row]
        let cellId = "mainCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MainCell
        cell.imageView.image = main.image
        cell.label.text = main.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /* identifier必須設定與Indentity inspector的Storyboard ID相同 */
        switch indexPath.row {
        case 0:
            if let groupNav = storyboard?.instantiateViewController(withIdentifier: "groupNav") {
                groupNav.modalPresentationStyle = .fullScreen
                present(groupNav, animated: true, completion: nil)
            }
        case 1:
            if let groupNav = storyboard?.instantiateViewController(withIdentifier: "memberNav") {
                groupNav.modalPresentationStyle = .fullScreen
                present(groupNav, animated: true, completion: nil)
            }
        case 2:
            if let groupNav = storyboard?.instantiateViewController(withIdentifier: "AllmemberNav") {
                groupNav.modalPresentationStyle = .fullScreen
                present(groupNav, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    // 設定header / footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView = UICollectionReusableView()
        
        // 顯示文字
        let label = UILabel(frame: CGRect(
            x: 0, y: 0,
            width: fullScreenSize.width, height: 40))
        label.textAlignment = .center
        label.font = label.font.withSize(24)

        // 取得元件屬於header/footer，就依照當初storyboard設定的ID來取得對應物件
        if kind == UICollectionView.elementKindSectionHeader {
            // 依據前面註冊設定的識別名稱 "header" 取得目前使用的 header
            reusableView =
                collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: "header",
                    for: indexPath)
            // 設定header的內容
            reusableView.backgroundColor = UIColor.cyan
            reusableView.backgroundColor = UIColor(red: 175/255.0, green: 143/255.0, blue: 255/255.0, alpha: 1)
            label.text = "管理者系統";
            label.textColor = UIColor.white

        } else if kind == UICollectionView.elementKindSectionFooter {
            reusableView =
                collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionFooter,
                    withReuseIdentifier: "footer",
                    for: indexPath)
            // 設定footer內容
            reusableView.backgroundColor = UIColor.lightGray
            label.text = "My Footer";
            label.textColor = UIColor.black
        }

        reusableView.addSubview(label)
        return reusableView
    }
    
    // 取得測試資料
    func getMains() -> [Main] {
        var mains = [Main]()
        mains.append(Main(name: "團購檢查", image: UIImage(named: "checkgroup.png")!))
        mains.append(Main(name: "會員檢查", image: UIImage(named: "checkmember.png")!))
        mains.append(Main(name: "復權會員", image: UIImage(named: "checkmember.png")!))
        
        return mains
    }
    @IBAction func clickLogout(_ sender: Any) {
        let userDefault = UserDefaults()
        userDefault.removeObject(forKey: "Account")
        userDefault.removeObject(forKey: "Password")
        if let groupNav = storyboard?.instantiateViewController(withIdentifier: "Login") {
            groupNav.modalPresentationStyle = .fullScreen
            present(groupNav, animated: true, completion: nil)
        }
        
    }
}
