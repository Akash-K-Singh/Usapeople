import UIKit
import Alamofire
import Foundation

struct PopulationDataResponse: Codable {
    let data: [PopulationData]
    let source: [Source]
}

struct PopulationData: Codable {
    let idNation: String
    let nation: String
    let idYear: Int
    let year: String
    let population: Int
    let slugNation: String
    
    enum CodingKeys: String, CodingKey {
        case idNation = "ID Nation"
        case nation = "Nation"
        case idYear = "ID Year"
        case year = "Year"
        case population = "Population"
        case slugNation = "Slug Nation"
    }
}

struct Source: Codable {
    let measures: [String]
    let annotations: Annotations
    let name: String
    let substitutions: [String]
}

struct Annotations: Codable {
    let sourceName: String
    let sourceDescription: String
    let datasetName: String
    let datasetLink: String
    let tableID: String
    let topic: String
    let subtopic: String
    
    enum CodingKeys: String, CodingKey {
        case sourceName = "source_name"
        case sourceDescription = "source_description"
        case datasetName = "dataset_name"
        case datasetLink = "dataset_link"
        case tableID = "table_id"
        case topic
        case subtopic
    }
}


class ViewController: UIViewController {
    
    var popultionArray : [PopulationData] = [];
    var years : [String] = [];
    
    @IBOutlet weak var yearTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearTable.dataSource = self
        yearTable.delegate = self
        fetchQuote();
    }

    let apiUrl = "https://datausa.io/api/data?drilldowns=Nation&measures=Population";
    
    func fetchQuote() {
        // Alamofire GET request
        AF.request(apiUrl).responseString { response in
            switch response.result {
            case .success(let jsonDataString):
                if let jsonData = jsonDataString.data(using: .utf8) {
                    do {
                        // Decode JSON data into a Swift object
                        let populationDataResponse = try JSONDecoder().decode(PopulationDataResponse.self, from: jsonData)
                        
                        self.popultionArray = populationDataResponse.data;
                        
                        // Print the population data
                        for data in populationDataResponse.data {
                            print("Year: \(data.year), Population: \(data.population)")
                        }
                        
                        self.years = self.popultionArray.map { $0.year }

                        // Printing the fetched years
                        print(self.years)
                        
                        DispatchQueue.main.async {
                            self.yearTable.reloadData()
                        }
                    
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return years.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = yearTable.dequeueReusableCell(withIdentifier: "yearcell", for: indexPath)
        cell.textLabel?.text = years[indexPath.row];
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Deselect the cell to remove the highlight
            tableView.deselectRow(at: indexPath, animated: true)
            
            // Get the selected item
            let selectedItem = popultionArray[indexPath.row]
            
            // Instantiate the destination view controller
            guard let destinationViewController = storyboard?.instantiateViewController(withIdentifier: "DestinationViewController") as? DestinationViewController else {
                return
            }
            
            // Pass the selected data to the destination view controller
            destinationViewController.selectedItem = selectedItem
            
            // Navigate to the destination view controller
            navigationController?.pushViewController(destinationViewController, animated: true)
        }
}




