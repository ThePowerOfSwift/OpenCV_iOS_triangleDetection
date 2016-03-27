//
//  ViewController.m
//  OpenCV_triangleDetection
//
//  Created by Kim SAVAROCHE on 26/03/2016.
//  Copyright (c) 2016 Kim SAVAROCHE. All rights reserved.
//


#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // imageRGBA = [UIImage imageNamed:@"triangle_hands1.jpg"];
    imageRGBA = [UIImage imageNamed:@"triangle_hands2.jpg"];
    
    if(imageRGBA != nil)
    {
        OpencvContourDetector *contourDetector = [[OpencvContourDetector alloc] initWithImage:imageRGBA];
        [contourDetector findBiggestPolygon:3];
        _imageView.image = [contourDetector drawBiggestPolygon:imageRGBA :255 :0 :0];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end