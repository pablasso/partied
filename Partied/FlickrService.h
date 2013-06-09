#import <Foundation/Foundation.h>
#import <AFHTTPClient.h>

@interface FlickrService : AFHTTPClient

+ (FlickrService *)sharedClient;
+ (void)photosGeolocated:(BOOL)geolocated withBlock:(void (^)(NSArray *photos))block;
    
@end
