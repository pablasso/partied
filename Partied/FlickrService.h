#import <Foundation/Foundation.h>
#import <AFHTTPClient.h>

@interface FlickrService : AFHTTPClient

+ (void)photosWithBlock:(void (^)(NSArray *photos))block;
    
@end
