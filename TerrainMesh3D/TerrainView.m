//
//  TerrainView.m
//  TerrainMesh3D
//
//  Created by Matt Reagan on 11/6/16.
//  Copyright © 2016 Matt Reagan. All rights reserved.
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the author be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source distribution.

#import "TerrainView.h"
#import "TerrainMesh.h"

@implementation TerrainView

- (void)mouseDown:(NSEvent *)event
{
    /*  For the demo, if camera control is on we allow the normal
        SCNView machinery to handle the event. If not, we apply
        the paint brush deformation below. */
    
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
    /*  For the demo, if camera control is on we allow the normal
        SCNView machinery to handle the event. If not, we apply
        the paint brush deformation below. */
    
    if (!self.allowsCameraControl)
    {
        [self applyDeformToMesh:event];
    }
    else
    {
        [super mouseDragged:event];
    }
}

#pragma mark - Terrain Paint Brush

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
                         intensity:.025 * ((event.modifierFlags & NSEventModifierFlagOption) ? -1.0 : 1.0)];
        }
    }
}

@end
