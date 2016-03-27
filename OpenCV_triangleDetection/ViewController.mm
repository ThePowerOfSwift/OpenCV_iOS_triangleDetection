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

    // imageRGBA = [UIImage imageNamed:@"shapes1.png"];
    // imageRGBA = [UIImage imageNamed:@"shapes2.png"];
    imageRGBA = [UIImage imageNamed:@"triangle_hands1.jpg"];
    // imageRGBA = [UIImage imageNamed:@"triangle_hands2.jpg"];
    
    if(imageRGBA != nil)
    {
        // ==============================================
        // ==============================================
        // ==============================================

        // Convert the original image to IplImage
        IplImage* img = new IplImage([self cvMatFromUIImage:imageRGBA]);

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

            NSLog(@"%i contours \n", result->total);

            if(result->total >= 3)
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

        _imageView.image = [self UIImageFromCVMat: cv::cvarrToMat(img)];
    }
}

- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;

    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)

    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
            cols,                       // Width of bitmap
            rows,                       // Height of bitmap
            8,                          // Bits per component
            cvMat.step[0],              // Bytes per row
            colorSpace,                 // Colorspace
            kCGImageAlphaNoneSkipLast |
                    kCGBitmapByteOrderDefault); // Bitmap info flags

    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);

    return cvMat;
}

- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;

    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels

    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
            cols,                       // Width of bitmap
            rows,                       // Height of bitmap
            8,                          // Bits per component
            cvMat.step[0],              // Bytes per row
            colorSpace,                 // Colorspace
            kCGImageAlphaNoneSkipLast |
                    kCGBitmapByteOrderDefault); // Bitmap info flags

    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);

    return cvMat;
}

- (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;

    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }

    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);

    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,     //width
            cvMat.rows,                                 //height
            8,                                          //bits per component
            8 * cvMat.elemSize(),                       //bits per pixel
            cvMat.step[0],                              //bytesPerRow
            colorSpace,                                 //colorspace
            kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
            provider,                                   //CGDataProviderRef
            NULL,                                       //decode
            false,                                      //should interpolate
            kCGRenderingIntentDefault                   //intent
    );


    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);

    return finalImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end