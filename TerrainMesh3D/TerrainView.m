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

    if (self.allowsCameraControl) {
        [super mouseDown:event];
    } else {
        [self applyDeformToMesh:event];
    }
}

- (void)mouseDragged:(NSEvent *)event
{
    /*  For the demo, if camera control is on we allow the normal
        SCNView machinery to handle the event. If not, we apply
        the paint brush deformation below. */

    if (self.allowsCameraControl) {
        [super mouseDragged:event];
    } else {
        [self applyDeformToMesh:event];
    }
}

#pragma mark - Terrain Paint Brush

- (void)applyDeformToMesh:(NSEvent *)event {
    NSPoint point = [self convertPoint:event.locationInWindow fromView:nil];
    double intensity = (event.modifierFlags & NSEventModifierFlagOption) ? -0.025 : 0.025;

    for (SCNHitTestResult *result in [self hitTest:point options:nil]) {
        if ([result.node isKindOfClass:[TerrainMesh class]]) {
            TerrainMesh *mesh = (TerrainMesh *) result.node;
            double meshSize = mesh.sideLength;

            CGPoint relativeLocation = CGPointMake(result.localCoordinates.x / meshSize,
                                                   result.localCoordinates.y / meshSize);
            [mesh derformTerrainAt:relativeLocation
                       brushRadius:0.25
                         intensity:intensity];
        }
    }
}

@end
