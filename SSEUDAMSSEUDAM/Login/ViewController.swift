

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class ViewController: UIViewController {

    
    @IBOutlet weak var kakaoLoginBtn: UIButton!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    
    @IBAction func didTapLoginBtn(_ sender: Any) {
        
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                // 로그인 성공
                print("loginWithKakaoAccount() success.")
                
                // 액세스 토큰
                _ = oauthToken
                let accessToken = oauthToken?.accessToken
                
                // 로그인 성공시, 'UserInfoVC' 선언
                guard let dvc = self.storyboard?.instantiateViewController(identifier: "UserInfoViewController") as? UserInfoViewController else {return}
                
                // 카카오 로그인을 통해 사용자 토큰을 발급 받은 후 사용자 관리 API 호출
                UserApi.shared.me() {(user, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        // 사용자 정보 가져옴
                        print("me() success.")
                        
                        _ = user
                        // 사용자의 닉네임을 받아 'nameLabel'에 넣어줌
                        dvc.nameLabel = user?.kakaoAccount?.profile?.nickname
                        
                        // 사용자의 정보를 싱글톤으로 선언한 구조체에 넣어주어 어디든 접근 가능하게 함
                        userMainData.shared.loginUser = user?.kakaoAccount?.profile?.nickname
                    }
                    
                    // 'UserInfoViewDontroller' 호출
                    self.navigationController?.pushViewController(dvc, animated: true)
                }
            }
        }
    }
    

}

