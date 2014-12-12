

#import "ImageCacheObject.h"

@implementation ImageCacheObject

@synthesize size;
@synthesize timeStamp;
@synthesize image;

-(id)initWithSize:(NSUInteger)sz Image:(UIImage*)anImage{
    if (self = [super init]) {
        size = sz;
        timeStamp = [[NSDate date] copy];
        image = [anImage copy];
    }
    return self;
}

-(void)resetTimeStamp {
    //[timeStamp release];
    timeStamp = [[NSDate date] copy];
}

/*-(void) dealloc {
    [timeStamp release];
    [image release];
    [super dealloc];
}*/

@end
