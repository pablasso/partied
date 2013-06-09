#import "PhotoViewController.h"
#import <UIImageView+AFNetworking.h>
#import "Photo.h"

@interface PhotoViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) Photo *photo;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end

@implementation PhotoViewController

- (id)initWithPhoto:(Photo *)photo {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.photo = photo;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imageView setImageWithURL:[NSURL URLWithString:self.photo.photoURL]];
    self.scrollView.contentSize = self.imageView.bounds.size;
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = 5.0f;
    self.scrollView.bounces = NO;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
