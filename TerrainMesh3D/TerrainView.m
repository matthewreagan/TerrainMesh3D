//
//  TerrainView.m
//  TerrainMesh3D
//
//  Created by Matt Reagan on 11/6/16.
//  Copyright © 2016 Matt Reagan. All rights reserved.
//

#import "TerrainView.h"
#import "TerrainMesh.h"

@implementation TerrainView

- (void)mouseDown:(NSEvent *)event
{
    if (!self.allowsCameraControl)
    {
        [self applyDeformToMesh:event];
    }
    else
    {
        [super mouseDown:event];
    }
}

- (void)mouseDragged:(NSEvent *)event
{
    if (!self.allowsCameraControl)
    {
        [self applyDeformToMesh:event];
    }
    else
    {
        [super mouseDragged:event];
    }
}

- (void)applyDeformToMesh:(NSEvent *)event
{
    NSPoint point = event.locationInWindow;
    point = [self convertPoint:point fromView:nil];
    
    NSArray *hitResults = [self hitTest:point options:nil];
    
    for (SCNHitTestResult *result in hitResults)
    {
        id node = result.node;
        
        if ([node isKindOfClass:[TerrainMesh class]])
        {
            TerrainMesh *mesh = node;
            double meshSize = mesh.sideLength;
            
            CGPoint relativeLocation = CGPointMake(result.localCoordinates.x / meshSize,
                                                   result.localCoordinates.y / meshSize);
            [mesh derformTerrainAt:relativeLocation
                       brushRadius:0.25
                         intensity:.025];
        }
    }
}

@end
