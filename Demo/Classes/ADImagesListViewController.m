//
//  ADImagesListViewController.m
//  ADZipURLProtocolDemo
//
//  Created by Edouard Siegel on 7/10/14.
//
//

#import "ADImagesListViewController.h"
#import "ADImageCollectionViewCell.h"
#import "ADZipURLProtocol.h"

@interface ADImagesListViewController ()

@end

static NSString * sImageCollectionViewCellIdentifier = @"imageCollectionViewCellIdentifier";

@implementation ADImagesListViewController
#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Images example";
    [self.collectionView registerNib:[UINib nibWithNibName:[ADImageCollectionViewCell.class description] bundle:nil]
          forCellWithReuseIdentifier:sImageCollectionViewCellIdentifier];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ADImageCollectionViewCell * cell = (ADImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:sImageCollectionViewCellIdentifier
                                                                                                              forIndexPath:indexPath];
    NSString * imageName = [NSString stringWithFormat:@"adzip://images.zip/%@_%ld.jpg",
                            indexPath.section == 0 ? @"kitty" : @"otter",
                            (long)indexPath.row];
    NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]];
    UIImage * image = [UIImage imageWithData:imageData];
    cell.imageView.image = image;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return UIEdgeInsetsMake(0, 10, 10, 10);
}
@end
