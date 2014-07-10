//
//  ADMainViewController.m
//  ADZipURLProtocol
//
//  Created by Edouard Siegel on 4/4/14.
//
//

#import "ADMainViewController.h"
#import "ADWebsiteExampleViewController.h"
#import "ADImagesListViewController.h"

@implementation ADMainViewController
#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ADZipURLProtocol Demo";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * sCellIdentifier = @"cellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellIdentifier];
    }
    cell.textLabel.text = indexPath.row == 0 ? @"WebView example" : @"Images example";
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController * controller = nil;
    switch (indexPath.row) {
        case 0:
            controller = [[ADWebsiteExampleViewController alloc] initWithNibName:nil bundle:nil];
            break;

        case 1:
            controller = [[ADImagesListViewController alloc] initWithNibName:nil bundle:nil];
            break;
        default:
            break;
    }
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
}
@end
