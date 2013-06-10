//
//  AppDelegate.m
//  GoGreen
//
//  Created by Steve Chan on 9/6/13.
//
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize statusBar = _statusBar;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.window = [[OverlayBlockerWindow alloc] initWithContentRect:[NSScreen mainScreen].frame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

- (void)awakeFromNib
{
    [self initialSetup];
    
    self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusBar setTitle:@"S"];
    [self.statusBar setMenu:self.statusMenu];
    [self.statusBar setHighlightMode:YES];
}

- (void)initialSetup
{
    _defaultMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                       [NSNumber numberWithInt:1 * 60], [NSNumber numberWithInt:DefaultCountDownType15Min],
                       [NSNumber numberWithInt:30 * 60], [NSNumber numberWithInt:DefaultCountDownType30Min],
                       [NSNumber numberWithInt:1 * 60 * 60], [NSNumber numberWithInt:DefaultCountDownType1Hour],
                       [NSNumber numberWithInt:2 * 60 * 60], [NSNumber numberWithInt:DefaultCountDownType2Hour],
                       nil];
}

#pragma mark - Core

- (IBAction)configDefaultCountDown:(id)sender
{
    [self cancelCountDown];
    [self clearAllItemMarks];
    NSMenuItem *mItem = (NSMenuItem*)sender;
    [mItem setState:NSOnState];
    NSInteger tag = [mItem tag];
    for (int i = 0; i < DefaultCountDownTypeCount; i++) {
        if (tag == i) {
            [self countDownOfSeconds:[[_defaultMapping objectForKey:[NSNumber numberWithInteger:tag]] intValue]];
        }
    }
}

- (void)countDownOfSeconds:(int)seconds
{
    _counter = seconds;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)cancelCountDown
{
    if (_timer) [_timer invalidate];
}

- (void)updateTimer
{
    _counter -= 1;
    
    NSDateComponents *c = [[NSDateComponents alloc] init];
    [c setSecond:_counter];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *d = [cal dateFromComponents:c];
    
    NSDateComponents *result = [cal components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:d];
    [self.statusBar setTitle:[NSString stringWithFormat:@"%ld:%ld:%ld", [result hour], [result minute], [result second]]];
    
    if (_counter == 30) {
        [self triggerNotification];
    }
    
    if (_counter == 0) {
        [self timesUpCallback];
    }
}

- (void)clearAllItemMarks
{
    if ([self.statusMenu itemArray] > 0) {
        for (NSMenuItem *siblingMenuItem in [self.statusMenu itemArray]) {
            [siblingMenuItem setState:NSOffState];
        }
    }
}

#pragma mark - Custom Actions

- (void)blockScreen
{
    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:nil];
    _options = [NSApp presentationOptions];
    [NSApp setPresentationOptions:NSApplicationPresentationHideDock
     | NSApplicationPresentationDisableProcessSwitching
     | NSApplicationPresentationDisableHideApplication
     | NSApplicationPresentationDisableForceQuit];
    [self performSelector:@selector(unblockScreen) withObject:nil afterDelay:UNBLOCK_INTERVAL];
}

- (void)unblockScreen
{
    [self.window orderOut:nil];
    [NSApp setPresentationOptions:_options];
}

- (void)triggerNotification
{
    NSUserNotification *notifcation = [[NSUserNotification alloc] init];
    notifcation.title = @"Go Green!";
    notifcation.informativeText = @"Screen will be locked up in 30 seconds\r\nTime to go green, let your eyes rest abit!";
    notifcation.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notifcation];
}

#pragma mark - Callback

- (void)timesUpCallback
{
    [self cancelCountDown];
    [self.statusBar setTitle:@"S"];
    [self blockScreen];
}

#pragma mark - NSNotification Delegate

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

@end
