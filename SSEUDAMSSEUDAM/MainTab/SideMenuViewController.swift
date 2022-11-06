

import UIKit
import KakaoSDKUser

class SideMenuViewController : UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    
    
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    
    // MARK: - Function
    func setData() {
        profileImageView.image = userMainData.shared.profileImage
        userNameLabel.text = userMainData.shared.userName
        userTypeLabel.text = userMainData.shared.userType
        
        // 이미지 동그랗게
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        
        // navigationbar hidden
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
}
