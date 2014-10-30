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
#import "ImageCaptureWindowController.h"

@interface AppDelegate (){
    ImageCaptureWindowController *imageCaptureController;
}
@property (weak) IBOutlet HoleView *holeView;

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self.window setBackgroundColor:[NSColor grayColor]];
    [self.window setOpaque:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object:self.window];
    
    
    
    imageCaptureController = [[ImageCaptureWindowController alloc] initWithWindowNibName:@"ImageCaptureWindowController"];
    imageCaptureController.mainWindow = self.window;
    imageCaptureController.holeView = self.holeView;
    [imageCaptureController showWindow:self];
    [self windowDidResize:nil];
}
-(void)windowDidResize:(NSNotification *)notification{
    [imageCaptureController.widthInput setStringValue:[NSString stringWithFormat:@"%.1f",self.holeView.frame.size.width]];
    [imageCaptureController.heightInput setStringValue:[NSString stringWithFormat:@"%.1f",self.holeView.frame.size.height]];
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}




@end
