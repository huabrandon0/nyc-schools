//
//  ViewController.swift
//  20230227-BH-NYCSchools
//
//  Created by Brandon Hua on 2/27/23.
//

import UIKit
import SwiftCSV

class SchoolsListViewController: UIViewController {
    
    var schoolDBNs : [String] = []
    var schoolDBNToData : [String: SchoolData] = [:]
    
    enum Filename: String {
        case HighSchoolDirectory = "2017_DOE_High_School_Directory"
        case SATResults = "2012_SAT_Results"
    }
    
    enum ReuseIdentifier: String {
        case SchoolCell = "SchoolCell"
    }
    
    enum Segue: String {
        case ToInformation = "ToInformation"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load school directory + SAT results data
        loadDirectoryCSV(from: Filename.HighSchoolDirectory.rawValue)
        loadSATResultsCSV(from: Filename.SATResults.rawValue)
        
        // Remove schools without SAT results
        schoolDBNs.removeAll(where: {
            guard let sdata = schoolDBNToData[$0] else {
                return true
            }
            return sdata.sat == nil
        })
        
        // Sort schools alphabetically
        schoolDBNs.sort(by: {
            guard let data0 = schoolDBNToData[$0] else {
                return false
            }
            guard let data1 = schoolDBNToData[$1] else {
                return true
            }
            return data0.name < data1.name
        })
    }

    func loadDirectoryCSV(from fileName: String) {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "csv") else {
            return
        }
        
        do {
            let csv: CSV = try CSV<Named>(url: URL(fileURLWithPath: filePath))
            for row in csv.rows {
                if let dbn = row["dbn"] {
                    schoolDBNs.append(dbn)
                    schoolDBNToData[dbn] = SchoolData(dbn: dbn, name: row["school_name"]!, location: row["location"]!, link: row["website"]!, overview: row["overview_paragraph"]!)
                }
            }
        } catch {
            print("Error loading in CSV")
        }
    }
    
    func loadSATResultsCSV(from fileName: String) {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "csv") else {
            return
        }
        
        do {
            let csv: CSV = try CSV<Named>(url: URL(fileURLWithPath: filePath))
            for row in csv.rows {
                guard let dbn = row["DBN"] else {
                    continue
                }
                guard let schoolData = schoolDBNToData[dbn] else {
                    continue
                }
                guard let mathScore = Int(row["SAT Math Avg. Score"]!) else {
                    continue
                }
                guard let readingScore = Int(row["SAT Critical Reading Avg. Score"]!) else {
                    continue
                }
                guard let writingScore = Int(row["SAT Writing Avg. Score"]!) else {
                    continue
                }
                schoolData.sat = SATScores(math: mathScore, reading: readingScore, writing: writingScore)
            }
        } catch {
            print("Error loading in CSV")
        }
    }
    
    // Load data into information view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! SchoolInformationViewController
        destinationViewController.schoolData = sender as? SchoolData
    }
}

// Set up table with school data
extension SchoolsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolDBNs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.SchoolCell.rawValue) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = schoolDBNToData[schoolDBNs[indexPath.row]]?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segue.ToInformation.rawValue, sender: schoolDBNToData[schoolDBNs[indexPath.row]])
    }
}

struct SATScores {
    var math: Int
    var reading: Int
    var writing: Int
}

class SchoolData {
    var dbn: String = ""
    var name: String = ""
    var location: String = ""
    var link: String = ""
    var overview: String = ""
    var sat: SATScores? = nil
    
    init(dbn: String, name: String, location: String, link: String, overview: String, sat: SATScores? = nil) {
        self.dbn = dbn
        self.name = name
        self.location = location
        self.link = link
        self.overview = overview
        self.sat = sat
    }
}
