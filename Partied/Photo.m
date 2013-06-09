#import "Photo.h"
#import "FlickrService.h"

@implementation Photo

- (NSString *)description {
    return [NSString stringWithFormat:@"url:%@ title:%@", self.photoURL, self.title];
}

#pragma mark - Public

// returns results from N services
// services must respond to the selector: photosWithBlock:
// and return an array of Photo objects
+ (void)photosGeolocated:(BOOL)geolocated withBlock:(void (^)(NSArray *photos))block {
    NSArray *services = [Photo enabledServices];
    __block NSInteger completedServices = 0;
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    for (id service in services) {
        if ([[service class] respondsToSelector:@selector(photosGeolocated:withBlock:)]) {
            [[service class] photosGeolocated:geolocated withBlock:^(NSArray *photos) {
                if (!IsEmpty(photos)) {
                    [results addObjectsFromArray:photos];
                }
                
                completedServices++;
                if (completedServices >= [services count]) {
                    block(results);
                }
            }];
        }
    }
}

#pragma mark - Private

// this is meant to return a list of photo providers, could be refactored eventually to be dynamic.
+ (NSArray *)enabledServices {
    FlickrService *flickrService = [FlickrService sharedClient];
    return @[flickrService];
}

@end
