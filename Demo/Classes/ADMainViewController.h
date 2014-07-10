//
//  ADMainViewController.h
//  ADZipURLProtocol
//
//  Created by Edouard Siegel on 4/4/14.
//
//

#import <UIKit/UIKit.h>

@interface ADMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView * tableView;
@end
