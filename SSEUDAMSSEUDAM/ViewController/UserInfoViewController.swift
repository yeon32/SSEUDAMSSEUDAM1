

import UIKit

class UserInfoViewController: UIViewController {

    // MARK: - Properties
    var nameLabel : String?
    let userType = ["초보", "중수", "고수"]
    let picker = UIImagePickerController()
    
    
    @IBOutlet weak var addImageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addImageBtn: UIButton!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTypeTextField: UITextField!
    @IBOutlet weak var completeBtn: UIButton!
    
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameLabel.text = nameLabel! + String("님")
        
        setImageText()
        
        // userType Select Picker
        createPickerView()
        dismissPickerView()
        
        // textFieldStyle
        textFieldStyle()
        
      
    }

    
    // MARK: - Function
    
    // UIImagePicker
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    // imageText
    func setImageText() {
        if profileImageView.image != nil {
            addImageLabel.isHidden = true
        }
        else {
            addImageLabel.isHidden = false
        }
    }
    
    // TextField Style
    func textFieldStyle() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: userTypeTextField.frame.height - 1, width: userTypeTextField.frame.width, height: 1.0)
        bottomLine.backgroundColor = #colorLiteral(red: 0.8437076211, green: 0.8836424351, blue: 0.9301472306, alpha: 1)
        userTypeTextField.borderStyle = UITextField.BorderStyle.none
        userTypeTextField.layer.addSublayer(bottomLine)
        userTypeTextField.tintColor = .clear
    }
    
    
    @IBAction func didTapImageBtn(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) {
            (action) in self.openLibrary()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func didTapCompleteBtn(_ sender: Any) {
        guard let dvc = storyboard?.instantiateViewController(identifier: "TabBarController") as? TabBarController else {return}
       
        self.navigationController?.pushViewController(dvc, animated: true)
        
    }

}




// MARK: - UIPicker Delegate, DataSource
extension UserInfoViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userTypeTextField.text = userType[row]
        userMainData.shared.userType = userTypeTextField.text
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        userTypeTextField.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        userTypeTextField.inputAccessoryView = toolBar
    }
    @objc func action() {
        userTypeTextField.resignFirstResponder()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            profileImageView.image = image
            print(info)
            userMainData.shared.profileImage = profileImageView.image
            addImageLabel.isHidden = true
            
        }
        dismiss(animated: true, completion: nil)
    }
}

