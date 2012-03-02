//
//  NSThread+Blocks.m
//

#import "NSThread+Blocks.h"

@implementation NSThread (BlocksAdditions)

- (void)performBlock:(void (^)())block
{
	if ([[NSThread currentThread] isEqual:self])
		block();
	else
		[self performBlock:block waitUntilDone:NO];
}

- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait
{
    [NSThread performSelector:@selector(ng_runBlock:)
                     onThread:self
                   withObject:[block copy]
                waitUntilDone:wait];
}

+ (void)ng_runBlockPool:(void (^)())block
{
    @autoreleasepool {
        block();
    }
}

+ (void)ng_runBlock:(void (^)())block
{
    block();
}

+ (void)performBlockInBackground:(void (^)())block
{
	[NSThread performSelectorInBackground:@selector(ng_runBlockPool:)
	                           withObject:[block copy]];
}

@end
