//
//  HoleView.m
//  RegularRectangular
//
//  Created by 王贺 on 14/10/20.
//  Copyright (c) 2014年 us.hector2. All rights reserved.
//

#import "HoleView.h"

@implementation HoleView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSRectFillUsingOperation(NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height), NSCompositeClear);
    // Drawing code here.
}
@end
