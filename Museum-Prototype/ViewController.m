//
//  ViewController.m
//  Museum-Prototype
//
//  Created by Robert Miller on 8/9/14.
//  Copyright (c) 2014 Robert Miller. All rights reserved.
//

#import "ViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface ViewController ()

@end

#define UUID @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"

@implementation ViewController

#define kScreenWidth 320
#define kPageVerticalOffset 45

int pageYoffset;

-(void)configureScrollView
{
    /* We're just gonna get rid of all of this code for now... */
    //Create Scroll View and set its content size and frame
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1400)];
    
    //Create the play button for playing the audio portion of the piece
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 20, 30, 30)];
    [_playButton setImage:[UIImage imageNamed:@"play-26.png"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
    /* let's not add the play button just yet... wait until the audio is loaded */
    //[_scrollView addSubview:_playButton];
    
    //Create and add the Artwork label
    _artworkLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 60, 120, 45)];
    _artworkLabel.text = @"temp artwork text";
    [_scrollView addSubview:_artworkLabel];
    
    //Create and add the artwork image
    _artworkImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 115, 280, 280)];
    _artworkImage.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:_artworkImage];
    
    //Create and add the artwork description
    _artworkDescription = [[UITextView alloc] initWithFrame:CGRectMake(20, 410, 280, 280)];
    _artworkDescription.text = @"Some testing stuff text for now basdflj";
    _artworkDescription.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:_artworkDescription];
    
    //Create and add the artist label
    _artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 705, 120, 45)];
    _artistLabel.text = @"temp artist name";
    [_scrollView addSubview:_artistLabel];
    
    //Create and add the artists image
    _artistImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 765, 280, 280)];
    _artistImage.backgroundColor = [UIColor blueColor];
    [_scrollView addSubview:_artistImage];
    
    //Create and add the artists description
    _artistDescription = [[UITextView alloc] initWithFrame:CGRectMake(20, 1060, 280, 280)];
    _artistDescription.backgroundColor = [UIColor lightGrayColor];
    _artistDescription.text = @"Some test text for the artists description";
    [_scrollView addSubview:_artistDescription];
    
    //Add Scroll View
    [self.view addSubview:_scrollView];
}

-(void)configureArtworkViewWithImage:(UIImage *)image
{
    /* This view goes on the first "page" of the scrollview */
    if (_artworkImage == NULL) {
        _artworkImage = [[UIImageView alloc] initWithFrame:_scrollView.frame];
        [_scrollView addSubview:_artworkImage];
    }
    if (image == NULL) {
        _artworkImage.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    }
    else {
        float widthToHeightRatio = image.size.height / image.size.width;
        _artworkImage.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * widthToHeightRatio);
        _artworkImage.image = image;
    }
}

-(void)configureArtworkDescriptionViewWithText:(NSString *)text
{
    if (_artworkDescription == NULL) {
        _artworkDescription = [[UITextView alloc] initWithFrame:CGRectMake(320, 0, 320, _scrollView.frame.size.height)];
        _artworkDescription.backgroundColor = [UIColor blackColor];
        [_scrollView addSubview:_artworkDescription];
    }
    _artworkDescription.text = text;
    _artworkDescription.textColor = [UIColor whiteColor];
}

-(void)configureArtistViewWithImage:(UIImage *)image
{
    if (_artistImage == NULL) {
        _artistImage = [[UIImageView alloc] initWithFrame:CGRectMake(320*2, 0, 320, _scrollView.frame.size.height)];
        _artistImage.backgroundColor = [UIColor blackColor];
        [_scrollView addSubview:_artistImage];
    }
    if (image == NULL) {
        _artistImage.backgroundColor = [UIColor blackColor];
    }
    else {
        float widthToHeightRatio = image.size.height / image.size.width;
        _artistImage.frame = CGRectMake(320*2, 0, kScreenWidth, kScreenWidth * widthToHeightRatio);
        _artistImage.image = image;
    }
}

-(void)configureArtistDescriptionViewWithText:(NSString *)text
{
    if (_artistDescription == NULL) {
        _artistDescription = [[UITextView alloc] initWithFrame:CGRectMake(320*3, 0, 320, _scrollView.frame.size.height)];
        _artistDescription.backgroundColor = [UIColor blackColor];
        [_scrollView addSubview:_artistDescription];
    }
    _artistDescription.text = text;
    _artistDescription.textColor = [UIColor whiteColor];
}

