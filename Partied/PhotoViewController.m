#import "PhotoViewController.h"
#import <UIImageView+AFNetworking.h>
#import "Photo.h"

@interface PhotoViewController ()

@property (nonatomic, strong) Photo *photo;
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
    self.navigationController.navigationBar.backItem.title = @"Back";
    [self.imageView setImageWithURL:[NSURL URLWithString:self.photo.photoURL]];
}

@end
