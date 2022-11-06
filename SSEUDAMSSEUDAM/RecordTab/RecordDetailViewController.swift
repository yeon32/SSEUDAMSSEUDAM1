

import UIKit
import MapKit
import NotificationBannerSwift
import RealmSwift

class RecordDetailViewController: UIViewController {
    
    var recordData: RecordObject!
    let localRealm = try! Realm()
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    
    
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let distanceformatter = MKDistanceFormatter()
        distanceformatter.units = .metric
        let stringDistance = distanceformatter.string(fromDistance: recordData.distance)
        

        memoTextView.text = recordData.memo
        mapImageView.image = UIImage(data: recordData.image)
        distanceLabel.text = String(Int(recordData.distance))
        timeLabel.text = recordData.time
      
        memoTextView.layer.cornerRadius = 5
        memoTextView.layer.borderWidth = 3
        memoTextView.layer.borderColor = UIColor(hue: 0.9972, saturation: 0, brightness: 1, alpha: 1.0).cgColor
        
        memoTextView.text = recordData.memo
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
    
    
    // MARK: - IBAction
    
    @IBAction func tapSaveBtn(_ sender: UIButton) {
        
        let taskToUpdate = recordData
        
        try! localRealm.write {
            taskToUpdate?.memo = memoTextView.text
        }
        
         let banner = NotificationBanner(title: "Well Saved!", subtitle: "Your memo is succesfully saved.", style: .success)
         banner.show()
    
    }
}

