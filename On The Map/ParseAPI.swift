//
//  ParseAPI.swift
//  On The Map
//
//  Created by Nikhil on 08/12/16.
//  Copyright © 2016 Nikhil. All rights reserved.
//

import Foundation
class StudentLocation {
    
    static let sharedInstance = StudentLocation()
   
    let REST_APIKey = Constants.Keys.REST_APIKey
    let Parse_ApplicationID = Constants.Keys.Parse_ApplicationID
   
    
    // GETing student locations
    func gettingStudentLocations(completionHandler: @escaping (_ sucess: Bool, _ errorString: String?)-> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue(self.Parse_ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(self.REST_APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { (data,response,error) in
            guard (error == nil) else {
                completionHandler(false, error!.localizedDescription)
                return
                }
            
            guard let data = data else {
                completionHandler(false, "No data was returned.")
                return
            }
            let parseResult = (try! JSONSerialization.jsonObject(with: data, options: .allowFragments)) as! NSDictionary
            if let results = parseResult["results"] as? [[String:AnyObject]] {
                for result in results {
                    StudentData.sharedInstance.mapPins.append(StudentInformation.init(data: result))
                }
                 completionHandler(true, nil)
             }
                else {
                    completionHandler(false, "Could not find key 'results' in \(parseResult)")
             }
        }
        task.resume()
    }
    
    //POSTing student location
    func postingStudentLocation(_ latitude: String, longitude: String, addressField: String, link: String, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue(Constants.Keys.Parse_ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.Keys.REST_APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(Login.sharedInstance.key)\", \"firstName\": \"\(Login.sharedInstance.firstName)\", \"lastName\": \"\(Login.sharedInstance.lastName)\",\"mapString\": \"\(addressField)\", \"mediaURL\": \"\(link)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            if error != nil {
                completionHandler(false, "Failed to submit data.")
             }
                else {
                    completionHandler(true, nil)
                 }
        })
        task.resume()
      }
}
