#import "GalleryViewController.h"
#import "FlickrService.h"

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FlickrService photosWithBlock:^(NSArray *photos, NSError *error) {
        DLog(@"photos:%@", photos);
        DLog(@"error:%@", error);
    }];
}

@end
