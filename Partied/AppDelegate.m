#import "AppDelegate.h"
#import "GalleryViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.galleryController = [[GalleryViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = self.galleryController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
