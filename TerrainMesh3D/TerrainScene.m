//
//  TerrainScene.m
//  3DTerrainThing
//
//  Created by Matt Reagan on 11/5/16.
//  Copyright © 2016 Matt Reagan. All rights reserved.
//

#import "TerrainScene.h"

@implementation TerrainScene

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.background.contents = [NSImage imageNamed:@"sky2"];
    }
    
    return self;
}

@end
