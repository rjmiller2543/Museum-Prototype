//
//  ViewController.h
//  Museum-Prototype
//
//  Created by Robert Miller on 8/9/14.
//  Copyright (c) 2014 Robert Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
//#import <Parse/Parse.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, UIAlertViewDelegate, UIScrollViewDelegate>

#pragma mark - Beacon Objects
@property (nonatomic, retain) CLBeaconRegion *beaconRegion;
@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, retain) NSNumber *entryFlag;

#pragma mark - Page Control and View
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UIView *artWorkView;
@property (nonatomic, retain) UIView *artworkDescriptionView;
@property (nonatomic, retain) UIView *artistView;
@property (nonatomic, retain) UIView *artistDescriptionView;

#pragma mark - UI Elements
/* might be reused... */
//View Elements
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UILabel *artworkLabel;
@property (nonatomic, retain) UIImageView *artworkImage;
@property (nonatomic, retain) UITextView *artworkDescription;
@property (nonatomic, retain) UILabel *artistLabel;
@property (nonatomic, retain) UIImageView *artistImage;
@property (nonatomic, retain) UITextView *artistDescription;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) UIButton *playButton;

//Other Objects
@property (nonatomic, retain) NSNumber *currentMajor;
@property (nonatomic, retain) NSNumber *currentMinor;

@end
