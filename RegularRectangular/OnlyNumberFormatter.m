//
//  OnlyNumberFormatter.m
//  RegularRectangular
//
//  Created by 王贺 on 14/10/21.
//  Copyright (c) 2014年 us.hector2. All rights reserved.
//

#import "OnlyNumberFormatter.h"

@implementation OnlyNumberFormatter

- (BOOL)isPartialStringValid:(NSString*)partialString newEditingString:(NSString**)newString errorDescription:(NSString**)error
{
    if([partialString length] == 0) {
        return YES;
    }
    
    NSScanner* scanner = [NSScanner scannerWithString:partialString];
    if(!([scanner scanInt:0] && [scanner isAtEnd])) {
        return NO;
    }
    
    return YES;
}

@end
