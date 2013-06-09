#import "GalleryViewController.h"
#import <AQGridView.h>
#import <UIImageView+AFNetworking.h>
#import "PhotoViewController.h"
#import "FlickrService.h"
#import "NormalCell.h"
#import "Photo.h"

static CGRect const kCellFrame = {0.0f, 0.0f, 100.0f, 100.0f};

@interface GalleryViewController () <AQGridViewDelegate, AQGridViewDataSource>

@property (nonatomic, strong) IBOutlet AQGridView *gridView;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation GalleryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.items = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.gridView.autoresizesSubviews = YES;
	self.gridView.delegate = self;
	self.gridView.dataSource = self;
    
    [FlickrService photosWithBlock:^(NSArray *photos) {
        [self.items addObjectsFromArray:photos];
        [self.gridView reloadData];
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    self.title = @"Partied!";
}

- (void)viewWillDisappear:(BOOL)animated {
    self.title = @"Back";
}

#pragma mark - AQGridViewDelegate

- (void)gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index {
    Photo *photo = [self.items objectAtIndex:index];
    PhotoViewController *photoController = [[PhotoViewController alloc] initWithPhoto:photo];
    [self.navigationController pushViewController:photoController animated:YES];
}

#pragma mark - AQGridViewDataSource

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)gridView {
    return [self.items count];
}

- (AQGridViewCell *)gridView:(AQGridView *)gridView cellForItemAtIndex:(NSUInteger)index {
    NSString *identifier = @"NormalCell";
    
    NormalCell *cell = (NormalCell *)[gridView dequeueReusableCellWithIdentifier:identifier];
    if (IsEmpty(cell)) {
        cell = [[NormalCell alloc] initWithFrame:kCellFrame reuseIdentifier:identifier];
        cell.selectionStyle = AQGridViewCellSelectionStyleBlue;
    }
    
    Photo *photo = [self.items objectAtIndex:index];
    [cell.imageView setImageWithURL:[NSURL URLWithString:photo.thumbnailURL]];
    return cell;
}

@end
