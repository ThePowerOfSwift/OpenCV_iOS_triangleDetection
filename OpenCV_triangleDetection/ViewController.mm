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

    imageRGBA = [UIImage imageNamed:@"triangle_hands1.jpg"];
    // imageRGBA = [UIImage imageNamed:@"triangle_hands2.jpg"];
    
    if(imageRGBA != nil)
    {
        // ==============================================
        // ==============================================
        // ==============================================

        // Convert the original image to IplImage
        IplImage* img = new IplImage([UIImage_openCV cvMatFromUIImage:imageRGBA]);

        // Convert to greyscale
        IplImage* imgGrayScale = cvCreateImage(cvGetSize(img), 8, 1);
        cvCvtColor(img,imgGrayScale,CV_BGR2GRAY);

        //thresholding the grayscale image to get better results
        cvThreshold(imgGrayScale,imgGrayScale,128,255,CV_THRESH_BINARY);

        CvSeq* contours;  //hold the pointer to a contour in the memory block
        CvSeq* result;   //hold sequence of points of a contour
        CvMemStorage *storage = cvCreateMemStorage(0); //storage area for all contours

        //finding all contours in the image
        cvFindContours(imgGrayScale, storage, &contours, sizeof(CvContour), CV_RETR_LIST, CV_CHAIN_APPROX_SIMPLE, cvPoint(0,0));

        //iterating through each contour
        while(contours)
        {
            //obtain a sequence of points of contour, pointed by the variable 'contour'
            result = cvApproxPoly(contours, sizeof(CvContour), storage, CV_POLY_APPROX_DP, cvContourPerimeter(contours)*0.15, 0);

            if(result->total == 3)
            {
                //iterating through each point
                CvPoint *pt[result->total];
                for(int i=0;i<result->total;i++)
                {
                    pt[i] = (CvPoint*)cvGetSeqElem(result, i);

                    // Draw
                    if(i > 0)
                    {
                        cvLine(img, *pt[(i - 1)], *pt[i], cvScalar(255,0,0),2);
                    }
                    if(i == (result->total-1))
                    {
                        cvLine(img, *pt[i], *pt[0], cvScalar(255,0,0),2);
                    }
                }
            }

            //obtain the next contour
            contours = contours->h_next;
        }

        // ==============================================
        // ==============================================
        // ==============================================

        _imageView.image = [UIImage_openCV UIImageFromCVMat: cv::cvarrToMat(img)];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end