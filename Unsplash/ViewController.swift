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
import MJRefresh

let url = "https://api.unsplash.com/photos/?client_id=522f34661134a2300e6d94d344a7ab6424e028a51b31353363b7a8cce11d73b6&per_page=30&page="
let cellId = "UnsplashPictureCellID"
let statusBarHeight  : CGFloat = 20
let screenWidth : CGFloat = UIScreen.main.bounds.size.width
let screenHeight : CGFloat = UIScreen.main.bounds.size.height

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var page : NSInteger = 1
    
    var refreshControl : UIRefreshControl!
    
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
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: statusBarHeight, width: screenWidth, height: screenHeight - statusBarHeight), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UnsplashPictureCell.self, forCellWithReuseIdentifier:cellId)
        return collectionView;
    }()
    
    //生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(self.collectionView)
        self.initRefresh()
        self.requestFirstPageData(isNeedHUD: true)
    }
    
    func initRefresh()  {
        let refreshControl = UIRefreshControl.init()
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(requestFirstPageData(isNeedHUD:)), for: UIControlEvents.valueChanged)
        self.collectionView.addSubview(refreshControl)
        self.refreshControl = refreshControl
        self.collectionView.alwaysBounceVertical = true
    }
    
    //请求第一页数据
    func requestFirstPageData(isNeedHUD : Bool) {
        if isNeedHUD {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        page = 1
        let firstUrl = url + String.init(format: "%d", page)
        Alamofire.request(firstUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (response) in
            switch response.result{
            case .success:
                self.dataArray.removeAllObjects()
                if let result = response.result.value{
                    let array = result as! NSMutableArray
                    let model = UnsplashPictureModel.mj_objectArray(withKeyValuesArray: array) as [AnyObject]
                    self.dataArray.addObjects(from: model)
                    self.collectionView.reloadData()
                    self.refreshControl.endRefreshing()
                    //第一页加载成功创建Footer
                    let footer = MJRefreshAutoNormalFooter.init {
                        self.page += 1
                        self.requestMorePageData(page: self.page)
                    }
                    footer?.stateLabel.textColor = UIColor.white
                    self.collectionView.mj_footer = footer
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            case.failure(let error):
                self.refreshControl.endRefreshing()
                log.error(error)
                MBProgressHUD.hide(for: self.view, animated: true)
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = MBProgressHUDMode.text
                hud.label.text = String.init(format: "%@", error as CVarArg)
                hud.label.numberOfLines = 0;
                hud.hide(animated: true, afterDelay: 2)
            }
        }
    }
    func requestMorePageData(page:NSInteger) {
        let firstUrl = url + String.init(format: "%d", page)
        Alamofire.request(firstUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(queue: DispatchQueue.main, options: .mutableContainers) { (response) in
            switch response.result{
            case .success:
                if let result = response.result.value{
                    let array = result as! NSMutableArray
                    let model = UnsplashPictureModel.mj_objectArray(withKeyValuesArray: array) as [AnyObject]
                    self.dataArray.addObjects(from: model)
                }
                self.collectionView.reloadData()
                self.collectionView.mj_footer.endRefreshing()
            case.failure(let error):
                print(error)
                self.collectionView.mj_footer.endRefreshing()
            }
        }
    }
    //UICollectionViewDelegate
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.dataArray[indexPath.row] as! UnsplashPictureModel
        let vc = PictureViewController()
        vc.model = model
        self.present(vc, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }

}

