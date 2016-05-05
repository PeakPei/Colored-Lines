//
//  Score.h
//  Lines
//
//  Created by Admin on 26.01.15.
//  Copyright (c) 2015 Hrach. All rights reserved.
//

#import <Foundation/Foundation.h>
// shared object to store the score
@interface Score : NSObject

+(Score*) sharedScore;
@property NSInteger score;
@end
