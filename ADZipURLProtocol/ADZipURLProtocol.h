//
//  ADZipURLProtocol.h
//  CanalPlus
//
//  Created by Edouard Siegel on 3/4/14.
//
//

#import <Foundation/Foundation.h>
#import "zip.h"

// Handles URLs looking like "adzip://file.zip/folder/my_file.txt"
@interface ADZipURLProtocol : NSURLProtocol {
    struct zip      * _zip;
    struct zip_file * _zipFile;
    void            * _readBuffer;
}
// Paths where the protocol will look for the stored Zip archive
// Defaults to mainBundle resourcePath.
+ (void)setSearchPath:(NSArray *)searchPaths;
@end
