//
//  ImageCaptureWindowController.h
//  RegularRectangular
//
//  Created by 王贺 on 14/10/30.
//  Copyright (c) 2014年 us.hector2. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
#import "HoleView.h"
@interface ImageCaptureWindowController : NSWindowController<NSTextFieldDelegate>
@property (nonatomic) NSWindow *mainWindow;
@property (nonatomic) HoleView *holeView;
@property (weak) IBOutlet NSTextField *widthInput;
@property (weak) IBOutlet NSTextField *heightInput;
- (IBAction)startCapture:(id)sender;
@end
