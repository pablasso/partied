#import "FlickrService.h"
#import <AFJSONRequestOperation.h>
#import "LocationHoncho.h"
#import "Photo.h"

static NSString * const kFlickrKey = @"926fa72beface70c41aaabd43cfc0db6";
static NSString * const kFlickrSecret = @"6f5b3b0e4ee45971";
static NSString * const kFlickrBaseURL = @"http://api.flickr.com/";

@implementation FlickrService

#pragma mark - Public

+ (FlickrService *)sharedClient {
    static FlickrService *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[FlickrService alloc] initWithBaseURL:[NSURL URLWithString:kFlickrBaseURL]];
    });
    
    return _sharedClient;
}

+ (void)photosGeolocated:(BOOL)geolocated withBlock:(void (^)(NSArray *photos))block {
    NSString *path = @"services/rest/";
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"method"] = @"flickr.photos.search";
    parameters[@"api_key"] = kFlickrKey;
    parameters[@"format"] = @"json";
    parameters[@"nojsoncallback"] = @"1";
    parameters[@"per_page"] = @"500";
    parameters[@"tags"] = @"party";
    
    if (geolocated) {
        parameters[@"lat"] = [NSString stringWithFormat:@"%f", [[LocationHoncho sharedInstance] latitude]];
        parameters[@"lon"] = [NSString stringWithFormat:@"%f", [[LocationHoncho sharedInstance] longitude]];
        parameters[@"radius"] = @"10";
    }

    
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

@end
