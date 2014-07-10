//
//  ADImagesListViewController.h
//  ADZipURLProtocolDemo
//
//  Created by Edouard Siegel on 7/10/14.
//
//

#import <UIKit/UIKit.h>

@interface ADImagesListViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) IBOutlet UICollectionView * collectionView;
@end
