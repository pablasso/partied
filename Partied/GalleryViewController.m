#import "GalleryViewController.h"
#import <AQGridView.h>
#import <UIImageView+AFNetworking.h>
#import "PhotoViewController.h"
#import "NormalCell.h"
#import "Photo.h"

static CGRect const kCellFrame = {0.0f, 0.0f, 100.0f, 100.0f};

@interface GalleryViewController () <AQGridViewDelegate, AQGridViewDataSource>

@property (nonatomic, strong) IBOutlet AQGridView *gridView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic) BOOL geoActive;

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
    self.geoActive = NO;
    
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	self.gridView.autoresizesSubviews = YES;
	self.gridView.delegate = self;
	self.gridView.dataSource = self;
    
    [self setupGeoButton];
    [self requestPhotos];
}


- (void)viewWillAppear:(BOOL)animated {
    self.title = @"Partied!";
}

- (void)viewWillDisappear:(BOOL)animated {
    self.title = @"Back";
}

#pragma mark - Private

- (void)triggerGeolocalization {
    [self requestPhotos];
    self.geoActive = !self.geoActive;
    [self setupGeoButton];
}

- (void)setupGeoButton {
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItemStyle style = !self.geoActive ? UIBarButtonItemStyleDone : UIBarButtonItemStylePlain;
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Near You" style:style
                                                              target:self action:@selector(triggerGeolocalization)];
    self.navigationItem.rightBarButtonItem = button;
}

- (void)requestPhotos {
    [self.items removeAllObjects];
    
    [Photo photosGeolocated:self.geoActive withBlock:^(NSArray *photos) {
        [self.items addObjectsFromArray:photos];
        [self.gridView reloadData];
    }];
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
