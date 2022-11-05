

import UIKit
import SnapKit


class RecordTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
