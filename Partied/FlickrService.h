#import <Foundation/Foundation.h>
#import <AFHTTPClient.h>

@interface FlickrService : AFHTTPClient

+ (FlickrService *)sharedClient;
+ (void)photosWithBlock:(void (^)(NSArray *photos))block;
    
@end
