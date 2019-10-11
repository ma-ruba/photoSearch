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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchImage(text: "")
    }
    func searchImage(text: String) {
        //
        let base = "https://www.flickr.com/services/rest/?method=flickr.photos.search"
        let key = "&api_key=70639f7cb838e7b4504070e56edc8bdf"
        let format = "&format=json&nojsoncallback=1"
        let textToSearch = "&text=zebra"
        let sort = "&sort=relevance"
        
        let searchUrl = base + key + format + textToSearch + sort
        let url = URL(string: searchUrl)!
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let jsonData = data {
                let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                print(json)
            } else {
                print("error: not enough data")
            }
        }.resume()
    }
}

