#import "NormalCell.h"

@implementation NormalCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)aReuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:aReuseIdentifier]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

@end
