//
//  DetailView.swift
//  JZ-EDirectory
//
//  Created by Jingzhi Zhang on 10/3/17.
//  Copyright © 2017 NIU CS Department. All rights reserved.
//  Purpose: To show the selected employee's detailed information and enable the manager to contact him or her.

import UIKit
import MessageUI

class DetailView: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    // Markup: Outlets
    @IBOutlet weak var employeeFirst: UILabel!
    @IBOutlet weak var employeeLast: UILabel!
    @IBOutlet weak var employeeStreet: UILabel!
    @IBOutlet weak var employeeGender: UILabel!
    @IBOutlet weak var employeeCity: UILabel!
    @IBOutlet weak var employeeState: UILabel!
    @IBOutlet weak var employeePostcode: UILabel!
    @IBOutlet weak var employeeEmail: UIButton!
    @IBOutlet weak var employeeDob: UILabel!
    @IBOutlet weak var employeeRegistered: UILabel!
    @IBOutlet weak var employeePhone: UIButton!
    @IBOutlet weak var employeeCell: UIButton!
    @IBOutlet weak var employeePicture: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!

    
    // Markup: Variables
    var firstString: String!
    var lastString: String!
    var dobString: String!
    var streetString: String!
    var cityString:String!
    var stateString:String!
    var postcodeString:String!
    var emailString:String!
    var registeredString:String!
    var phoneString:String!
    var cellString:String!
    var genderString:String!
    var largeString:String!
    var mediumString:String!
    var thumbnailString:String!
    
    //set a timer to display Image View for the employee's profile picture
    var timer: Timer!
    var updateCounter:Int!

    //make a phone call on device
    @IBAction func callBtnClicked(_ sender: UIButton) {
        //remove the space in the phone number string to avoid unwrapped optionals
        let phonenumber = phoneString.replacingOccurrences(of: " ", with: "")
        let myURL:NSURL = (URL(string: "tel://\(phonenumber)") as NSURL?)!
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(myURL as URL)) {
             UIApplication.shared.open(myURL as URL, options: [:], completionHandler: nil)
            }
        }
/*
        // Display the simple alert since we cannot test the above
        // code on the simulator
        let alertController = UIAlertController(title: "Calling..", message: phoneString, preferredStyle: .alert)
        
        let dismissButton = UIAlertAction(title: "Dismiss", style: .cancel, handler: {
            
            (alert: UIAlertAction!) -> Void in
        })
        alertController.addAction(dismissButton)
        self.present(alertController, animated: true, completion: nil)
 */
    
    
    
    // send an e-mail
    @IBAction func emailBtnClicked(_ sender: UIButton) {
        // Create a mail composer using the MFMailComposeViewController class
        // and assign it as a delegate
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        let toRecipents = [emailString]
        let emailTitle = "JZ-EDirectory"
        let messageBody = "Hello, \(firstString!) \(lastString!), this email is from the JZ-EDirection App by Jingzhi Zhang, Z1806811. How do you like it?"
            
            mailComposeVC.setToRecipients(toRecipents as? [String])
            mailComposeVC.setSubject(emailTitle)
            mailComposeVC.setMessageBody(messageBody, isHTML: false)
        
        
        // If MFMailComposer can send mail, then present the populated
        // mail composer view controller.
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeVC, animated: true, completion: nil)
        }
        else {
            print("Cannot send an email!")
        }
    
    }
    
    // This is the MFMailComposerViewController delegate method.
    // When it finishes sending mail, dismiss the view controller.
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    //set up a text message controller
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //send a message
    @IBAction func txtBtnClicked(_ sender: AnyObject) {
        if MFMessageComposeViewController.canSendText(){
            
            let controller = MFMessageComposeViewController()
            controller.body = "Hello, \(firstString!) \(lastString!), this message is from the JZ-EDirection App by Jingzhi Zhang, Z1806811. How do you like it?"
            //controller.recipients = [self.employeeCell.title]
            //controller.recipients = [self.employeeCell.title]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        else {print("Couldn't send an message!")}
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //show the employee's detailed information
        employeeFirst.text = firstString
        employeeLast.text = lastString
        employeeGender.text = genderString
        employeeState.text = stateString
        employeeStreet.text = streetString
        employeeCity.text = cityString
        employeePostcode.text = postcodeString
        employeeEmail.setTitle(emailString, for: .normal)
        employeeDob.text = dobString
        employeeRegistered.text = registeredString
        employeePhone.setTitle(phoneString, for: .normal)
        employeeCell.setTitle(cellString, for: .normal)
        
        let PictureURL = URL(string: largeString)!
        let pictureData = NSData(contentsOf: PictureURL as URL)
        let ePicture = UIImage(data:pictureData! as Data)
        employeePicture.image = ePicture

        /*display images based on the timer*/
        updateCounter = 0;
        timer = Timer.scheduledTimer(timeInterval: 2.5, target:self, selector:#selector(DetailView.updateTimer), userInfo:nil, repeats:true)

        // Do any additional setup after loading the view.
    }

    
    //show different images
    internal func updateTimer()
    {
        updateCounter = (updateCounter+1)%3
        pageControl.currentPage = updateCounter
        switch (updateCounter){
        case 0: pickImage(imageString: largeString)
        case 1: pickImage(imageString: mediumString)
        case 2: pickImage(imageString: thumbnailString)
        default: break }
    }
    
    func pickImage(imageString: String) {
        let PictureURL = URL(string: imageString)!
        let pictureData = NSData(contentsOf: PictureURL as URL)
        let ePicture = UIImage(data:pictureData! as Data)
        employeePicture.image = ePicture
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
