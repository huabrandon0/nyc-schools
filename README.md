# NYC Schools Coding Challenge
## Introduction
This is a take home coding challenge for an iOS position.

### Requirements
The challenge is to create an iOS app that lists NYC schools and displays extra information about a school when selected. The specifications (shortened) are:
> 1. Display a list of NYC high schools.
> 2. Selecting a school should show additional information (at the least, include SAT scores).

Data is from NYC Open Data: [school directory](https://data.cityofnewyork.us/Education/DOE-High-School-Directory-2017/s3k6-pzi2), [SAT results](https://data.cityofnewyork.us/Education/SAT-Results/f9bf-2cp4).

### Screenshots
The app was tested on an iPhone X Simulator.
<div align="center">
  <img src="schools-list.png" height="400" />
  <img src="school-info.png" height="400" />
  <img src="demo.gif" height="400" />
</div>

## Implementation
Before downloading the CSV files, I filtered the data to remove extraneous columns with NYC Open Data's web tool. For the implementation, I used Swift + Storyboards (XCode 14.2). Relevant code are in 2 files ([SchoolsListViewController](/20230227-BH-NYCSchools/SchoolsListViewController.swift), [SchoolInformationViewController](/20230227-BH-NYCSchools/SchoolInformationViewController.swift)). Other files are boilerplate generated by XCode. The UI is set up through XCode's Storyboard editor window.
- [SchoolsListViewController](/20230227-BH-NYCSchools/SchoolsListViewController.swift): the entry point of the app, responsible for loading in CSV data and initializing/displaying the list of schools
  - CSV data is used to populate internal data structures--an array of school IDs, a dictionary mapping school IDs to school information
  - Upon transitioning to the detailed information view, it will send the selected school's data to SchoolInformationViewController
- [SchoolInformationViewController](/20230227-BH-NYCSchools/SchoolInformationViewController.swift): displays school information that it receives from SchoolsListViewController
  - Handles school name, address, website, overview, and SAT scores

### Dependencies
I used [SwiftCSV](https://swiftpackageindex.com/swiftcsv/SwiftCSV) to load/parse CSV files.

### Possible Improvements
Noting some possible follow-up tasks here:
- Make the school information view scrollable in case the "overview" section overflows
- Use null checks instead of force-unwrapping data from rows
- Remove hardcoded strings used for data column names
