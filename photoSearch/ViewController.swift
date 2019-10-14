//
//  ViewController.swift
//  photoSearch
//
//  Created by Мария on 10.10.2019.
//  Copyright © 2019 Мария. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var ImageView: UIImageView!

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.becomeFirstResponder()
        ImageView.layer.masksToBounds = true
        //searchImage(text: "zebra")
    }

    func convert(farm: Int, server: String, photoId: String, secret: String) -> URL? {
        let url = URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_c.jpg")!
        return url
    }

    func showError(_ text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func searchImage(text: String) {
        //
        let base = "https://www.flickr.com/services/rest/?method=flickr.photos.search"
        let key = "&api_key=565bec242644bb4ee0bdc51fbde270f4"
        let format = "&format=json&nojsoncallback=1"
        
        let formattedText = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        
        let textToSearch = "&text=\(formattedText)"
        let sort = "&sort=relevance"

        let searchUrl = base + key + format + textToSearch + sort
        let url = URL(string: searchUrl)!
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let jsonData = data else{
                self.showError("not enough data")
                return
            }
            guard let jsonAny = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
                self.showError("error: no json")
                return
            }
            print(jsonAny)
            guard let json = jsonAny as? [String: Any] else {
                return
            }
            guard let photos = json["photos"] as? [String: Any] else {
                return
            }
            guard let photosArray = photos["photo"] as? [Any] else {
                return
            }
            guard photosArray.count > 0 else {
                self.showError("No photod found")
                return
            }
            guard let firstPhoto = photosArray[0] as? [String: Any] else {
                return
            }
            let farm = firstPhoto["farm"] as! Int
            let photoId = firstPhoto["id"] as! String
            let secret = firstPhoto["secret"] as! String
            let server = firstPhoto["server"] as! String
            
            let pictureUrl = self.convert(farm: farm, server: server, photoId: photoId, secret: secret)!
            
            URLSession.shared.dataTask(with: pictureUrl, completionHandler: { (data, _, _) in
                DispatchQueue.main.async {
                    self.ImageView.image = UIImage(data: data!)
                }
            }).resume()
        }.resume()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchImage(text: textField.text!)
        return true
    }
}

