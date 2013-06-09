// smarter logs, by marcus zarra
#ifdef DEBUG
#define DLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
#else
#define DLog(...) do { } while (0)
#ifndef NS_BLOCK_ASSERTIONS
#define NS_BLOCK_ASSERTIONS
#endif
#define ALog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#endif

// sane nil and empty checks, by wil shipley
static inline BOOL IsEmpty(id thing) {
    return thing == nil || thing == [NSNull null]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

// safe object descriptions, by pablasso
static inline NSString * SafeDesc(id thing) {
    if (thing == nil || thing == [NSNull null]) {
        return @"<nil>";
    }
    return [NSString stringWithFormat:@"%@", thing];
}