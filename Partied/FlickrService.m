#import "FlickrService.h"
#import <AFJSONRequestOperation.h>
#import "Photo.h"

static NSString * const kFlickrKey = @"926fa72beface70c41aaabd43cfc0db6";
static NSString * const kFlickrSecret = @"6f5b3b0e4ee45971";
static NSString * const kFlickrBaseURL = @"http://api.flickr.com/";

@implementation FlickrService

#pragma mark - Public

+ (void)photosWithBlock:(void (^)(NSArray *photos))block {
    NSString *path = @"services/rest/";
    NSDictionary *parameters = @{@"method": @"flickr.photos.search",
                                 @"api_key": kFlickrKey,
                                 @"format": @"json",
                                 @"nojsoncallback": @"1",
                                 @"tags": @"party"};
    
    NSURLRequest *request = [[FlickrService sharedClient] requestWithMethod:@"GET" path:path parameters:parameters];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSDictionary *json) {
        if (IsEmpty(json) || IsEmpty(json[@"photos"])) {
            block(@[]);
            return;
        }
        
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        for (NSDictionary *dictionary in json[@"photos"][@"photo"]) {
            NSString *thumbnailPhoto = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_t.jpg",
                                        dictionary[@"farm"], dictionary[@"server"],
                                        dictionary[@"id"], dictionary[@"secret"]];
            
            NSString *bigPhoto = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_b.jpg",
                                  dictionary[@"farm"], dictionary[@"server"],
                                  dictionary[@"id"], dictionary[@"secret"]];

            
            Photo *photo = [[Photo alloc] init];
            photo.title = dictionary[@"title"];
            photo.thumbnailURL = thumbnailPhoto;
            photo.photoURL = bigPhoto;
            
            [photos addObject:photo];
        }
        
        block(photos);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        DLog(@"photosWithBlock error:%@", error);
        block(@[]);
    }];
    
    [operation start];
}

#pragma mark - Private

+ (FlickrService *)sharedClient {
    static FlickrService *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[FlickrService alloc] initWithBaseURL:[NSURL URLWithString:kFlickrBaseURL]];
    });
    
    return _sharedClient;
}

@end
