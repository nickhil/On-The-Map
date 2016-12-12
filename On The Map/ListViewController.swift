//
//  ListViewController.swift
//  On The Map
//
//  Created by Nikhil on 09/12/16.
//  Copyright © 2016 Nikhil. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UITableViewController{
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var studentTable: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
  
        override func viewDidLoad() {
            super.viewDidLoad()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    func refreshList(){
        self.setUIEnabled(false)
        BarButtons.sharedInstance.refresh{ (refresh, errorString) in
            if refresh {
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                    self.setUIEnabled(true)
                }
            }
            else {
                performUIUpdatesOnMain {
                    Error.sharedInstance.showError(controller: self, title: "Failed To Refresh", message: errorString!)
                    self.setUIEnabled(true)
                }
            }
        }
    }
    
    @IBAction func refreshButtonPressed(_ sender: AnyObject) {
        refreshList()
    }
    
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        self.setUIEnabled(false)
        BarButtons.sharedInstance.logout{ (logout, errorString) in
            if logout {
                performUIUpdatesOnMain {
                    self.setUIEnabled(true)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            else {
                performUIUpdatesOnMain {
                    Error.sharedInstance.showError(controller: self, title: "Logout Failed", message: errorString!)
                    self.setUIEnabled(true)
                }
            }
        }
    }

    @IBAction func pinButtonPressed(_ sender: AnyObject) {
        
        if userPinned {
            addMorePins(title: "Already Pinned", message: "Add one more location of the student on the map?", identifier: "List")
        }
            
        else {
            performUIUpdatesOnMain {
                self.performSegue(withIdentifier: "List", sender: self)
            }
        }
    }
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return StudentData.sharedInstance.mapPins.count
        }
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let studentInfo = StudentData.sharedInstance.mapPins[(indexPath as NSIndexPath).row]
            if studentInfo.name == Login.sharedInstance.name {
                userPinned = true
            }
            
            let cell = UITableViewCell(style: UITableViewCellStyle.subtitle , reuseIdentifier: "studentCell")
            cell.imageView?.image = UIImage(named: "Pin")
            cell.textLabel?.text = studentInfo.name
            cell.detailTextLabel?.text = studentInfo.mediaURL
            return cell
        }
    
            override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            var arrayOfUrl: [String] = []
            for result in StudentData.sharedInstance.mapPins {
                arrayOfUrl.append(result.mediaURL)
            }
                let URL = arrayOfUrl[indexPath.row]
            OpenURL.sharedInstance.openBrowser(Link: URL)
        }
    
        func setUIEnabled(_ enabled: Bool) {
            if enabled {
                performUIUpdatesOnMain {
                    self.studentTable.alpha = 1.0
                    self.logoutButton.isEnabled = true
                    self.pinButton.isEnabled = true
                    self.refreshButton.isEnabled = true
                    self.activityIndicator.startAnimating()
                }
            }
                
            else {
                performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    self.studentTable.alpha = 0.5
                    self.logoutButton.isEnabled = false
                    self.pinButton.isEnabled = false
                    self.refreshButton.isEnabled = false
                }
            }
        }
    }
