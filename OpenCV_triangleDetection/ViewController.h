//
//  ViewController.h
//  OpenCV_triangleDetection
//
//  Created by Kim SAVAROCHE on 26/03/2016.
//  Copyright (c) 2016 Kim SAVAROCHE. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>

@interface ViewController : UIViewController {
    UIImage *imageRGBA;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (cv::Mat)cvMatFromUIImage:(UIImage *)image;
- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image;
- (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;

@end
