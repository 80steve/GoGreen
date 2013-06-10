//
//  AppDelegate.h
//  GoGreen
//
//  Created by Steve Chan on 9/6/13.
//
//

#import <Cocoa/Cocoa.h>
#import "Config.h"
#import "OverlayBlockerWindow.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSUserNotificationCenterDelegate> {
    @private int _counter;
    @private NSApplicationPresentationOptions _options;
    @private NSTimer *_timer;
    @private NSDictionary *_defaultMapping;
}


@property (nonatomic, strong) NSWindow *window;
@property (nonatomic, strong) NSStatusItem *statusBar;

@property (assign) IBOutlet NSMenu *statusMenu;

@end
