

import UIKit
import SnapKit


class RecordTableViewCell: UITableViewCell {
    
    //UIColor(hue: 0.4861, saturation: 0.19, brightness: 0.85, alpha: 1.0).cgColor   //민트
    //UIColor(hue: 0.6667, saturation: 0.09, brightness: 0.24, alpha: 1.0).cgColor   //차콜
    //UIColor(hue: 0.0278, saturation: 0.75, brightness: 0.99, alpha: 1.0).cgColor   //오렌지
    //UIColor(hue: 0.5306, saturation: 0.03, brightness: 0.98, alpha: 1.0).cgColor   //연한민트
    
    
    
    
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 30
        self.layer.borderWidth = 4
        self.layer.backgroundColor = UIColor(hue: 0.4861, saturation: 0.19, brightness: 0.85, alpha: 1.0).cgColor 
        self.layer.borderColor = UIColor(hue: 0.9972, saturation: 0, brightness: 1, alpha: 1.0).cgColor
     
        
        
      
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
