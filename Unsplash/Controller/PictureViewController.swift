//
//  PictureViewController.swift
//  Unsplash
//
//  Created by 范东 on 17/2/6.
//  Copyright © 2017年 范东. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

class PictureViewController: UIViewController {
    
    var model : UnsplashPictureModel!

    var finalImage : UIImage!
    
    lazy var progressView:UIProgressView = {
        let progressView = UIProgressView.init(frame: CGRect.init(x: 0, y: statusBarHeight, width: screenWidth, height: 2))
        progressView.progressViewStyle = UIProgressViewStyle.bar
        progressView.tintColor = UIColor.white
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black
        self.finalImage = nil;
        //Log
        log.info("图片宽:" + (self.model?.width)! + "高:" + (self.model?.height)!)
        //初始化滚动视图坐标
        var scrollViewHeight : CGFloat = 0.0
        scrollViewHeight = screenHeight - statusBarHeight
        var scrollViewWidth : CGFloat = 0.0
        scrollViewWidth = self.stringToFloat(str: (self.model?.width)!) * scrollViewHeight / self.stringToFloat(str: (self.model?.height)!)
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
        imageView.sd_setImage(with: URL.init(string: (self.model?.urls.regular)!), placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, progress: { (complete, total) in
//            log.info("已完成" + String.init(format: "%dKB", complete / 1024))
//            log.info("总共" + String.init(format: "%dKB", total / 1024))
//            log.info("图片下载进度" + String.init(format: "%.2f", Float(complete) / Float(total)))
            self.progressView.setProgress(Float(complete) / Float(total), animated: true)
        }, completed: { (image, error, cacheType, url) in
            self.progressView.progress = 0
            self.finalImage = image;
        })
        self.view.addSubview(self.progressView)
        //下滑手势
        let swipe = UISwipeGestureRecognizer.init(target: self, action: #selector(dismissVC))
        swipe.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipe)
//        //工具栏
//        let toolView = UIView.init(frame: CGRect.init(x: 10, y: screenHeight - 60, width: screenWidth - 20, height: 50))
//        toolView.backgroundColor = UIColor.white
//        toolView.layer.cornerRadius = 5
//        toolView.clipsToBounds = true
//        self.view.addSubview(toolView)
//        //下载按钮
//        let downloadBtn = UIButton.init(frame: CGRect.init(x: 5, y: 5, width: 40, height: 40))
//        downloadBtn.setImage(UIImage.init(named: "picture_btn_download"), for: UIControlState.normal)
//        downloadBtn.setImage(UIImage.init(named: "picture_btn_download"), for: UIControlState.highlighted)
//        downloadBtn.addTarget(self, action: #selector(downloadBtnAction), for: UIControlEvents.touchUpInside)
//        toolView.addSubview(downloadBtn)
//        //分享按钮
//        let shareBtn = UIButton.init(frame: CGRect.init(x: 50, y: 5, width: 40, height: 40))
//        shareBtn.setImage(UIImage.init(named: "picture_btn_share"), for: UIControlState.normal)
//        shareBtn.setImage(UIImage.init(named: "picture_btn_share"), for: UIControlState.highlighted)
//        shareBtn.addTarget(self, action: #selector(shareBtnAction), for: UIControlEvents.touchUpInside)
//        toolView.addSubview(shareBtn)
    }
    
    func dismissVC()  {
        self.dismiss(animated: true, completion: nil)
    }
    
    func downloadBtnAction() {
        log.info("点击下载图片"+self.model.urls.raw)
        if self.finalImage != nil {
            UIImageWriteToSavedPhotosAlbum(self.finalImage, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }else{
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.text
            hud.label.text = "未完成下载"
            hud.label.numberOfLines = 0;
            hud.hide(animated: true, afterDelay: 1)
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError: NSError?,contextInfo: AnyObject)
    {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.text
        if didFinishSavingWithError != nil {
            log.info("保存失败"+String.init(format: "%@", didFinishSavingWithError!))
            hud.label.text = String.init(format: "%@", didFinishSavingWithError!)
        } else {
            log.info("保存成功")
            hud.label.text = "保存成功"
        }
        hud.label.numberOfLines = 0;
        hud.hide(animated: true, afterDelay: 1)
    }

    func shareBtnAction() {
        log.info("分享图片"+self.model.urls.raw)
        if self.finalImage != nil {
            let activityItems = NSArray.init(object:self.finalImage)
            let activityVC:UIActivityViewController = UIActivityViewController.init(activityItems: activityItems as! [Any], applicationActivities: nil)
            activityVC.excludedActivityTypes = NSArray.init(objects:UIActivityType.airDrop,UIActivityType.postToWeibo,UIActivityType.mail,UIActivityType.saveToCameraRoll) as? [UIActivityType]
            self.present(activityVC, animated: true, completion: nil)
        }else{
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.text
            hud.label.text = "未完成下载"
            hud.label.numberOfLines = 0;
            hud.hide(animated: true, afterDelay: 1)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    //String to Float
    func stringToFloat(str:String)->(CGFloat){
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
