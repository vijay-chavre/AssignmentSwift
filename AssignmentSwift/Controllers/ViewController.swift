//
//  ViewController.swift
//  AssignmentSwift
//
//  Created by Vijay Chavre on 04/01/18.
//  Copyright © 2018 Vijay Chavre. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    let cellID = "cellIdentifire"
    @IBOutlet weak var userCollectionView: UICollectionView!
    var usersArray = [User]()
    
    init() {
        super.init(nibName: "PersonView", bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userCollectionView.register(UINib(nibName: "UserCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellID)
        self.userCollectionView.backgroundColor = UIColor.clear
        DispatchQueue.global(qos: .default).async {
            self.getJsonFromUrl()
        }
    }
    
}

//MARK: - Method To get data from remote server
extension ViewController {
    func getJsonFromUrl(){
        let url = NSURL(string: "http://betaci.abcoeur.com/search.json.php")
        let request = URLRequest(url: url! as URL)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                
                if let users = jsonObj!.value(forKey: "search_result") as? NSArray {
                    for user in users {
                        if let userDict = user as? NSDictionary {
                            if let userName = userDict.value(forKey: "in_pseudo"), let photoUrl = userDict.value(forKey: "photo_url"), let tagLine = userDict.value(forKey: "bottomLine"), let age = userDict.value(forKey: "in_age") {
                                
                                let user = User(userName: userName as! String, photoUrl: photoUrl as! String, tagLine: tagLine as! String, age: Int((age as! NSString).intValue))
                                self.usersArray.append(user)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.userCollectionView.reloadData()
                }
            }
            
            }.resume()
    }
}

 //MARK: - CollectionView datasource and delegate methods
extension ViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.usersArray.count > 0) {
            return self.usersArray.count;
        }
        return 0;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UserCellCollectionViewCell
        if (self.usersArray.count > 0) {
            cell.setupView(user: self.usersArray[indexPath.row])
        }

        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:(self.userCollectionView.frame.width - 60)/2, height: 200)
    }
}

