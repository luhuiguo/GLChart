//
//  GLDateFormatter.m
//  Pods
//
//  Created by LuHuiguo on 15/1/23.
//
//

#import "GLFormatter.h"

@implementation GLFormatter

- (id)initWithArray:(NSArray *)array
{
    if ( (self = [super init]) ) {
        self.array = array;
    }
    return self;
}

-(NSString *)stringForObjectValue:(id)coordinateValue
{
    NSString *string = nil;
    
    if ( [coordinateValue respondsToSelector:@selector(intValue)] ) {
        
        int i = [coordinateValue intValue];
        if (i >=0 & i< [self.array count]){
            string = [self.array objectAtIndex:i];
        }
        
        
    }
    
    return string;
}

@end
