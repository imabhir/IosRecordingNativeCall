/****************************************************************************
 Copyright (c) 2010-2013 cocos2d-x.org
 Copyright (c) 2013-2016 Chukong Technologies Inc.
 Copyright (c) 2017-2022 Xiamen Yaji Software Co., Ltd.

 http://www.cocos.com

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated engine source code (the "Software"), a limited,
 worldwide, royalty-free, non-assignable, revocable and non-exclusive license
 to use Cocos Creator solely to develop games on your target platforms. You shall
 not use Cocos Creator software for developing other software or tools that's
 used for developing games. You are not granted to publish, distribute,
 sublicense, and/or sell copies of Cocos Creator.

 The software or tools in this License Agreement are licensed, not sold.
 Xiamen Yaji Software Co., Ltd. reserves all rights not expressly granted to you.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
****************************************************************************/

#import "AppDelegate.h"
#import "ViewController.h"
#import "View.h"
#import <AVFoundation/AVFoundation.h>
#include "platform/ios/IOSPlatform.h"
#import "platform/ios/AppDelegateBridge.h"
#import "service/SDKWrapper.h"
#import <Foundation/Foundation.h>

@implementation AppDelegate
@synthesize window;
@synthesize appDelegateBridge;
#pragma mark -
#pragma mark Application lifecycle
//NSString *globalPathToSave= @"globalPathToSave";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[SDKWrapper shared] application:application didFinishLaunchingWithOptions:launchOptions];
    appDelegateBridge = [[AppDelegateBridge alloc] init];
    
    // Add the view controller's view to the window and display.
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.window   = [[UIWindow alloc] initWithFrame:bounds];

    // Should create view controller first, cc::Application will use it.
    _viewController                           = [[ViewController alloc] init];
    _viewController.view                      = [[View alloc] initWithFrame:bounds];
    _viewController.view.contentScaleFactor   = UIScreen.mainScreen.scale;
    _viewController.view.multipleTouchEnabled = true;
    [self.window setRootViewController:_viewController];

    [self.window makeKeyAndVisible];
    [appDelegateBridge application:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [[SDKWrapper shared] applicationWillResignActive:application];
    [appDelegateBridge applicationWillResignActive:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [[SDKWrapper shared] applicationDidBecomeActive:application];
    [appDelegateBridge applicationDidBecomeActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [[SDKWrapper shared] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    [[SDKWrapper shared] applicationWillEnterForeground:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[SDKWrapper shared] applicationWillTerminate:application];
    [appDelegateBridge applicationWillTerminate:application];
}


//@description audio recorder code



AVAudioRecorder * recorder;
+(BOOL)callNativeUI:(NSString *) title andContent:(NSString *)content{
    NSLog(@"Recording Stopped");
    [recorder pause];
    [recorder stop];
//    NSString *pathToSave=globalPathToSave;
//    NSLog(@"%@",globalPathToSave);
//    return pathToSave;
}

+(NSString *)callNativeUIWithTitle:(NSString *) title andContent:(NSString *)content{
    

    NSLog(@"Recording Started");
    NSLog(@"Recording Start function call");
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];

      [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

      [audioSession setActive:YES error:nil];

      NSError *error;

      // Recording settings
      NSMutableDictionary *settings = [NSMutableDictionary dictionary];

      [settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
      [settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
      [settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
      [settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
      [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
      [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
      [settings setValue:  [NSNumber numberWithInt: AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];

      NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
      NSString *documentPath_ = [searchPaths objectAtIndex: 0];

      NSString *pathToSave = [documentPath_ stringByAppendingPathComponent:@"StoryRecord.wav"];
    
      NSLog(@"%@",pathToSave);
      // File URL
      NSURL *url = [NSURL fileURLWithPath:pathToSave];//FILEPATH];
//      globalPathToSave=pathToSave;
      //Save recording path to preferences
      NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
      [prefs setURL:url forKey:@"Test1"];
      [prefs synchronize];
      // Create recorder
      recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
      [recorder prepareToRecord];

      [recorder record];
   
//    NSError *error;
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    NSLog(@"check1");
//    if (![session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
//    {
//        NSLog(@"Error setting session category: %@", error.localizedFailureReason);
//        return NO;
//    }
//
//    NSLog(@"check2");
//    if (![session setActive:YES error:&error])
//    {
//        NSLog(@"Error activating audio session: %@", error.localizedFailureReason);
//        return NO;
//    }
//    NSLog(@"check3");
//
//
//    // Recording settings
//    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
//    NSLog(@"check4");
//    [settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
//    [settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
//    [settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
//    [settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
//    [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
//    [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
//    [settings setValue:  [NSNumber numberWithInt: AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
//    NSLog(@"check5");
//     NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentPath_ = [searchPaths objectAtIndex: 0];
//
//    NSString *pathToSave = [documentPath_ stringByAppendingPathComponent:@"StoryRecord.aif"];
//    NSLog(@"check6");
//    // File URL
//    NSURL *url = [NSURL fileURLWithPath:pathToSave];//FILEPATH];
//    NSLog(@"%@", [NSString stringWithFormat:@"%@", url]);
//    // Create recorder
//    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
//    if (!recorder)
//    {
//        NSLog(@"Error establishing recorder: %@", error.localizedFailureReason);
//        return NO;
//    }
//    NSLog(@"check7");
//    // Initialize degate, metering, etc.
//    recorder.delegate = (id)self;
//    recorder.meteringEnabled = YES;
//    //self.title = @"0:00";
//    NSLog(@"check8");
//    if (![recorder prepareToRecord])
//    {
//        NSLog(@"Error: Prepare to record failed");
//        //[self say:@"Error while preparing recording"];
//        return NO;
//    }
//    NSLog(@"check9");
//    if (![recorder record])
//    {
//        NSLog(@"Error: Record failed");
//    //  [self say:@"Error while attempting to record audio"];
//        return NO;
//    }
//
//    // Set a timer to monitor levels, current time
//    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];

    //return YES;
    
  return pathToSave;
}


- (NSString *) dateString
{
// return a formatted string for a file name
NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
formatter.dateFormat = @"ddMMMYY_hhmmssa";
return [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".aif"];
}
#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[SDKWrapper shared] applicationDidReceiveMemoryWarning:application];
}
@end
//@interface NativeOcClass : NSObject
////+(BOOL)callNativeUIWithTitle:(NSString *)title andContent:(NSString *)content;
//- (BOOL) record;
//@end
//#import <AVFoundation/AVFoundation.h>
//#import "AppDelegate.h"
//@implementation NativeOcClass
//AVAudioRecorder * recorder;
//+(BOOL)callNativeUI:(NSString *) title andContent:(NSString *)content{
//    NSLog(@"Recording Stopped");
//    [recorder pause];
//    [recorder stop];
//}
//
//
//+(BOOL)callNativeUIWithTitle:(NSString *) title andContent:(NSString *)content{
//    NSLog(@"Recording Started");
//
//    NSError *error;
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//
//    if (![session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
//    {
//        NSLog(@"Error setting session category: %@", error.localizedFailureReason);
//        return NO;
//    }
//
//
//    if (![session setActive:YES error:&error])
//    {
//        NSLog(@"Error activating audio session: %@", error.localizedFailureReason);
//        return NO;
//    }
//
//
//
//    // Recording settings
//    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
//
//    [settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
//    [settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
//    [settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
//    [settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
//    [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
//    [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
//    [settings setValue:  [NSNumber numberWithInt: AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
//
//     NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentPath_ = [searchPaths objectAtIndex: 0];
//
//    NSString *pathToSave = [documentPath_ stringByAppendingPathComponent:@"Recording.aif"];
//
//    // File URL
//    NSURL *url = [NSURL fileURLWithPath:pathToSave];//FILEPATH];
//    NSLog(@"%@", [NSString stringWithFormat:@"%@", url]);
//    // Create recorder
//    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
//    if (!recorder)
//    {
//        NSLog(@"Error establishing recorder: %@", error.localizedFailureReason);
//        return NO;
//    }
//
//    // Initialize degate, metering, etc.
//    recorder.delegate = (id)self;
//    recorder.meteringEnabled = YES;
//    //self.title = @"0:00";
//
//    if (![recorder prepareToRecord])
//    {
//        NSLog(@"Error: Prepare to record failed");
//        //[self say:@"Error while preparing recording"];
//        return NO;
//    }
//
//    if (![recorder record])
//    {
//        NSLog(@"Error: Record failed");
//    //  [self say:@"Error while attempting to record audio"];
//        return NO;
//    }
//
//    // Set a timer to monitor levels, current time
//    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
//
//    //return YES;
//
//  return true;
//}
//
//
//- (NSString *) dateString
//{
//// return a formatted string for a file name
//NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//formatter.dateFormat = @"ddMMMYY_hhmmssa";
//return [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".aif"];
//}

 //---------------SETUP AUDIO SESSION--------------------//


//- (void) startAudioSession
//{
//// Prepare the audio session
//NSError *error;
//AVAudioSession *session = [AVAudioSession sharedInstance];
//
//if (![session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
//{
//    NSLog(@"Error setting session category: %@", error.localizedFailureReason);
//    return NO;
//}
//
//
//if (![session setActive:YES error:&error])
//{
//    NSLog(@"Error activating audio session: %@", error.localizedFailureReason);
//    return NO;
//}
//
//    return session.isInputAvailable;
//}

//----------------RECORD SOUND----------------------------//
//- (BOOL) record:(NSString *) title
//{
//    [self startAudioSession];
//
//}
//NSError *error;
//
//// Recording settings
//NSMutableDictionary *settings = [NSMutableDictionary dictionary];
//
//[settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
//[settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
//[settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
//[settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
//[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
//[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
//[settings setValue:  [NSNumber numberWithInt: AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
//
// NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//NSString *documentPath_ = [searchPaths objectAtIndex: 0];
//
//NSString *pathToSave = [documentPath_ stringByAppendingPathComponent:[self dateString]];
//
//// File URL
//NSURL *url = [NSURL fileURLWithPath:pathToSave];//FILEPATH];
//
//// Create recorder
//recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
//if (!recorder)
//{
//    NSLog(@"Error establishing recorder: %@", error.localizedFailureReason);
//    return NO;
//}
//
//// Initialize degate, metering, etc.
//recorder.delegate = self;
//recorder.meteringEnabled = YES;
////self.title = @"0:00";
//
//if (![recorder prepareToRecord])
//{
//    NSLog(@"Error: Prepare to record failed");
//    //[self say:@"Error while preparing recording"];
//    return NO;
//}
//
//if (![recorder record])
//{
//    NSLog(@"Error: Record failed");
////  [self say:@"Error while attempting to record audio"];
//    return NO;
//}
//
//// Set a timer to monitor levels, current time
//NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
//
////return YES;
//}

//-------------- STOP RECORDING---------------------//
//- (void) stopRecording
//{
//// This causes the didFinishRecording delegate method to fire
//  [recorder stop];
//}
//@end




//-----------------Play sound...Retrieve From document directiory----------//
//-(void)play
//{
//
// NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//NSString *documentPath_ = [searchPaths objectAtIndex: 0];
//
// NSFileManager *fileManager = [NSFileManager defaultManager];
//
//if ([fileManager fileExistsAtPath:[self recordingFolder]])
//    {
//
//    arrayListOfRecordSound=[[NSMutableArray alloc]initWithArray:[fileManager  contentsOfDirectoryAtPath:documentPath_ error:nil]];
//
//    NSLog(@"====%@",arrayListOfRecordSound);
//
//}
//
//   NSString  *selectedSound =  [documentPath_ stringByAppendingPathComponent:[arrayListOfRecordSound objectAtIndex:0]];
//
//    NSURL   *url =[NSURL fileURLWithPath:selectedSound];
//
//     //Start playback
//   player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//
//   if (!player)
//   {
//     NSLog(@"Error establishing player for %@: %@", recorder.url, error.localizedFailureReason);
//     return;
//    }
//
//    player.delegate = self;
//
//    // Change audio session for playback
//    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error])
//    {
//        NSLog(@"Error updating audio session: %@", error.localizedFailureReason);
//        return;
//    }
//
//    self.title = @"Playing back recording...";
//
//    [player prepareToPlay];
//    [player play];
//
//
//}
//


