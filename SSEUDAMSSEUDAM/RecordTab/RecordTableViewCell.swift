

import UIKit
import SnapKit


class RecordTableViewCell: UITableViewCell {
    
    //UIColor(hue: 0.4056, saturation: 0.8, brightness: 0.77, alpha: 1.0).cgColor  //그린
    //UIColor(hue: 0.6667, saturation: 0.09, brightness: 0.24, alpha: 1.0).cgColor   //차콜
    //UIColor(hue: 0.9972, saturation: 0, brightness: 1, alpha: 1.0)   //화이트
    
    
    
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 30
        self.layer.borderWidth = 4
        self.layer.backgroundColor = UIColor(hue: 0.4056, saturation: 0.8, brightness: 0.77, alpha: 1.0).cgColor
        self.layer.borderColor = UIColor(hue: 0.9972, saturation: 0, brightness: 1, alpha: 1.0).cgColor
     
        //self.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
      
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
