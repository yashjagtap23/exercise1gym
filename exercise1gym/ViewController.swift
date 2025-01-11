//
//  ViewController.swift
//  exercise1gym
//
//  Created by Yash Jagtap on 12/31/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var useremail: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username.text = "Hello, Yash!"
        useremail.text = "yash05jagtap@gmail.com"
        imageView.image = UIImage(named: "example")
        
        imageView.layer.masksToBounds = true
        
        imageView.layer.borderWidth = 3.5
        imageView.layer.borderColor = UIColor.white.cgColor
        
        fetchRandomUser()
        adjustImageSize()
        
        
    }
    
    func adjustImageSize() {
        let deviceWidth = UIScreen.main.bounds.width
        
        if deviceWidth < 400 {
            imageWidth.constant = 120
            imageHeight.constant = 120
            imageView.layer.cornerRadius = imageHeight.constant / 2
            
        } else {
            imageWidth.constant = 140
            imageHeight.constant = 140
            imageView.layer.cornerRadius = imageHeight.constant / 2
        }
    }
    
    func fetchRandomUser() {
        let url = URL(string: "https://randomuser.me/api/")!
        
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching user data: \(error)")
                return
            }
            
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
        task.resume()
    }
    
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
        task.resume()
    }
    
    
    
    
}

