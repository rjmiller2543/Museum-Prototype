//
//  ViewController.m
//  Museum-Prototype
//
//  Created by Robert Miller on 8/9/14.
//  Copyright (c) 2014 Robert Miller. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

#define UUID @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"

@implementation ViewController

-(void)configureView
{
    //Create Scroll View and set its content size and frame
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1400)];
    
    //Create the play button for playing the audio portion of the piece
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 20, 30, 30)];
    [_playButton setImage:[UIImage imageNamed:@"play-26.png"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_playButton];
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Artwork"];
    //[query whereKey:@"objectId" equalTo:@"iTJRCi84yA"];
    [query getObjectInBackgroundWithId:@"iTJRCi84yA" block:^(PFObject *object, NSError *error) {
        if (!error) {
            
            //Set the label
            _artworkLabel.text = object[@"artWork"];
        
            //create the file then download the image data from parse, and finally, set the image to the imagedata in the background
            PFFile *imageFile = object[@"piecePicture"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    _artworkImage.image = [UIImage imageWithData:imageData];
                }
            }];
            
            //Set the description text
            _artworkDescription.text = object[@"pieceDescription"];
            
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

-(void)showObject
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
            
            //create the file then download the image data from parse, and finally, set the image to the imagedata in the background
            PFFile *imageFile = object[@"piecePicture"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    _artworkImage.image = [UIImage imageWithData:imageData];
                }
            }];
            
            //Set the description text
            _artworkDescription.text = object[@"pieceDescription"];
            
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
            
            _artistLabel.text = object[@"artistName"];
            _artistDescription.text = object[@"artistProfile"];
            
            PFFile *artistImageFile = object[@"artistPicture"];
            [artistImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    _artistImage.image = [UIImage imageWithData:imageData];
                }
            }];
            
        }
    }];
}
-(void)cancelObject
{
    //_entryFlag = [NSNumber numberWithBool:TRUE];
    [[AppDelegate sharedInstance] addCanceledObjectWithMajor:_currentMajor andMinor:_currentMinor];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self showObject];
            break;
        case 1:
            [self cancelObject];
            break;
        default:
            break;
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
