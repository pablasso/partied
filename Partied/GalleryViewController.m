#import "GalleryViewController.h"
#import "FlickrService.h"

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Partied!";
    
    [FlickrService photosWithBlock:^(NSArray *photos) {
        DLog(@"photos:%@", photos);
    }];
}

@end
