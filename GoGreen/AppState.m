//
//  AppState.m
//  GoGreen
//
//  Created by Steve Chan on 9/6/13.
//
//

#import "AppState.h"

@implementation AppState

+ (id)sharedState {
    static AppState *_sharedState = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedState = [[self alloc] init];
    });
    
    return _sharedState;
}

- (id)init {
    if (self = [super init]) {
    }
    
    return self;
}

@end
