//
//  TableViewController.swift
//  JZ-EDirectory
//
//  Created by Jingzhi Zhang on 10/3/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//
/*  
    Purpose:To use GCD to fetch json formatted data from provided link on a separate background thread/queue and update the UI with parsed JSON data in the main thread/queue..
            To search and Display employees' information and view the progress of it.
*/


import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {
    //Markup: variable for class client
    var employee = [Employee]()
    
    // Markup: outlets
    @IBOutlet weak var topSearBar: UISearchBar!
    
    // Markup: variables
    var progressView: UIProgressView?
    var timer: Timer?
    var progressValue:Float = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchJsonData()
        setUpSearchBar()
        
        //dismiss the keyboard
        self.hideKeyboardWhenTappedAround()
        
        // Create the info button
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(buttonTapped(_sender:)), for: .touchUpInside)
        
        // Creates a bar button item using the info button as its custom view
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        
        self.navigationItem.rightBarButtonItem = infoBarButtonItem
        
        // Create Progress View Control
        
        progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
        progressView?.center = self.view.center
        
        
        
        view.addSubview(progressView!)

        
    }
    
    
    //set up search  bar
    fileprivate func setUpSearchBar() {
        //self.topSearBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 65))
        self.topSearBar.showsScopeBar = true
        self.topSearBar.placeholder =  "Please input employee name"
        
        //self.topSearBar.selectedScopeButtonIndex = 0
        self.topSearBar.scopeButtonTitles = ["First","Last"]
        
        self.topSearBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            fetchJsonData()
        }
        else {
            if topSearBar.selectedScopeButtonIndex == 0 {
                employee = employee.filter({(employee) -> Bool in
                return employee.first.lowercased().contains(searchText.lowercased())
                })
            }
            else {
                employee = employee.filter({(employee) -> Bool in
                    return employee.last.lowercased().contains(searchText.lowercased())
                })
            }
        }
        //refresh the main table view
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }


    }
    
    /*
     This function presents a view controller when button is pressed
     */
    func buttonTapped(_sender: UIButton) {
        
        //Present About view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AboutAppNavigationController") as! UINavigationController
        self.present(controller, animated: true, completion: nil)
    }

    func fetchJsonData() {
        // Fetching client list.
        let api_json_url = URL(string:"http://faculty.cs.niu.edu/~krush/ios/edirectory_json")
        
        // Create a URL request with the API address
        let urlRequest = URLRequest(url: api_json_url!)
        // Submit a request to get the JSON data
        
        //let task = URLSession.shared.dataTask(with: urlRequest) {(data,response,error) in
        let task = URLSession.shared.dataTask(with: urlRequest) {data,response,error in
            
            
            // if there is an error, print the error and do not continue
            if error != nil {
                print("Failed to parse")
                return
            }
            
            // if there is no error, fetch the json formatted content
            if let content = data {
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    
                    
                    if let employeesJson = jsonObject["results"] as? [[String:AnyObject]]{
                        
                        for item in employeesJson{
                            
                            if
                                let name = item["name"] as? [String:AnyObject],
                                let gender = item["gender"] as? String,
                                let location = item["location"] as? [String:AnyObject],
                                let email = item["email"] as? String,
                                let registered = item["registered"] as? String,
                                let phone = item["phone"] as? String,
                                let cell = item["cell"] as? String,
                                let id = item["id"] as? [String:AnyObject],
                                let picture = item["picture"] as? [String:AnyObject],
                                let dob = item["dob"] as? String{

                                // make sure it is string so there would not be any converting issue
                                let ePostcode = ("\(location["postcode"]!)")
                                let eName = ("\(id["name"]!)")
                                let eValue = ("\(id["value"]!)")
                                
                                self.employee.append(Employee(title:name["title"] as! String, first:name["first"] as! String, last:name["last"] as! String, gender:gender, street: location["street"] as! String, city:location["city"] as! String, state:location["state"] as! String, postcode:ePostcode, email:email, dob: dob, registered:registered, phone: phone, cell:cell, name:eName, value:eValue, large:picture["large"] as! String, medium:picture["medium"] as! String, thumbnail:picture["thumbnail"] as! String))
                                
                                //self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TableViewController.updateProgress), userInfo: nil, repeats: true)
                                
                                //increment in the process view
                                DispatchQueue.main.async {
                                    let percentProgress = Float(Float(self.employee.count)*100.0/1000.0)
                                    self.progressView?.setProgress(percentProgress, animated: true)
                                    //dismiss the progress view
                                    if self.employee.count == 1000 {
                                        sleep(1)
                                        self.progressView?.isHidden = true}
                                    
                                }
                                
                            }//end if
                            
                        }//end for
                    }
                    //refresh the main table view
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } // end do
                    
                catch {//If an error occurs, display a “Failed to parse!” message.
                    print("Failed to parse!")
                } // end catch
                
            } // end if
        } // end getDataSession
        
        task.resume()
    } // end readJsonData function
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.employee.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath) as! TableViewCell

        // Configure the cell...
        let employeeRow:Employee = self.employee[indexPath.row]
    
        let PictureURL = URL(string: employeeRow.medium)!
        let pictureData = NSData(contentsOf: PictureURL as URL)
        let ePicture = UIImage(data:pictureData! as Data)
        cell.cellImageView.image = ePicture
        
        cell.employeeIDname.text = employeeRow.name
        cell.employeeIDvalue.text = employeeRow.value
        cell.employeeTitle.text = employeeRow.title
        cell.employeeFirst.text = employeeRow.first
        cell.employeeLast.text = employeeRow.last

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "detailView"){
            
            //create a variable to act as the viewcontroller itself
            let detailView = segue.destination as! DetailView
            
            if let indexPath = self.tableView.indexPathForSelectedRow{
                
                let row:Employee = self.employee[indexPath.row]
                
                //Set all the necessary properities that need to go in the DetailviewController
                //obtain them from the object created to obtain the venues values
                //detailView.navigationItem.title = row.name + " " + row.value
                detailView.firstString = row.first
                detailView.lastString = row.last
                detailView.streetString = row.street
                detailView.cityString = row.city
                detailView.stateString = row.state
                detailView.postcodeString = row.postcode
                detailView.emailString = row.email
                detailView.dobString = row.dob
                detailView.registeredString = row.registered
                detailView.phoneString = row.phone
                detailView.cellString = row.cell
                detailView.largeString = row.large
                detailView.mediumString = row.medium
                detailView.thumbnailString = row.thumbnail
                detailView.genderString = row.gender
                
            }
        }
        
        
    }
    

}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

