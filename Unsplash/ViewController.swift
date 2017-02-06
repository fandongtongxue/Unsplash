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
let cellId = "UnsplashPictureCellID"
let statusBarHeight  : CGFloat = 20.0



class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    //懒加载
    lazy var dataArray:NSMutableArray = {
        let dataArray = NSMutableArray.init()
        return dataArray
    }()
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: UIScreen.main.bounds.size.width / 3, height: UIScreen.main.bounds.size.height / 3)
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: statusBarHeight, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - statusBarHeight), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UnsplashPictureCell.self, forCellWithReuseIdentifier:cellId)
        return collectionView;
    }()
    //生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.collectionView)
        self.requestFirstPageData()
    }
    //请求第一页数据
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UnsplashPictureCell
        let model = self.dataArray[indexPath.row] as! UnsplashPictureModel
        cell.setModel(model: model)
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

