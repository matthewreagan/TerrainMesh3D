//
//  TerrainMesh.h
//  3DTerrainThing
//
//  Created by Matt Reagan on 11/6/16.
//  Copyright © 2016 Matt Reagan. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface TerrainMesh : SCNNode

@property (nonatomic, readonly) int verticesPerSide;
@property (nonatomic, readonly) double sideLength;

+ (instancetype)terrainMeshWithResolution:(int)verticesPerSide
                               sideLength:(double)sideLength;

/** Applies a paint brush type deformation of the terrain mesh,
    
    @param point
    Relative X,Y location on the terrain mesh
    (x and y should be in the range of 0.0 - 1.0, where 0,0 is
    the "bottom left" of the mesh).
 
    @param brushRadius
    Size of the deformation */
- (void)derformTerrainAt:(CGPoint)point
             brushRadius:(double)brushRadius
               intensity:(double)intensity;

@end
