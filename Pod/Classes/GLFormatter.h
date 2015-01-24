//
//  GLDateFormatter.h
//  Pods
//
//  Created by LuHuiguo on 15/1/23.
//
//

#import <Foundation/Foundation.h>

@interface GLFormatter : NSNumberFormatter

@property (nonatomic, copy) NSArray *array;

- (id)initWithArray:(NSArray *)array;

@end
