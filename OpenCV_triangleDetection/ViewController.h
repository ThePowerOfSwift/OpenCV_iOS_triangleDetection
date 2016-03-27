//
//  ViewController.h
//  OpenCV_triangleDetection
//
//  Created by Kim SAVAROCHE on 26/03/2016.
//  Copyright (c) 2016 Kim SAVAROCHE. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Lib/UIImage_openCV.h"

@interface ViewController : UIViewController {
    UIImage *imageRGBA;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
