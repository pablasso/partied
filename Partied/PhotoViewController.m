#import "PhotoViewController.h"
#import <UIImageView+AFNetworking.h>
#import "Photo.h"

static CGSize const kMaxTitleLabelSize = {300.0f, 100.0f};
static CGFloat const kTitleViewPadding = 10.0f;

@interface PhotoViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) Photo *photo;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIView *titleView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

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
    [self setupTitleView];
    [self.imageView setImageWithURL:[NSURL URLWithString:self.photo.photoURL]];
    
    self.scrollView.contentSize = self.imageView.bounds.size;
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = 5.0f;
    self.scrollView.bounces = NO;
}

#pragma mark - Private

- (void)setupTitleView {
    CGSize textSize = [self.photo.title sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:kMaxTitleLabelSize];
    CGFloat y = CGRectGetHeight(self.view.bounds) - textSize.height - (kTitleViewPadding * 2.0f);
    CGFloat height = textSize.height + (kTitleViewPadding * 2.0f);
    self.titleView.frame = CGRectMake(0.0f, y, CGRectGetWidth(self.view.bounds), height);
    self.titleLabel.text = self.photo.title;
    [self showTitleView];
}

- (void)showTitleView {
    [UIView animateWithDuration:0.5f animations:^{
        self.titleView.alpha = 1.0f;
    }];
}

- (void)hideTitleView {
    [UIView animateWithDuration:0.5f animations:^{
        self.titleView.alpha = 0.0f;
    }];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    if (scale == 1.0f) {
        [self showTitleView];
    }
    else {
        [self hideTitleView];
    }
}

@end
