//
//  TerrainMesh.h
//  3DTerrainThing
//
//  Created by Matt Reagan on 11/6/16.
//  Copyright © 2016 Matt Reagan. All rights reserved.
//

#import <SceneKit/SceneKit.h>

@interface TerrainMesh : SCNNode

+ (instancetype)terrainMeshWithResolution:(int)verticesPerSide
                               sideLength:(double)sideLength;

- (void)derformTerrainAt:(CGPoint)point
             brushRadius:(double)brushRadius
               intensity:(double)intensity;

@end
