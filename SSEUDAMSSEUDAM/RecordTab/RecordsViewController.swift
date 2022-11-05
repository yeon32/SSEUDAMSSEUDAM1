

import UIKit
import RealmSwift
import MapKit
import SnapKit

class RecordsViewController: UIViewController , UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    

    let localRealm = try! Realm()
    var task: Results<RecordObject>!
    var filteredTask: Results<RecordObject>! {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        task = localRealm.objects(RecordObject.self)
        filteredTask = localRealm.objects(RecordObject.self)
    
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    
    
    // MARK: - Function
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {

        filteredTask = searchText.isEmpty ? task : task.filter("memo CONTAINS[c] %@", searchText)
        self.tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchBar.searchBarStyle = .minimal
       
        
        filterContentForSearchText(searchText)
        print("this is searchText", searchText)
        self.tableView.reloadData()
    }
    
   
  
    
    
    
    
  
    func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 140
        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredTask.count
            
        }
    
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
            let taskToDelete = task[indexPath.row]
            if editingStyle == .delete {
                try! localRealm.write {
                    localRealm.delete(taskToDelete)
                }
                tableView.reloadData()
            }
        }
    
    
    
    // MARK: - Function (TableView)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Record", for: indexPath) as? RecordTableViewCell
    
    
            else { return UITableViewCell() }
            
            let image = UIImage(data: task[indexPath.row].image)
            let date = filteredTask[indexPath.row].date
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "YYYY년 MM월 dd일 HH:mm"
            let stringDate = dateformatter.string(from: date)
            let distanceformatter = MKDistanceFormatter()
            distanceformatter.units = .metric
            let stringDistance = distanceformatter.string(fromDistance: filteredTask[indexPath.row].distance)
            
            cell.mapImageView.image = image
            cell.dateLabel.text = stringDate
            cell.distanceLabel.text = stringDistance
            cell.timeLabel.text = filteredTask[indexPath.row].time
            
                
            
    
            return cell
        }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let rdv = self.storyboard?.instantiateViewController(withIdentifier: "RecordDetail") as! RecordDetailViewController
            rdv.recordData = self.filteredTask[indexPath.row]
    
            self.navigationController?.pushViewController(rdv, animated: true)
        }
    
}

