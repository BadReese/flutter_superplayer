//
//  FLTSuperPlayerView.m
//
//  Created by Lijy91 on 2020/9/4.
//

#import "FLTSuperPlayerView.h"

// FLTSuperPlayerViewController
@implementation FLTSuperPlayerViewController {
    UIView* _containerView;
    FLTSuperPlayerView* _superPlayerView;
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    FlutterEventChannel* _eventChannel;
    FlutterEventSink _eventSink;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if (self = [super init]) {
        _viewId = viewId;
        
        NSString* channelName = [NSString stringWithFormat:@"leanflutter.org/superplayer_view/channel_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        
        NSString* eventChannelName = [NSString stringWithFormat:@"leanflutter.org/superplayer_view/event_channel_%lld", viewId];
        _eventChannel = [FlutterEventChannel eventChannelWithName:eventChannelName
                                                  binaryMessenger:messenger];
        [_eventChannel setStreamHandler:self];
        
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            [weakSelf onMethodCall:call result:result];
        }];
        
        _containerView = [[UIView alloc] initWithFrame:frame];
        
        _superPlayerView = [[FLTSuperPlayerView alloc] init];
        _superPlayerView.fatherView = _containerView;
        _superPlayerView.delegate = self;
    }
    return self;
}

- (UIView*)view {
    return _containerView;
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    _eventSink = eventSink;
    
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    _eventSink = nil;
    
    return nil;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([[call method] isEqualToString:@"getPlayMode"]) {
        [self getPlayMode:call result: result];
    } else if ([[call method] isEqualToString:@"getPlayState"]) {
        [self getPlayState:call result: result];
    } else if ([[call method] isEqualToString:@"getPlayRate"]) {
        [self getPlayRate:call result: result];
    } else if ([[call method] isEqualToString:@"setPlayRate"]) {
        [self setPlayRate:call result: result];
    } else if ([[call method] isEqualToString:@"resetPlayer"]) {
        [self resetPlayer:call result: result];
    } else if ([[call method] isEqualToString:@"requestPlayMode"]) {
        [self requestPlayMode:call result: result];
    } else if ([[call method] isEqualToString:@"playWithModel"]) {
        [self playWithModel:call result: result];
    } else if ([[call method] isEqualToString:@"pause"]) {
        [self pause:call result: result];
    } else if ([[call method] isEqualToString:@"resume"]) {
        [self resume:call result: result];
    } else if ([[call method] isEqualToString:@"release"]) {
        [self release:call result: result];
    } else if ([[call method] isEqualToString:@"seekTo"]) {
        [self seekTo:call result: result];
    } else if ([[call method] isEqualToString:@"uiHideDanmu"]) {
        [self uiHideDanmu:call result: result];
    } else if ([[call method] isEqualToString:@"uiHideReplay"]) {
        [self uiHideReplay:call result: result];
    } else if ([[call method] isEqualToString:@"uiHideController"]) {
        [self uiHideController:call result: result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)getPlayMode:(FlutterMethodCall*)call
             result:(FlutterResult)result
{
    [_superPlayerView setPlayerConfig:nil];
}

- (void)getPlayState:(FlutterMethodCall*)call
              result:(FlutterResult)result
{
    result([NSNumber numberWithInt:_superPlayerView.state]);
}

- (void)getPlayRate:(FlutterMethodCall*)call
             result:(FlutterResult)result
{
    CGFloat playRate = [[_superPlayerView playerConfig] playRate];
    result([NSNumber numberWithDouble:playRate]);
}

- (void)setPlayRate:(FlutterMethodCall*)call
             result:(FlutterResult)result
{
    NSNumber *playRate = call.arguments[@"playRate"];
    [_superPlayerView setPlayRate:playRate.floatValue];
}

- (void)resetPlayer:(FlutterMethodCall*)call
             result:(FlutterResult)result
{
    [_superPlayerView resetPlayer];
}

- (void)requestPlayMode:(FlutterMethodCall*)call
                 result:(FlutterResult)result
{
    // skip
}


- (void)playWithModel:(FlutterMethodCall*)call
               result:(FlutterResult)result
{
    SuperPlayerModel *model = [[SuperPlayerModel alloc] init];
    
    NSNumber *appId = call.arguments[@"appId"];
    NSString *url = call.arguments[@"url"];
    if (appId)
        [model setAppId: appId.longValue];
    if (url)
        [model setVideoURL:url];
    
    NSDictionary *videoIdJson = call.arguments[@"videoId"];
    if (videoIdJson) {
        NSString *fileId = videoIdJson[@"fileId"];
        NSString *pSign = videoIdJson[@"pSign"];
        
        SuperPlayerVideoId *videoId = [[SuperPlayerVideoId alloc] init];
        if (fileId)
            [videoId setFileId:fileId];
        if (pSign) {
            [videoId setPsign:pSign];
        }
        [model setVideoId:videoId];
    }
    
    [_superPlayerView playWithModel:model];
}

- (void)pause:(FlutterMethodCall*)call
       result:(FlutterResult)result
{
    [_superPlayerView pause];
}

- (void)resume:(FlutterMethodCall*)call
        result:(FlutterResult)result
{
    [_superPlayerView resume];
}

- (void)release:(FlutterMethodCall*)call
         result:(FlutterResult)result
{
    // skip
}

- (void)seekTo:(FlutterMethodCall*)call
        result:(FlutterResult)result
{
    NSNumber *time = call.arguments[@"time"];
    [_superPlayerView seekToTime:time.intValue];
}

- (void) uiHideDanmu:(FlutterMethodCall*)call
        result:(FlutterResult)result
{
    [_superPlayerView uiHideDanmu];
}

- (void) uiHideReplay:(FlutterMethodCall*)call
        result:(FlutterResult)result
{
    [_superPlayerView uiHideReplay];
}

- (void) uiHideController:(FlutterMethodCall*)call
        result:(FlutterResult)result
{
    [_superPlayerView uiHideController];
}

/// 返回事件
- (void)superPlayerBackAction:(SuperPlayerView *)player {
    NSDictionary<NSString *, id> *eventData = @{
        @"listener": @"SuperPlayerListener",
        @"method": @"onClickSmallReturnBtn",
    };
    self->_eventSink(eventData);
}

/// 全屏改变通知
- (void)superPlayerFullScreenChanged:(SuperPlayerView *)player {
    NSDictionary<NSString *, id> *eventData = @{
        @"listener": @"SuperPlayerListener",
        @"method": @"onFullScreenChange",
        @"data": @{
                @"isFullScreen": [NSNumber numberWithBool:[player isFullScreen]],
        },
    };
    self->_eventSink(eventData);
}

/// 播放开始通知
- (void)superPlayerDidStart:(SuperPlayerView *)player {
    
}
/// 播放结束通知
- (void)superPlayerDidEnd:(SuperPlayerView *)player {
    
}
/// 播放错误通知
- (void)superPlayerError:(SuperPlayerView *)player errCode:(int)code errMessage:(NSString *)why {
    
}

/// 播放状态发生变化
- (void)onPlayStateChange:(int) playState {
    NSDictionary<NSString *, id> *eventData = @{
        @"listener": @"SuperPlayerListener",
        @"method": @"onPlayStateChange",
        @"data": @{
                @"playState": [NSNumber numberWithInt:playState],
        },
    };
    self->_eventSink(eventData);
}

/// 播放进度发生变化
- (void)onPlayProgressChange:(int) current duration:(int) duration {
    NSDictionary<NSString *, id> *eventData = @{
        @"listener": @"SuperPlayerListener",
        @"method": @"onPlayProgressChange",
        @"data": @{
                @"current": [NSNumber numberWithInt:current],
                @"duration": [NSNumber numberWithInt:duration],
        },
    };
    self->_eventSink(eventData);
}

@end

// FLTSuperPlayerViewFactory
@implementation FLTSuperPlayerViewFactory{
    NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    FLTSuperPlayerViewController* superPlayerViewController = [[FLTSuperPlayerViewController alloc] initWithFrame:frame
                                                                                                   viewIdentifier:viewId
                                                                                                        arguments:args
                                                                                                  binaryMessenger:_messenger];
    return superPlayerViewController;
}
@end

// FLTSuperPlayerView
@implementation FLTSuperPlayerView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
