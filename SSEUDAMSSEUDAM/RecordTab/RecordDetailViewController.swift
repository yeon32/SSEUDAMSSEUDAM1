

import UIKit
import MapKit
import NotificationBannerSwift
import RealmSwift

class RecordDetailViewController: UIViewController {
    
    
    // MARK: - Properties
    let picker = UIImagePickerController()
    
    var recordData: RecordObject!
    let localRealm = try! Realm()
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var ploggingImageView: UIImageView!
    
    
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let distanceformatter = MKDistanceFormatter()
        distanceformatter.units = .metric
        let stringDistance = distanceformatter.string(fromDistance: recordData.distance)
        

        memoTextView.text = recordData.memo
        mapImageView.image = UIImage(data: recordData.image)
        //distanceLabel.text = String(Double(recordData.distance))+String("km")
        distanceLabel.text = "\(stringDistance)"
        timeLabel.text = recordData.time
      
        memoTextView.layer.cornerRadius = 5
        memoTextView.layer.borderWidth = 3
        memoTextView.layer.borderColor = UIColor(hue: 0.9972, saturation: 0, brightness: 1, alpha: 1.0).cgColor
    
        
        picker.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
    func openLibrary(){
      picker.sourceType = .photoLibrary
      present(picker, animated: false, completion: nil)
    }

    
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
            
        }
        else
        {
            print("Camera not available")
            
        }
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
    
    
    @IBAction func tapCamerBtn(_ sender: Any) {
        
        let alert =  UIAlertController(title: "플로깅 사진을 저장해봐요", message: "", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) {
            (action) in self.openLibrary()
        }
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
        self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)

        }
    
    }

extension RecordDetailViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage
        {
            ploggingImageView.image = image
            print(info)
            userMainData.shared.ploggingImage = ploggingImageView.image
            
        }
        dismiss(animated: true, completion: nil)
      
    }

//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
    
}


