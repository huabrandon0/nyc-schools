//
//  SchoolInformationViewController.swift
//  20230227-BH-NYCSchools
//
//  Created by Brandon Hua on 2/27/23.
//

import UIKit

class SchoolInformationViewController: UIViewController {

    var schoolData : SchoolData? = nil
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var link: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var mathScore: UILabel!
    @IBOutlet weak var readingScore: UILabel!
    @IBOutlet weak var writingScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let schoolData = self.schoolData else {
            return
        }
        
        self.title = schoolData.name
        name.text = schoolData.name
        link.text = schoolData.link
        address.text = schoolData.location
        overview.text = schoolData.overview
        
        guard let satScores = schoolData.sat else {
            return
        }
        
        mathScore.text = "Math: " + String(satScores.math)
        readingScore.text = "Reading: " + String(satScores.reading)
        writingScore.text = "Writing: " + String(satScores.writing)
    }
}
