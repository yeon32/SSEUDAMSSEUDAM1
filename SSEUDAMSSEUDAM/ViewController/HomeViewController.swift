

import UIKit
import SideMenu
import KakaoSDKUser
import Alamofire


class HomeViewController: UIViewController {
    
    // 숨긴 API Key
    private var apiKey: String {
        get {
            // 생성한 .plist 파일 경로 불러오기
            guard let filePath = Bundle.main.path(forResource: "KeyList", ofType: "plist") else {
                fatalError("Couldn't find file 'KeyList.plist'.")
            }
            
            // .plist를 딕셔너리로 받아오기
            let plist = NSDictionary(contentsOfFile: filePath)
            
            // 딕셔너리에서 값 찾기
            guard let value = plist?.object(forKey: "OPENWEATHERMAP_KEY") as? String else {
                fatalError("Couldn't find key 'OPENWEATHERMAP_KEY' in 'KeyList.plist'.")
            }
            return value
        }
    }
    
    
    // MARK: - Properties
    
    var weatherClear = ["☀️플로깅하기 좋은 날이에요☀️","☔️우비를 입어주세요☔️","💨바람이 부니 주의해주세요💨", "🌧비가 올 수도 있어요🌧" ]
    
    var weather: Weather?
    var main: Main?
    var name: String?
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var weatherToWalkLabel: UILabel!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var clearWeather: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
        
    }
    
    // viewwillappear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        weatherInfo(city: "Seoul")
        
    }
    
    func weatherInfo(city:String) {
        WeatherService.shared.getWeatherData(cityName: city){ result in
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    self.weather = weatherResponse.weather.first
                    self.main = weatherResponse.main
                    self.name = weatherResponse.name
                    self.setWeatherUI()
                    self.setKoreanWeather()
                    self.locationCity()
                }
            case .failure(_ ):
                print("error")
            }
        }
    }
    
    func setData() {
        userNameLabel.text = userMainData.shared.loginUser! + String("님")
    }
    
    // 날씨 상태 한국어로
    func setKoreanWeather() {
        if weather!.main == "Clear" {
            clearWeather.text = "맑음"
            weatherToWalkLabel.text = weatherClear[0]
        }
        else if weather!.main == "Rain" {
            clearWeather.text = "비"
            weatherToWalkLabel.text = weatherClear[1]
        }
        else if weather!.main == "Clouds" {
            clearWeather.text = "구름"
            weatherToWalkLabel.text = weatherClear[3]
        }
        else if weather!.main == "Wind" {
            clearWeather.text = "바람"
            weatherToWalkLabel.text = weatherClear[2]
        }
    }
    
    
    // 위치 한국어로
    func locationCity() {
        if name == "Seoul" {
            currentLocationLabel.text = "서울"
        }
    }
    
    // 날씨정보
    private func setWeatherUI() {
        let url = URL(string: "https://openweathermap.org/img/wn/\(self.weather?.icon ?? "00")@2x.png")
        let data = try? Data(contentsOf: url!)
        if let data = data {
            //weatherImageView.image = UIImage(data: data)
        }
        currentLocationLabel.text = "\(name ?? "00")"
        clearWeather.text = "\(weather!.main)"
        currentTempLabel.text = "\(main!.temp)"
        maxTempLabel.text = "\(main!.temp_max)"
        minTempLabel.text = "\(main!.temp_min)"
    }
    
    
    
    
    
    // MARK: - IBAction
    // SideMenu
    
    
    @IBAction func didTapSideMenuBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)  //nil
        
        //사이드메뉴 뷰컨트롤러 객체 생성
        let SideMenuViewController: SideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
        
        //커스텀 네비게이션이랑 사이드메뉴 뷰컨트롤러 연결
        let menu = CustomSideMenuNavigation(rootViewController: SideMenuViewController)
        
        //보여주기
        present(menu, animated: true, completion: nil)
    }
    
    
    @IBAction func didTapLogoutBtn(_ sender: Any) {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                // 로그아웃 성공
                print("logout() success.")
                
                // 현재 위치에서 'ViewController'가 있는 곳으로 이동, 그 사이의 VC는 stack에서 사라지게 됨
                let controllers = self.navigationController?.viewControllers
                for vc in controllers! {
                    if vc is ViewController {
                        _ = self.navigationController?.popToViewController(vc as! ViewController, animated: true)
                    }
                }
                print("로그아웃버튼누름")
            }
        }
    }
}
