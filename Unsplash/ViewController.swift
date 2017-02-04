//
//  ViewController.swift
//  Unsplash
//
//  Created by 范东 on 17/2/4.
//  Copyright © 2017年 范东. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD
import Alamofire
import MJExtension

let url = "https://api.unsplash.com/photos/?client_id=522f34661134a2300e6d94d344a7ab6424e028a51b31353363b7a8cce11d73b6&page="

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    lazy var dataArray:NSMutableArray = {
        let dataArray = NSMutableArray.init()
        return dataArray
    }()
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 100, height: 100)
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView;
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(self.collectionView)
        self.requestFirstPageData()
    }
    
    func requestFirstPageData() {
        let firstUrl = url + "1"
        Alamofire.request(firstUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (response) in
            switch response.result{
            case .success:
                if let result = response.result.value{
                    let array = result as! NSMutableArray
                    let model = UnsplashPictureModel.mj_objectArray(withKeyValuesArray: array) as [AnyObject]
                    print(model)
                    self.dataArray.addObjects(from: model)
                }
                self.collectionView.reloadData()
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

