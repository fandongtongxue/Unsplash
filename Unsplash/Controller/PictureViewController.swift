//
//  PictureViewController.swift
//  Unsplash
//
//  Created by 范东 on 17/2/6.
//  Copyright © 2017年 范东. All rights reserved.
//

import UIKit
import SDWebImage

class PictureViewController: UIViewController {
    
    var model : UnsplashPictureModel?
    
    lazy var progressView:UIProgressView = {
        let progressView = UIProgressView.init(frame: CGRect.init(x: 0, y: statusBarHeight, width: screenWidth, height: 2))
        progressView.progressViewStyle = UIProgressViewStyle.bar
        progressView.tintColor = UIColor.blue
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black
        //Log
        log.info("图片宽:" + (self.model?.width)! + "高:" + (self.model?.height)!)
        //初始化滚动视图坐标
        var scrollViewHeight : CGFloat = 0.0
        scrollViewHeight = screenHeight - statusBarHeight
        var scrollViewWidth : CGFloat = 0.0
        scrollViewWidth = self.StringToFloat(str: (self.model?.width)!) * scrollViewHeight / self.StringToFloat(str: (self.model?.height)!)
        log.info("适应后图片宽:" + String.init(format: "%.2f", scrollViewWidth) + "高:" + String.init(format: "%.2f", scrollViewHeight))
        //滚动视图
        let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: statusBarHeight, width: screenWidth, height: screenHeight - statusBarHeight))
        scrollView.contentSize = CGSize.init(width: scrollViewWidth, height: scrollViewHeight)
        self.view.addSubview(scrollView)
        //图片
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        scrollView.addSubview(imageView)
        log.info("图片地址" + (self.model?.urls.regular)!)
        imageView.sd_setImage(with: URL.init(string: (self.model?.urls.raw)!), placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, progress: { (complete, total) in
//            log.info("已完成" + String.init(format: "%dKB", complete / 1024))
//            log.info("总共" + String.init(format: "%dKB", total / 1024))
//            log.info("图片下载进度" + String.init(format: "%.2f", Float(complete) / Float(total)))
            self.progressView.setProgress(Float(complete) / Float(total), animated: true)
        }, completed: { (image, error, cacheType, url) in
            self.progressView.progress = 0
        })
        self.view.addSubview(self.progressView)
        //按钮
        let closeBtn = UIButton.init(type: UIButtonType.infoLight)
        closeBtn.frame = CGRect.init(x: screenWidth - 32, y: 10 + statusBarHeight, width: 22, height: 22)
        closeBtn.addTarget(self, action: #selector(dismissVC), for: UIControlEvents.touchUpInside)
        self.view.addSubview(closeBtn)
    }
    
    func dismissVC()  {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    //String to Float
    func StringToFloat(str:String)->(CGFloat){
        let string = str
        var cgFloat: CGFloat = 0
        if let doubleValue = Double(string)
        {
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
