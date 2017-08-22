//
//  ViewController.m
//  ImageToGif
//
//  Created by Done.L on 2017/6/2.
//  Copyright © 2017年 Done.L. All rights reserved.
//

#import "ViewController.h"

#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 120, 100);
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitle:@"合成gif" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)click {
    UIImage *img1 = [UIImage imageNamed:@"1.png"];
    UIImage *img2 = [UIImage imageNamed:@"2.png"];
    UIImage *img3 = [UIImage imageNamed:@"3.png"];
    UIImage *img4 = [UIImage imageNamed:@"4.png"];
    
    
    
    
    NSString *str = [self exportGifImages:@[img1, img2, img3, img4] delays:@[@0.1, @0.2, @0.3, @0.4] loopCount:0];
    NSLog(@"str = %@", str);
}

- (NSString *)exportGifImages:(NSArray *)images delays:(NSArray *)delays loopCount:(NSUInteger)loopCount
{
    NSString *fileName = [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"gif"];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:filePath], kUTTypeGIF, images.count, NULL);
    if(!loopCount) {
        loopCount = 0;
    }
    
    NSDictionary *gifProperties = @{ (__bridge id)kCGImagePropertyGIFDictionary : @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @(loopCount), // 0 means loop forever
                                             }
                                     };
    float delay = 0.1; //默认每一帧间隔0.1秒
    for (int i = 0; i < images.count; i++) {
        UIImage *itemImage = images[i];
        if(delays && i < delays.count){
            delay = [delays[i] floatValue];
        }
        //每一帧对应的延迟时间
        NSDictionary *frameProperties = @{(__bridge id)kCGImagePropertyGIFDictionary: @{
                                                  (__bridge id)kCGImagePropertyGIFDelayTime: @(delay), // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                                  }
                                          };
        
        CGImageDestinationAddImage(destination,itemImage.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }
    
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifProperties);
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);
    return filePath;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
