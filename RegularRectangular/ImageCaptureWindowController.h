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

@property (strong) IBOutlet NSPanel *floatingWindow;
@property (weak) IBOutlet NSTextField *colorLabel;
@property (weak) IBOutlet NSColorWell *colorCube;
@property (unsafe_unretained) IBOutlet NSTextView *objectiveCCode;

@property (unsafe_unretained) IBOutlet NSTextView *swiftCode;

@property (weak) IBOutlet NSTextField *hexCode;

@property (unsafe_unretained) IBOutlet NSTextView *objectiveCCodeIOS;




- (IBAction)startCapture:(id)sender;
@end
