//
//  ImageCaptureWindowController.m
//  RegularRectangular
//
//  Created by 王贺 on 14/10/30.
//  Copyright (c) 2014年 us.hector2. All rights reserved.
//

#import "ImageCaptureWindowController.h"
#import "OnlyNumberFormatter.h"
#pragma mark Basic Profiling Tools
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
@interface ImageCaptureWindowController (){
    NSColor *currentColor;
}
@property (nonatomic)NSDateFormatter *dateFormatter;
@end

@implementation ImageCaptureWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    OnlyNumberFormatter *formatter = [[OnlyNumberFormatter alloc] init];
    _widthInput.delegate = self;
    [_widthInput setFormatter:formatter];
    _heightInput.delegate = self;
    [_heightInput setFormatter:formatter];
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"/yyyy_MM_dd_HH_mm_SS_ss"];
    [self.window makeFirstResponder:self];
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^(NSEvent *event){
        [self takeColor];
    }];
    [NSEvent addLocalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^NSEvent *(NSEvent *event) {
        [self takeColor];
        return event;
    }];
}
-(void)mouseMoved:(NSEvent *)theEvent{
    
}
- (void)takeColor {
    NSPoint where = CGPointMake((int)[NSEvent mouseLocation].x,800-(int)[NSEvent mouseLocation].y);
    CGDirectDisplayID did = [[self.window.screen.deviceDescription objectForKey:@"NSScreenNumber"] intValue];
    CGImageRef image = CGDisplayCreateImageForRect(did,
                                                   CGRectMake(where.x, where.y, 1, 1));
    NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithCGImage:image];
    CGImageRelease(image);
    NSColor *color = [bitmap colorAtX:0 y:0];
    
    self.colorCube.color = color;
    currentColor = color;
}

-(void)keyDown:(NSEvent *)theEvent{
    if (theEvent.keyCode == 49) {
        NSString* hexString = [NSString stringWithFormat:@"0x%02X%02X%02X",
                               (int) (currentColor.redComponent * 0xFF), (int) (currentColor.greenComponent * 0xFF),
                               (int) (currentColor.blueComponent * 0xFF)];
        [self.hexCode setStringValue:hexString];
        NSString *objectiveCCodeMacString = [NSString stringWithFormat:@"[NSColor colorWithRed:%.2f green:%.2f blue:%.2f alpha:1.0]",currentColor.redComponent,currentColor.greenComponent,currentColor.blueComponent];
        NSString *objectiveCCodeIOSString = [NSString stringWithFormat:@"[UIColor colorWithRed:%.2f green:%.2f blue:%.2f alpha:1]",currentColor.redComponent,currentColor.greenComponent,currentColor.blueComponent];
        NSString *swiftCodeString = [NSString stringWithFormat:@"UIColor(red: %.2f, green: %.2f, blue: %.2f, alpha: 1.0)",currentColor.redComponent,currentColor.greenComponent,currentColor.blueComponent];
        [self.objectiveCCode setString:objectiveCCodeMacString];
        [self.objectiveCCodeIOS setString:objectiveCCodeIOSString];
        [self.swiftCode setString:swiftCodeString];
    }
}

-(BOOL)acceptsFirstResponder
{
    return YES;
}
- (BOOL)canBecomeKeyView
{
    return  YES;
}
- (IBAction)doResize:(id)sender {
    NSRect theRect = self.mainWindow.frame;
    theRect.size.width = [_widthInput floatValue] + 2;
    theRect.size.height = [_heightInput floatValue] + 23;
    [self.mainWindow setFrame:theRect display:YES];
}
-(CGImageRef)createScreenShot
{
    StopwatchStart();
    CGRect windowsCGRect = NSRectToCGRect(self.mainWindow.frame);
    CGRect holeViewCGRect = NSRectToCGRect(self.holeView.frame);
    CGRect fullscreenRect = self.mainWindow.screen.frame;
    float yWin = fullscreenRect.size.height - windowsCGRect.origin.y - windowsCGRect.size.height;
    float yHole = windowsCGRect.size.height - holeViewCGRect.origin.y - holeViewCGRect.size.height;
    CGRect rectToShot = CGRectMake(windowsCGRect.origin.x + holeViewCGRect.origin.x,
                                   yWin+yHole, holeViewCGRect.size.width, holeViewCGRect.size.height);
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
}

@end
