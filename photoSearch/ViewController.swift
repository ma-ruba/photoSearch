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
        searchImage(text: "zebra")
    }

    func convert(farm: Int, server: String, photoId: String, secret: String) -> URL? {
        let url = URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_c.jpg")!
        print(url)
        return url
    }

    func searchImage(text: String) {
        //
        let base = "https://www.flickr.com/services/rest/?method=flickr.photos.search"
        let key = "&api_key=565bec242644bb4ee0bdc51fbde270f4"
        let format = "&format=json&nojsoncallback=1"
        let textToSearch = "&text=\(text)"
        let sort = "&sort=relevance"

        let searchUrl = base + key + format + textToSearch + sort
        let url = URL(string: searchUrl)!
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let jsonData = data else{
                print("error: not enough data")
                return
            }
            guard let jsonAny = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
                print("error: no json")
                return
            }
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
                print("No photod found")
                return
            }
            guard let firstPhoto = photosArray[0] as? [String: Any] else {
                return
            }
            let farm = firstPhoto["farm"] as! Int
            let photoId = firstPhoto["id"] as! String
            let secret = firstPhoto["secret"] as! String
            let server = firstPhoto["server"] as! String
            self.convert(farm: farm, server: server, photoId: photoId, secret: secret)
        }.resume()
    }
}

