#import <Foundation/Foundation.h>

@interface LocationHoncho : NSObject

@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;

+ (id)sharedInstance;
- (void)startLocating;

@end
