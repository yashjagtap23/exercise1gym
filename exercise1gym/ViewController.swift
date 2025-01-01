//
//  ViewController.swift
//  exercise1gym
//
//  Created by Yash Jagtap on 12/31/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var useremail: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        username.text = "Hello, Yash!"
        useremail.text = "yash05jagtap@gmail.com"
        imageView.image = UIImage(named: "example")
        //imageWidth.constant = 50
        
        // Makes the image a circle
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.height / 2
        
        // Makes the white border around the image
        imageView.layer.borderWidth = 3.5
        imageView.layer.borderColor = UIColor.white.cgColor
        
        fetchRandomUser()
    }
    
    // Fetches random user data from the API
        func fetchRandomUser() {
            let url = URL(string: "https://randomuser.me/api/")!
            
            // Create ession task to fetch data
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching user data: \(error)")
                    return
                }
                
                // Parse the data
                guard let data = data else { return }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let results = json["results"] as? [[String: Any]],
                       let user = results.first {
                        
                        // Extract user details
                        let name = user["name"] as? [String: String]
                        let firstName = name?["first"] ?? "Unknown"
                        let lastName = name?["last"] ?? "User"
                        let email = user["email"] as? String ?? "No email"
                        let picture = user["picture"] as? [String: String]
                        let imageUrl = picture?["medium"] ?? ""
                        
                        // Update the UI on the main thread
                        DispatchQueue.main.async {
                            self.username.text = "\(firstName) \(lastName)"
                            self.useremail.text = email
                            self.loadImage(from: imageUrl)
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
            
            // Start the task
            task.resume()
        }
        
        // Loads an image from a URL and sets it to the image view
        func loadImage(from urlString: String) {
            guard let url = URL(string: urlString) else { return }
            
            // Create a URL session task to fetch the image
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
            
            // Start the task
            task.resume()
        }
    
    


}