-(void)configureView
{
    
    //Create the play button for playing the audio portion of the piece
    if (_playButton == NULL) {
        _playButton = [[UIButton alloc] initWithFrame:CGRectMake(145, 20, 25, 25)];
        [_playButton setImage:[UIImage imageNamed:@"play-25.png"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
        _playButton.tintColor = [UIColor whiteColor];
        _playButton.layer.cornerRadius = 5.0;
        _playButton.backgroundColor = [UIColor whiteColor];
        /* let's not add the play button just yet... wait until the audio is loaded */
        //[self.view addSubview:_playButton];
    }
    if (_artworkLabel == NULL) {
        _artworkLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kPageVerticalOffset, 155, 0)];
        _artworkLabel.textColor = [UIColor whiteColor];
        _artworkLabel.text = @"Starting Up....";
        _artworkLabel.font = [UIFont boldSystemFontOfSize:20];
        [_artworkLabel sizeToFit];
        [self.view addSubview:_artworkLabel];
    }
    if (_artistLabel == NULL) {
        _artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, kPageVerticalOffset, 155, 0)];
        _artistLabel.textColor = [UIColor whiteColor];
        _artistLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _artistLabel.numberOfLines = 0;
        _artistLabel.text = @"Just give us a moment...";
        _artistLabel.font = [UIFont boldSystemFontOfSize:20];
        [_artistLabel sizeToFit];
        [self.view addSubview:_artistLabel];
    }
    if (_artistLabel.frame.size.height >= _artworkLabel.frame.size.height) {
        pageYoffset = _artistLabel.frame.size.height + kPageVerticalOffset;
    }
    else {
        pageYoffset = _artworkLabel.frame.size.height + kPageVerticalOffset;
    }
    //_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kPageVerticalOffset, 320, self.view.frame.size.height - kPageVerticalOffset)];
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, pageYoffset, 320, self.view.frame.size.height - pageYoffset)];
        [_scrollView setContentSize:CGSizeMake(320*4, pageYoffset)];
    }];
    
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    //_scrollView.contentSize = CGSizeMake(320*4, self.view.frame.size.height - pageYoffset);
    _scrollView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:_scrollView];
    
    [self configureArtworkViewWithImage:nil];
    [self configureArtworkDescriptionViewWithText:nil];
    [self configureArtistViewWithImage:nil];
    [self configureArtistDescriptionViewWithText:nil];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 25, 320, 25)];
    [_pageControl setNumberOfPages:4];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [_pageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setNeedsStatusBarAppearanceUpdate];
    self.view.backgroundColor = [UIColor blackColor];
    [self configureView];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Artwork"];
    //[query whereKey:@"objectId" equalTo:@"iTJRCi84yA"];
    [query getObjectInBackgroundWithId:@"iTJRCi84yA" block:^(PFObject *object, NSError *error) {
        if (!error) {
            
            //Set the label
            _artworkLabel.text = object[@"artWork"];
            _artworkLabel.textColor = [UIColor whiteColor];
            _artworkLabel.font = [UIFont boldSystemFontOfSize:20];
            [_artworkLabel sizeToFit];
            pageYoffset = _artworkLabel.frame.size.height + kPageVerticalOffset;
            //_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kPageVerticalOffset, 320, self.view.frame.size.height - kPageVerticalOffset)];
            [UIView animateWithDuration:0.5 animations:^{
                //_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, pageYoffset, 320, self.view.frame.size.height - pageYoffset)];
                [_scrollView setFrame:CGRectMake(0, pageYoffset, 320, self.view.frame.size.height - pageYoffset)];
                [_scrollView setContentSize:CGSizeMake(320*4, pageYoffset)];
            }];
            
            /* Since we set the artist label to some text, let's delete that text */
            _artistLabel.text = @"";
            
            //create the file then download the image data from parse, and finally, set the image to the imagedata in the background
            PFFile *imageFile = object[@"piecePicture"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    //_artworkImage.image = [UIImage imageWithData:imageData];
                    [self configureArtworkViewWithImage:[UIImage imageWithData:imageData]];
                    [SVProgressHUD dismiss];
                }
            } progressBlock:^(int percentDone) {
                NSLog(@"progress block with percent: %i", percentDone);
                float colorPercent = 1.0 - percentDone/100;
                [SVProgressHUD showProgress:percentDone/100];
                _artworkImage.backgroundColor = [UIColor colorWithRed:colorPercent green:colorPercent blue:colorPercent alpha:1.0];
            }];
            
            //Set the description text
            //_artworkDescription.text = object[@"pieceDescription"];
            [self configureArtworkDescriptionViewWithText:object[@"pieceDescription"]];
            
            PFFile *audioFile = object[@"audioFile"];
            //NSError *playtimeError;
            //NSURL *audioURL = [[NSURL alloc] initWithString:audioFile.url];
            //_audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&playtimeError];
            
            [audioFile getDataInBackgroundWithBlock:^(NSData *audioData, NSError *error) {
                if(!error) {
                    NSLog(@"audio is ready to play");
                    NSError *playtimeError;
                    _audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&playtimeError];
                    [_audioPlayer prepareToPlay];
                    [self.view addSubview:_playButton];
                }
            }];
            
        }
    }];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    //NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"9AE82622-3BE0-48E9-B5EE-201ECB23D55A"];
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];
    
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.beacon.testregion"];
    
    _beaconRegion.notifyOnEntry = YES;
    
    _beaconRegion.notifyOnExit = YES;
    
    _beaconRegion.notifyEntryStateOnDisplay = YES;
    
    
    
    [self.locationManager startMonitoringForRegion:_beaconRegion];
    
    [self.locationManager requestStateForRegion:_beaconRegion];
    
    //If I enable this line, ranging starts on all devices
    
    [self.locationManager startRangingBeaconsInRegion:_beaconRegion];
    
    //[self.locationManager startMonitoringForRegion:_beaconRegion];
    
    self.entryFlag = [NSNumber numberWithBool:TRUE];
}

