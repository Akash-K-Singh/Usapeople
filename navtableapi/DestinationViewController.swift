import UIKit

class DestinationViewController: UIViewController {
    // Property to hold the data
    var selectedItem: PopulationData?
    
    @IBOutlet weak var lblPopulation: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedItem = selectedItem {
            lblPopulation.text = "Population of \(selectedItem.nation) in \(selectedItem.idYear) was \(selectedItem.population)";
        } else {
            print("selectedItem is nil")
        }
    }
}
