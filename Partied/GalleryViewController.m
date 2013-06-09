#import "GalleryViewController.h"
#import "FlickrService.h"

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FlickrService photosWithBlock:^(NSArray *photos) {
        DLog(@"photos:%@", photos);
    }];
}

@end
