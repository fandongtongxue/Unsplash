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
    var imageView :UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: statusBarHeight, width: screenWidth, height: screenHeight - statusBarHeight))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        self.view.addSubview(imageView)
        self.imageView = imageView
//        print("点击图片的地址:" + (self.model?.urls.raw)! as String)
        self.imageView?.sd_setImage(with: URL.init(string: (self.model?.urls.full)!), placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, progress: { (complete, total) in
//            print("已完成" + String.init(format: "%dKB", complete / 1024))
//            print("总共" + String.init(format: "%dKB", total / 1024))
        }, completed: { (image, error, cacheType, url) in
//            print("图片下载完成")
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
