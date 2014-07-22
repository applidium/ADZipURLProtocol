//
//  ADZipURLProtocol.m
//  CanalPlus
//
//  Created by Edouard Siegel on 3/4/14.
//
//

#import "ADZipURLProtocol.h"

static NSArray * sADZipURLProtocolSearchPath = nil;
#define AD_ZIP_PROTOCOL_READ_BUFFER_LENGTH 16384

@interface ADZipURLProtocol ()
@property (nonatomic, strong) NSURL * lastReqURL;
+ (NSArray *)_searchPath;
@end

@implementation ADZipURLProtocol
#pragma mark - NSObject
- (void)dealloc {
    if (_readBuffer != NULL) {
        free(_readBuffer);
    }
    if (_zipFile != NULL) {
        zip_fclose(_zipFile);
    }
    if (_zip != NULL) {
        zip_discard(_zip);
    }
}

#pragma mark - NSURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return [request.URL.scheme isEqualToString:@"adzip"];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (id)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id < NSURLProtocolClient >)client {
    self = [super initWithRequest:request cachedResponse:cachedResponse client:client];
    if (self) {
        // We store the request URL to send it back in the NSURLResponse, so the following requests properly handle any relative path
        _lastReqURL = request.URL;
        NSString * archiveName = request.URL.host;
        NSArray * searchPath = [[self class] _searchPath];
        _zip = NULL;
        for (NSArray * directory in searchPath) {
            NSString * zipFilePath = [(NSString *)directory stringByAppendingPathComponent:archiveName];

            int error = 0;
            _zip = zip_open(zipFilePath.UTF8String, 0, &error);
            if (_zip != NULL) {
                break;
            }
        }
        if (_zip == NULL) {
            NSLog(@"Could not find a zipfile named \"%@\" in \"%@\"", archiveName, searchPath);
        } else {
            // The following can be used to list every file in the _zip archive
            /*
             zip_int64_t numEntries = zip_get_num_entries(_zip, 0);
             for (int i = 0; i <numEntries; i++) {
             const char * name = zip_get_name(_zip, i, 0);
             NSLog(@"File at index %d is \"%s\"",i, name);
             }
             */

            NSString * fileName = request.URL.path;
            if ([fileName hasPrefix:@"/"]) {
                fileName = [fileName substringFromIndex:1]; // Remove the leading slash if present
            }
            _zipFile = zip_fopen(_zip, fileName.UTF8String, ZIP_FL_UNCHANGED);
            if (_zipFile == NULL) { // Let's do as if we were a webserver and try appending "index.html" if the URL referenced a folder
                NSLog(@"Could not find a file named \"%@\" in archive, trying to append index.html", fileName);
                fileName = [fileName stringByAppendingPathComponent:@"index.html"];
                _zipFile = zip_fopen(_zip, fileName.UTF8String, ZIP_FL_UNCHANGED);
            }
            if (_zipFile == NULL) {
                NSLog(@"Could not find a file named \"%@\" in archive", fileName);
            }
            _readBuffer = malloc(AD_ZIP_PROTOCOL_READ_BUFFER_LENGTH);
            if (_readBuffer == NULL) {
                NSLog(@"Couldn't allocate read buffer !");
            }
        }
    }
    return self;
}

- (void)startLoading {
    if (_zip && _zipFile && _readBuffer) {
        [self.client URLProtocol:self
              didReceiveResponse:[[NSURLResponse alloc] initWithURL:_lastReqURL MIMEType:nil expectedContentLength:-1 textEncodingName:nil]
              cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        int numberOfBytesRead;
        do {
            numberOfBytesRead = (int)zip_fread(_zipFile, _readBuffer, AD_ZIP_PROTOCOL_READ_BUFFER_LENGTH);
            if (numberOfBytesRead >= 0) {
                NSData * data = [NSData dataWithBytes:_readBuffer length:numberOfBytesRead];
                [self.client URLProtocol:self didLoadData:data];
            }
        } while (numberOfBytesRead > 0);
        [self.client URLProtocolDidFinishLoading:self];
    } else {
        [self.client URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSFileNoSuchFileError userInfo:nil]];
    }
}

- (void)stopLoading {
}

#pragma mark - Methods
+ (void)setSearchPath:(NSArray *)searchPaths {
    sADZipURLProtocolSearchPath = searchPaths;
}

#pragma mark - Private
+ (NSArray *)_searchPath {
    return sADZipURLProtocolSearchPath ? sADZipURLProtocolSearchPath : @[[[NSBundle mainBundle] resourcePath]];
}
@end

