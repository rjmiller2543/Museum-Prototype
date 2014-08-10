//
//  AppDelegate.h
//  Museum-Prototype
//
//  Created by Robert Miller on 8/9/14.
//  Copyright (c) 2014 Robert Miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CanceledObject.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+(id)sharedInstance;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSMutableArray *canceledObjects;

-(void)addCanceledObjectWithMajor:(NSNumber *)major andMinor:(NSNumber *)minor;

@end
