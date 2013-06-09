#import "Photo.h"

@implementation Photo

- (NSString *)description {
    return [NSString stringWithFormat:@"url:%@ title:%@", self.photoURL, self.title];
}

@end
