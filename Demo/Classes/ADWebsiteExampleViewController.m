//
//  ADWebsiteExampleViewController.m
//  ADZipURLProtocolDemo
//
//  Created by Edouard Siegel on 7/10/14.
//
//

#import "ADWebsiteExampleViewController.h"

@interface ADWebsiteExampleViewController ()

@end

@implementation ADWebsiteExampleViewController
#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UIWebView Example";
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"adzip://website.zip"]]];
}

@end
