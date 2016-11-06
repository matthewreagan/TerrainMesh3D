//
//  TerrainMesh.h
//  TerrainMesh3D
//
//  Created by Matt Reagan on 11/6/16.
//  Copyright © 2016 Matt Reagan. All rights reserved.
//

#import <SceneKit/SceneKit.h>

/** TerrainMesh is a custom SCNNode which automatically generates
    a triangle mesh of an arbitrary resolution, which can then
    be deformed or manipulated. This can be used for rendering
    terrain or other custom shapes in SceneKit. The current
    API is relatively simple and is mostly for demonstration
    purposes, but could be easily extended as needed. */
@interface TerrainMesh : SCNNode

/** Creates a new terrain mesh node.
 
    @param verticesPerSide
    The number of vertices on each side of the mesh,
    this will determine the overall resolution and
    number of triangles of the mesh.
 
    @param sideLength
    The actual length of one side of the terrain. These
    units are arbitrary and only meaningful within the
    context of your particular scene. */
+ (instancetype)terrainMeshWithResolution:(int)verticesPerSide
                               sideLength:(double)sideLength;

/** Creates a new terrain mesh node with an optional vertex
    computation block.
 
    @param vertexComputationBlock
    Optional block that will be called when the terrain
    mesh is generated. The vertex location X,Y is passed
    in, and a custom z-depth can be returned (the effective
    "height" of that vertex in the terrain). This allows
    for easy customization of the terrain mapping.
 */
+ (instancetype)terrainMeshWithResolution:(int)verticesPerSide
                               sideLength:(double)sideLength
                             vertexHeight:(double (^)(int x, int y))vertexComputationBlock;

/** Applies a paintbrush-type deformation of the terrain mesh.
    Given a point on the terrain, a brush size, and a brush
    intensity, the terrain is raised or lowered.
    
    @param point
    Relative X,Y location on the terrain mesh
    (x and y should be in the range of 0.0 - 1.0, where 0,0 is
    the "bottom left" of the mesh).
 
    @param brushRadius
    Size of the deformation */
- (void)derformTerrainAt:(CGPoint)point
             brushRadius:(double)brushRadius
               intensity:(double)intensity;

@property (nonatomic, readonly) int verticesPerSide;
@property (nonatomic, readonly) double sideLength;

@end