#pragma mark - iBeacon Methods
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region   {
    
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region    {
    
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    
    //self.statusLabel.text = @"Left Beacon Region";
    NSLog(@"left beacon region");
    
    self.entryFlag = [NSNumber numberWithBool:FALSE];
    
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region    {
    
    //self.statusLabel.text = @"Beacon Found!";
    NSLog(@"beacon found");
    
    for (int i = 0; i < [beacons count]; i++) {
        CLBeacon *foundBeacon = [beacons objectAtIndex:i];
    
        //NSLog(@"beacon data: %@", foundBeacon.description);
        NSLog(@"beacon rssi: %ld beacon major: %@ beacon minor: %@", (long)foundBeacon.rssi, foundBeacon.major, foundBeacon.minor);
        NSLog(@"entryFlag: %@, current major: %@, current minor: %@", _entryFlag, _currentMajor, _currentMinor);
    
        if ((foundBeacon.rssi > -50) && (foundBeacon.rssi != 0) && ([_entryFlag boolValue] == TRUE) && !((foundBeacon.major == _currentMajor) && (foundBeacon.minor == _currentMinor))) {
            //_entryFlag = [NSNumber numberWithBool:FALSE];
            NSLog(@"we're in!");
        
            NSString *message = [[NSString alloc] initWithFormat:@"There is a beacon with major: %@ and minor: %@",foundBeacon.major, foundBeacon.minor];
            _currentMajor = foundBeacon.major;
            _currentMinor = foundBeacon.minor;
        
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"Beacon is close!" message:message delegate:self cancelButtonTitle:@"Show Me!" otherButtonTitles:@"Nah..", nil];
            alerView.delegate = self;
            [alerView show];
        }
    }
}

-(void)loadObject
{
    //_entryFlag = [NSNumber numberWithBool:TRUE];
    PFQuery *query = [PFQuery queryWithClassName:@"Artwork"];
    [query whereKey:@"major" equalTo:_currentMajor];
    [query whereKey:@"minor" equalTo:_currentMinor];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"there should be only 1 object.. is there?? %lu", (unsigned long)[objects count]);
            PFObject *object = [objects objectAtIndex:0];
            
            //Set the label
            _artworkLabel.text = object[@"artWork"];
            _artworkLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _artworkLabel.numberOfLines = 0;
            _artworkLabel.textColor = [UIColor whiteColor];
            _artworkLabel.font = [UIFont boldSystemFontOfSize:20];
            [_artworkLabel sizeToFit];
            
            _artistLabel.text = object[@"artistName"];
            _artistLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _artistLabel.numberOfLines = 0;
            _artistLabel.textColor = [UIColor whiteColor];
            _artistLabel.font = [UIFont boldSystemFontOfSize:20];
            [_artistLabel sizeToFit];
            
            if (_artistLabel.frame.size.height >= _artworkLabel.frame.size.height) {
                pageYoffset = _artistLabel.frame.size.height + kPageVerticalOffset;
            }
            else {
                pageYoffset = _artworkLabel.frame.size.height + kPageVerticalOffset;
            }
            //_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kPageVerticalOffset, 320, self.view.frame.size.height - kPageVerticalOffset)];
            [UIView animateWithDuration:0.5 animations:^{
                [_scrollView setFrame:CGRectMake(0, pageYoffset, 320, self.view.frame.size.height - pageYoffset)];
                [_scrollView setContentSize:CGSizeMake(320*4, pageYoffset)];
            }];
            
            //create the file then download the image data from parse, and finally, set the image to the imagedata in the background
            PFFile *imageFile = object[@"piecePicture"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    _artworkImage.alpha = 1.0;
                    [self configureArtworkViewWithImage:[UIImage imageWithData:imageData]];
                    //_artworkImage.image = [UIImage imageWithData:imageData];
                    [SVProgressHUD dismiss];
                }
            } progressBlock:^(int percentDone) {
                _artworkImage.alpha = 1.0 - percentDone/100;
                [SVProgressHUD showProgress:percentDone/100];
            }];
            
            //Set the description text
            //_artworkDescription.text = object[@"pieceDescription"];
            [self configureArtworkDescriptionViewWithText:object[@"pieceDescription"]];
            
            //Get the audio file from parse and load it into the audio player
            PFFile *audioFile = object[@"audioFile"];
            [audioFile getDataInBackgroundWithBlock:^(NSData *audioData, NSError *error) {
                if(!error) {
                    NSLog(@"audio is ready to play");
                    NSError *playtimeError;
                    _audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&playtimeError];
                    [_audioPlayer prepareToPlay];
                }
            }];
            
            //_artistLabel.text = object[@"artistName"];
            //_artistDescription.text = object[@"artistProfile"];
            [self configureArtistDescriptionViewWithText:object[@"artistProfile"]];
            
            PFFile *artistImageFile = object[@"artistPicture"];
            [artistImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    //_artistImage.image = [UIImage imageWithData:imageData];
                    [self configureArtistViewWithImage:[UIImage imageWithData:imageData]];
                }
            } progressBlock:^(int percentDone) {
                float colorPercent = 1.0 - percentDone/100;
                _artistImage.backgroundColor = [UIColor colorWithRed:colorPercent green:colorPercent blue:colorPercent alpha:1.0];
            }];
            
        }
    }];
}

-(void)cancelObject
{
    //_entryFlag = [NSNumber numberWithBool:TRUE];
    [[AppDelegate sharedInstance] addCanceledObjectWithMajor:_currentMajor andMinor:_currentMinor];
}

#pragma mark - Audio Methods
-(void)playAudio
{
    NSLog(@"-> play audio");
    if (_audioPlayer == NULL) {
        //do nothing
        NSLog(@"audio player is null");
    }
    else {
        if ([_audioPlayer isPlaying]) {
            [_audioPlayer pause];
        }
        else {
            [_audioPlayer play];
        }
    }
}

#pragma mark - Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [_scrollView scrollRectToVisible:CGRectMake(0, kPageVerticalOffset, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
            [self loadObject];
            break;
        case 1:
            [self cancelObject];
            break;
        default:
            break;
    }
}

-(void)pageChanged
{
    NSLog(@"page changed");
    int xOffset = _pageControl.currentPage * _scrollView.frame.size.width;
    //[_scrollView setContentOffset:CGPointMake(xOffset, 0)];
    [_scrollView scrollRectToVisible:CGRectMake(xOffset, kPageVerticalOffset, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    NSLog(@"the page is: %i", page);
    [_pageControl setCurrentPage:page];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
