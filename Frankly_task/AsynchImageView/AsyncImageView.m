
#import "AsyncImageView.h"
#import "ImageCacheObject.h"
#import "ImageCache.h"

//
// Key's are URL strings.
// Value's are ImageCacheObject's
//
static ImageCache *imageCache = nil;

@implementation AsyncImageView
@synthesize x, y,data;

- (id)initWithFrame:(CGRect)frame {
     self = [super initWithFrame:frame];
//    if (self == [super initWithFrame:frame]) {
//    }
    if (self) {
        
    }
     return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
	//[urlString release];
    [connection cancel];
   // [connection release];
   // [data release];
//    if (imageCache) {
//        [imageCache release];imageCache = nil;
//    }
   // [super dealloc];
}

-(void)loadImageFromURL:(NSURL*)url {
    if (connection != nil) {
        [connection cancel];
       // [connection release];
        connection = nil;
    }
    if (data != nil) {
      //  [data release];
        data = nil;
    }
    
    if (imageCache == nil) // lazily create image cache
//    if (imageCache !=nil) {
//        [imageCache release];imageCache = nil;
//    }
    imageCache = [[ImageCache alloc] initWithMaxSize:2*1024*1024];  // 2 MB Image cache
    
    //[urlString release];
    urlString = nil;
    urlString = [[url absoluteString] copy];
    UIImage *cachedImage = [imageCache imageForKey:urlString];
    if (cachedImage != nil) {
        if ([[self subviews] count] > 0) {
            [[[self subviews] objectAtIndex:0] removeFromSuperview];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:cachedImage];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = 
            UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:imageView];
        imageView.frame = self.bounds;
        [imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
        [self setNeedsLayout];
        return;
    }
    
#define SPINNY_TAG 5555   
    
//    UIActivityIndicatorView *spinny = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    spinny.tag = SPINNY_TAG;
//	[spinny setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
//    spinny.center =CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2); //self.center;
//    [spinny startAnimating];
//    [self addSubview:spinny];
//    [spinny release];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url 
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                         timeoutInterval:60.0];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)loadImageFromImage:(UIImage*)image {
    if (connection != nil) {
        [connection cancel];
        //[connection release];
        connection = nil;
    }
    if (data != nil) {
        //[data release];
        data = nil;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image] ;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = 
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:imageView];
    imageView.frame = self.bounds;
    [imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
    [self setNeedsLayout];
    return;
}
- (void)connection:(NSURLConnection *)connection 
    didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    //[connection release];
    connection = nil;
    
    UIView *spinny = [self viewWithTag:SPINNY_TAG];
    [spinny removeFromSuperview];
    NSArray *subViewArray = [self subviews];
    if (subViewArray) {
        if ([[self subviews] count] > 0) {
            [[[self subviews] objectAtIndex:0] removeFromSuperview];
        }
    }
    
    
    UIImage *image = [UIImage imageWithData:data];
    
    [imageCache insertImage:image withSize:[data length] forKey:urlString];
    
    UIImageView *imageView = [[UIImageView alloc] 
                               initWithImage:image] ;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = 
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:imageView];
    imageView.frame = self.bounds;
    [imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
    [self setNeedsLayout];
    //[data release];
    data = nil;
}

@end
