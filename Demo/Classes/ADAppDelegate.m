//
//  ADAppDelegate.m
//  ADZipURLProtocol
//
//  Created by Romain Goyet on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ADAppDelegate.h"
#import "ADMainViewController.h"
#import "ADZipURLProtocol.h"

@implementation ADAppDelegate
@synthesize window = _window;

#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSURLProtocol registerClass:[ADZipURLProtocol class]];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:[[ADMainViewController alloc] initWithNibName:nil bundle:nil]];
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
@end
