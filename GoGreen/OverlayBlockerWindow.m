//
//  OverlayBlockerWindow.m
//  GoGreen
//
//  Created by Steve Chan on 10/6/13.
//
//

#import "OverlayBlockerWindow.h"

@implementation OverlayBlockerWindow

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect
                          styleMask:NSBorderlessWindowMask
                            backing:bufferingType
                              defer:flag];
    if (self != nil) {
        [self setHasShadow:NO];
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor blackColor]];
        [self setAlphaValue:0.5];
        [self setLevel:NSScreenSaverWindowLevel+1];
        [self setFrame:[NSScreen mainScreen].frame display:NO];
        [self orderOut:nil];
    }
    return self;
}



@end
