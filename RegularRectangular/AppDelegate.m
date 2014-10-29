//
//  AppDelegate.m
//  RegularRectangular
//
//  Created by 王贺 on 14/10/20.
//  Copyright (c) 2014年 us.hector2. All rights reserved.
//

#import "AppDelegate.h"
#import "HoleView.h"
#import "OnlyNumberFormatter.h"
#import "ImageCaptureWindow.h"
#import "ImageCapturerController.h"
#pragma mark Basic Profiling Tools
// Set to 1 to enable basic profiling. Profiling information is logged to console.
#ifndef PROFILE_WINDOW_GRAB
#define PROFILE_WINDOW_GRAB 0
#endif

#if PROFILE_WINDOW_GRAB
#define StopwatchStart() AbsoluteTime start = UpTime()
#define Profile(img) CFRelease(CGDataProviderCopyData(CGImageGetDataProvider(img)))
#define StopwatchEnd(caption) do { Duration time = AbsoluteDeltaToDuration(UpTime(), start); double timef = time < 0 ? time / -1000000.0 : time / 1000.0; NSLog(@"%s Time Taken: %f seconds", caption, timef); } while(0)
#else
#define StopwatchStart()
#define Profile(img)
#define StopwatchEnd(caption)
#endif
@interface AppDelegate ()
@property (weak) IBOutlet NSTextField *widthInput;
@property (weak) IBOutlet NSTextField *heightInput;
@property (weak) IBOutlet HoleView *holeView;

@property (weak) IBOutlet NSWindow *window;


@property (nonatomic)NSDateFormatter *dateFormatter;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self.window setBackgroundColor:[NSColor grayColor]];
    [self.window setOpaque:NO];
    [self windowDidResize:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object:self.window];
    OnlyNumberFormatter *formatter = [[OnlyNumberFormatter alloc] init];
    _widthInput.delegate = self;
    [_widthInput setFormatter:formatter];
    _heightInput.delegate = self;
    [_heightInput setFormatter:formatter];
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"/yyyy_MM_dd_HH_mm_SS_ss"];
    
}
- (IBAction)doResize:(id)sender {
    NSRect theRect = self.window.frame;
    theRect.size.width = [_widthInput floatValue];
    theRect.size.height = [_heightInput floatValue] + 86 + 22;
    [self.window setFrame:theRect display:YES];
}
- (void)controlTextDidChange:(NSNotification *)notification {
    
}
-(void)windowDidResize:(NSNotification *)notification{
    [self.widthInput setStringValue:[NSString stringWithFormat:@"%.1f",self.holeView.frame.size.width]];
    [self.heightInput setStringValue:[NSString stringWithFormat:@"%.1f",self.holeView.frame.size.height]];
    NSLog(@"%f",self.holeView.frame.size.width);
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(CGImageRef)createScreenShot
{
    // This just invokes the API as you would if you wanted to grab a screen shot. The equivalent using the UI would be to
    // enable all windows, turn off "Fit Image Tightly", and then select all windows in the list.
    StopwatchStart();
    CGRect windowsCGRect = NSRectToCGRect(self.window.frame);
    CGRect holeViewCGRect = NSRectToCGRect(self.holeView.frame);
    CGRect fullscreenRect = self.window.screen.frame;
    float yWin = fullscreenRect.size.height - windowsCGRect.origin.y - windowsCGRect.size.height;
    float yHole = windowsCGRect.size.height - holeViewCGRect.origin.y - holeViewCGRect.size.height;
    CGRect rectToShot = CGRectMake(windowsCGRect.origin.x + holeViewCGRect.origin.x,
                                    yWin+yHole, holeViewCGRect.size.width, holeViewCGRect.size.height);
    NSLog(@"%f %f",rectToShot.origin.x,rectToShot.origin.y);
    
    CGImageRef screenShot = CGWindowListCreateImage(rectToShot, kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageDefault);
    Profile(screenShot);
    StopwatchEnd("Screenshot");
    return screenShot;
}

- (IBAction)startCapture:(id)sender {
    NSBitmapImageRep *bitmapRep = [[NSBitmapImageRep alloc] initWithCGImage:[self createScreenShot]];
    NSData *data = [bitmapRep representationUsingType: NSPNGFileType properties: nil];
    NSArray * paths = NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES);
    NSString * desktopPath = [paths objectAtIndex:0];
    desktopPath = [NSString stringWithFormat:@"%@%@%@",desktopPath,[_dateFormatter stringFromDate:[NSDate date]],@".png"];
    [data writeToFile: desktopPath atomically: NO];
    
    
    ImageCapturerController *imageCaptureController = [[ImageCapturerController alloc] initWithWindowNibName:@"ImageCaptureWindow"];
    [imageCaptureController showWindow:self];
}


@end
