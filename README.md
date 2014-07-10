# ADZipURLProtocol - Open static website or access data from a zip archive

ADZipURLProtocol brings you an easy way to directly access data stored inside zip files in your iOS application, by the mean of our custom `NSURLProtocol`. Zip it, add the archive to your iOS project, and seamlessly load the data using a common URL request. Using this library, `UIWebView`'s `loadRequest:` could now read the archive of a static website on the fly – Take a look at the demo project for an example of this – but that's not its only use. Download a zip of images, text files, or whatever you wish for, and access it using the `NSData`'s `dataWithContentsOfURL:`.

## Installation

### Basic
1. Add the content of the `ADZipURLProtocol` folder to your iOS project
2. Check http://www.nih.at/libzip/index.html and download the latest version of the libzip library
3. Either add the libzip library to your iOS project, or set it up as another target that your project depends upon
4. Link against the `libz.dylib` library if you don't already

### ARC

This library uses ARC. If used in a non-ARC project, use the `-fobjc-arc` flag to activate it on specific files in *Build Phases > Compile Sources*.

### 64-bit architectures

As of today (July 10th 2014) the downloaded libzip library is missing an include for your Xcode project to build using Standard architectures (armv7, armv7s, armv64).
To fix this issue, simply add the following line to `mkstemp.c`.

```objective-c
#include <unistd.d>
```

## Example

Your project is now ready to use `ADZipURLProtocol`. A demo Xcode project is provided in the `Demo` folder.

#### In short:
1. Register `ADZipURLProtocol` as a `NSURLProtocol` in your ApplicationDelegate `didFinishLaunchingWithOptions`
2. Zip your data and add the archive to your iOS Project
3. For a website : Use a webview to load a request using the following format: `adzip://file.zip` (if your website has an index.html file, otherwise append the path to your home file)
4. If you need to access the data itself, use `[NSData dataWithContentsOfURL:@"adzip://file.zip/path/to/file.extension"]`

#### In details:

First of all, register `ADZipURLProtocol` in your `ApplicationDelegate`

```objective-c
#import "ADZipURLProtocol.h"

…
#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSURLProtocol registerClass:[ADZipURLProtocol class]];
    …
    [self.window makeKeyAndVisible];
    return YES;
}
```

Then, zip your data, and add it to your Project in Xcode.

```
cd myDataDirectory
zip -r myArchivedData.zip .
```

##### Static website use
In your webview controller, load the following request, to open the index.html page at the root of the archive folder:

```objective-c
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"adzip://myArchivedData.zip"]]];
```

And that's pretty much it ! You may want to add a toolbar with some navigation buttons (Back, Forward, Reload) too.

##### Local data storage use
If you have some data files you actually want to access in your code, for instance an image you want to set to a `UIImageView`:
```objective-c
    NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"adzip://myArchivedData.zip/image_01.png"]];
    UIImage * image = [UIImage imageWithData:imageData];
    self.imageView.image = image;
```


### Methods

`ADZipURLProtocol` main goal is to be easy to use, but to keep a bit of flexibility, we added a searchPath class setter, which allows you to store the zip archive where you like best.
For instance, this is useful if you download the zip from the internet and save it in the Documents directory.

```objective-c
+ (void)setSearchPath:(NSArray *)searchPaths;
```

## Future Work

Feel free to send us pull requests if you want to contribute!
