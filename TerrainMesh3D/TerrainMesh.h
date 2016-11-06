//
//  TerrainMesh.h
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
    Relative X,Y location on the terrain mesh. X and Y should
    be in the range of 0.0 - 1.0, where 0,0 is the lower range
    vertices, or "bottom left" of the mesh and 1.0,1.0 represents
    the highest vertices, or "top right" portion of the terrain.
 
    @param brushRadius
    Size of the deformation, this is a relative value, where
    0.5 is half the size of the mesh. Therefore, a brush at
    point 0.5, 0.5 (center of terrain) with a radius of 0.5
    would be a circle that was the same size as the entire
    terrain. */
- (void)derformTerrainAt:(CGPoint)point
             brushRadius:(double)brushRadius
               intensity:(double)intensity;

/** Vertices per side that the mesh was initialized with. */
@property (nonatomic, readonly) int verticesPerSide;

/** Actual length of the terrain, configured on initialization. */
@property (nonatomic, readonly) double sideLength;

@end
