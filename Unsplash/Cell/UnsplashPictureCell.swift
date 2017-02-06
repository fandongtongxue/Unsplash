//
//  UnsplashPictureCell.swift
//  Unsplash
//
//  Created by 范东 on 17/2/6.
//  Copyright © 2017年 范东. All rights reserved.
//

import UIKit

class UnsplashPictureCell: UICollectionViewCell {
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var imageView : UIImageView?
    var model : UnsplashPictureModel?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //初始化各种控件
        var imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth/3, height: screenHeight/3))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        self.imageView = imageView
    }
    
    func setModel(model:UnsplashPictureModel) {
        self.imageView?.sd_setImage(with: URL.init(string: model.urls.small))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
