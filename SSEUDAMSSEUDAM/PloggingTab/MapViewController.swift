

import UIKit
import MapKit
import RealmSwift
import CoreLocation
import CoreMotion

class MapViewController : UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var resultTimeLabel: UILabel!
    @IBOutlet weak var resultDistanceLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    

    let localRealm = try! Realm()
    let locationManager: CLLocationManager = CLLocationManager()
    let fileManager = FileManager()
    let motionManager = CMMotionActivityManager()
    
    var currentOverlay: MKPolyline = MKPolyline()
    var previousCoordinate: CLLocationCoordinate2D?
    var points: [CLLocationCoordinate2D] = []
    var runMode:RunMode = .ready
    var recordImage: UIImage = UIImage()
    var totalDistance: CLLocationDistance = CLLocationDistance()
    var totalRunTime: String = ""
    var timer = Timer()
    var (hours, minutes, seconds, fractions) = (0, 0, 0, 0)
    var finalData: Data = Data()
    var recordMemo: String = ""
    var startTime: Date = Date()
    var endTime: Date = Date()
    
   

    
    // MARK: - LifeCycle
    
        override func viewDidLoad() {
            super.viewDidLoad()
            let currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0, longitude: locationManager.location?.coordinate.longitude ?? 0)
            
            setLocationManager()
            setMap(currentLocation: currentLocation)
            setNotifications()
            setMotionManager()
        }
    
    
    
    
    
    // MARK: - Function
    
    func setMotionManager() {
        motionManager.startActivityUpdates(to: .main) { activity in
            guard let activity = activity else { return }
            
            if self.runMode == .running{
                if activity.stationary == false {
                    self.locationManager.startUpdatingLocation()
                } else {
                    self.locationManager.stopUpdatingLocation()
                }
            }
        }
    }
    
    
    //지도 나타내기
    func setMap(currentLocation: CLLocationCoordinate2D) {
        mapView.setRegion(MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.delegate = self
    }
    
    func setLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
    }
    
    

    
    //맵 사진 찍기
    func generateMapImage() {
        let options = MKMapSnapshotter.Options()
        options.region = MKCoordinateRegion(coordinates: self.points)!
        options.size = CGSize(width: 240, height: 240)
        options.showsBuildings = true
        
        MKMapSnapshotter(options: options).start { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            let mapImage = snapshot.image
            let finalImage = UIGraphicsImageRenderer(size: mapImage.size).image { _ in
                mapImage.draw(at: .zero)
                let coordinates = self.points
                let points2 = coordinates.map { coordinate in
                    snapshot.point(for: coordinate)
                }
                
                let path = UIBezierPath()
                path.move(to: points2[0])
                
                for point in points2.dropFirst() {
                    path.addLine(to: point)
                }
                
                path.lineWidth = 7
                UIColor(named: "polyline_purple")!.setStroke()
                path.stroke()
            }
            
            self.recordImage = finalImage
        }
    }
    
    
    @objc func addbackGroundTime(_ notification:Notification) {
        if runMode == .running {
            let time = notification.userInfo?["time"] as? Int ?? 0
            hours += time / 3600
            let leftTime = time % 3600
            minutes += leftTime / 60
            seconds += leftTime % 60
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MapViewController.keepTimer), userInfo: nil, repeats: true)
        }
    }
    
    
    @objc func stopTimer() {
        timer.invalidate()
    }
    
    
    func setNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(addbackGroundTime(_:)), name: NSNotification.Name("sceneWillEnterForeground"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopTimer), name: NSNotification.Name("sceneDidEnterBackground"), object: nil)
    }
    
    func checkUserLocationServicesAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authorizationStatus: authorizationStatus)
        }
    }
    
    func checkCurrentLocationAuthorization(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .restricted:
            goSetting()
        case .denied:
            goSetting()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            print("unknown")
        }
        
        if #available(iOS 14.0, *) {
            let accuracyState = locationManager.accuracyAuthorization
            switch accuracyState {
            case .fullAccuracy:
                print("full")
            case .reducedAccuracy:
                print("reduced")
            @unknown default:
                print("Unknown")
            }
        }
    }
    
    func goSetting() {
        let alert = UIAlertController(title: "위치권한 요청", message: "러닝 거리 기록을 위해 항상 위치 권한이 필요합니다.", preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "설정", style: .default) { action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(settingAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserLocationServicesAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkUserLocationServicesAuthorization()
    }
        
    @objc func keepTimer() {
        seconds += 1
        if seconds >= 60 {
            minutes += seconds/60
            seconds = seconds%60
        }
        
        if minutes >= 60 {
            hours += minutes/60
            minutes = minutes%60
        }
        
        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        let hoursString = hours > 9 ? "\(hours)" : "0\(hours)"
        
        totalRunTime = "\(hoursString):\(minutesString):\(secondsString)"
        self.resultTimeLabel.text = self.totalRunTime
    }
    
   
    //기록 저장 알람
    func showSaveAlert() {
        let alert = UIAlertController(title: "기록 저장하기", message: "이 기록에 메모를 남겨주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "저장", style: .default) { action in
            lazy var data = self.recordImage.jpegData(compressionQuality: 0.1)!
            let task = RecordObject(image: data, distance: self.totalDistance, time: self.totalRunTime, memo: alert.textFields?[0].text ?? "")
            try! self.localRealm.write {
                self.localRealm.add(task)
            }
        }
        
        let cancelAction = UIAlertAction(title: "기록 삭제", style: .destructive)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        
        present(alert, animated: true)
    }
   
    
    func resetLabel() {
        self.resultTimeLabel.text = "00:00:00"
        self.resultDistanceLabel.text = "0.0km"
    }
    
    
    
    
    
    // MARK: - IBAction
    
    @IBAction func runButtonClicked(_ sender: UIButton) {
        if runMode == .ready {
            let authorizationStatus: CLAuthorizationStatus
            if #available(iOS 14, *) {
                authorizationStatus = locationManager.authorizationStatus
            } else {
                authorizationStatus = CLLocationManager.authorizationStatus()
            }
            
            checkCurrentLocationAuthorization(authorizationStatus: authorizationStatus)
            
            if authorizationStatus == .authorizedAlways {
                resetLabel()
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MapViewController.keepTimer), userInfo: nil, repeats: true)
                self.totalDistance = CLLocationDistance()
                self.previousCoordinate = locationManager.location?.coordinate
                locationManager.startUpdatingLocation()
                self.points = []
                self.mapView.showsUserLocation = true
                self.mapView.setUserTrackingMode(.follow, animated: true)
                startBtn.setImage(UIImage(named: "Stop"), for: .normal)
                self.runMode = .running
            } else {
                let alert = UIAlertController(title: "러닝 시작 실패", message: "위치 권한을 항상 허용해야 정확한 거리 측정이 가능합니다.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)
                let gosetting = UIAlertAction(title: "설정 변경", style: .default) { Action in
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
                
                alert.addAction(ok)
                alert.addAction(gosetting)
                
                present(alert, animated: true) {
                }
            }
        } else if runMode == .running {
            self.mapView.showsUserLocation = false
            self.mapView.setUserTrackingMode(.none, animated: true)
            startBtn.setImage(UIImage(named: "Save"), for: .normal)
            self.runMode = .finished
            let distanceFormatter = MKDistanceFormatter()
            distanceFormatter.units = .metric
            _ = distanceFormatter.string(fromDistance: totalDistance)
            //let stringDistance = distanceFormatter.string(fromDistance: totalDistance)

            generateMapImage()
            timer.invalidate()
            locationManager.stopUpdatingLocation()
            endTime = Date()
            self.resultTimeLabel.text = self.totalRunTime
            
        } else if runMode == .finished {
            timer.invalidate()
            (hours, minutes, seconds, fractions) = (0, 0, 0, 0)
            resetLabel()
            self.mapView.setUserTrackingMode(.follow, animated: true)
            locationManager.stopUpdatingLocation()
            let overlays = self.mapView.overlays
            self.mapView.removeOverlays(overlays)
            startBtn.setImage(UIImage(named: "Start"), for: .normal)
            self.runMode = .ready
            self.mapView.showsUserLocation = true
            
            showSaveAlert()
            
        }
    }
}



extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline
        else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = UIColor(named: "polyline_purple")
        renderer.lineWidth = 10.0
        renderer.alpha = 1.0
        
        return renderer
    }
}




    // MARK: - Delegate, DataSource


extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let latitude = location.coordinate.latitude
        let longtitude = location.coordinate.longitude
        
        let point1 = CLLocationCoordinate2DMake(self.previousCoordinate?.latitude ?? location.coordinate.latitude, self.previousCoordinate?.longitude ?? location.coordinate.longitude)
        let point2: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longtitude)

        self.points.append(point1)
        self.points.append(point2)
        
        let loc1 = CLLocation(latitude: self.previousCoordinate?.latitude ?? 0.0, longitude: self.previousCoordinate?.longitude ?? 0.0)
        let loc2 = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let distanceFormatter = MKDistanceFormatter()
        distanceFormatter.units = .metric
        let addedDistance = loc1.distance(from: loc2)
        let stringDistance = distanceFormatter.string(fromDistance: totalDistance)
        self.resultDistanceLabel.text = "\(stringDistance)"
        let lineDraw = MKPolyline(coordinates: points, count:points.count)
        self.mapView.addOverlay(lineDraw)
        self.totalDistance += addedDistance
        self.previousCoordinate = location.coordinate
    }
}

