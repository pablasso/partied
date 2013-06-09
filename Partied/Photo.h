#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic, strong) NSString *photoURL;

+ (void)photosGeolocated:(BOOL)geolocated withBlock:(void (^)(NSArray *photos))block;


@end
