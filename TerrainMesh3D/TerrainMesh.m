//
//  TerrainMesh.m
//  3DTerrainThing
//
//  Created by Matt Reagan on 11/6/16.
//  Copyright © 2016 Matt Reagan. All rights reserved.
//

#import "TerrainMesh.h"

@interface TerrainMesh ()

//Internal data structures

@property (nonatomic) SCNVector3 *positions;
@property (nonatomic) SCNVector3 *normals;
@property (nonatomic) int *indices;
@property (nonatomic) float *textureCoordinates;
@property (nonatomic, copy) double (^vertexHeightComputationBlock)(int x, int y);

@end

@implementation TerrainMesh

#pragma mark - Init / Factory Methods

+ (instancetype)terrainMeshWithResolution:(int)verticesPerSide
                               sideLength:(double)sideLength
{
    return [self terrainMeshWithResolution:verticesPerSide
                                sideLength:sideLength
                              vertexHeight:nil];
}

+ (instancetype)terrainMeshWithResolution:(int)verticesPerSide
                               sideLength:(double)sideLength
                             vertexHeight:(double (^)(int x, int y))vertexComputationBlock;
{
    TerrainMesh *mesh = [[TerrainMesh alloc] initWithResolution:verticesPerSide
                                                     sideLength:sideLength
                                                   vertexHeight:vertexComputationBlock];
    
    return mesh;
}

- (instancetype)initWithResolution:(int)verticesPerSide
                        sideLength:(double)sideLength
                      vertexHeight:(double (^)(int x, int y))vertexComputationBlock
{
    self = [super init];
    
    if (self)
    {
        NSAssert(verticesPerSide >= 2, @"Vertices per side must be at least 2.");
        
        _verticesPerSide = verticesPerSide;
        _sideLength = sideLength;
        _vertexHeightComputationBlock = [vertexComputationBlock copy];
        
        [self allocateDataBuffers];
        [self populateDataBuffersWithStartingValues];
        [self configureGeometry];
    }
    
    return self;
}

- (void)allocateDataBuffers
{
    if (_verticesPerSide)
    {
        NSInteger totalVertices = _verticesPerSide * _verticesPerSide;
        NSInteger squaresPerSide = (_verticesPerSide - 1);
        NSInteger totalSquares = squaresPerSide * squaresPerSide;
        NSInteger totalTriangles = totalSquares * 2;
        
        _positions = malloc(sizeof(SCNVector3) * totalVertices);
        _normals = malloc(sizeof(SCNVector3) * totalVertices);
        _indices = malloc(sizeof(int) * totalTriangles * 3);
        _textureCoordinates = malloc(sizeof(float) * totalVertices * 2);
    }
}

- (void)populateDataBuffersWithStartingValues
{
    NSAssert(_verticesPerSide > 0, @"Invalid mesh resolution.");
    
    int totalVertices = _verticesPerSide * _verticesPerSide;
    int squaresPerSide = (_verticesPerSide - 1);
    int totalSquares = squaresPerSide * squaresPerSide;
    int totalTriangles = totalSquares * 2;
    
    for (int i = 0; i < totalVertices; i++)
    {
        int ix = i % _verticesPerSide;
        int iy = i / _verticesPerSide;
        
        double ixf = ((double)ix / (double)(_verticesPerSide - 1));
        double iyf = ((double)iy / (double)(_verticesPerSide - 1));
        double x = ixf * _sideLength;
        double y = iyf * _sideLength;
        
        /*  Create vertices */

        double vertexZDepth = 0.0;
        
        if (_vertexHeightComputationBlock)
        {
            vertexZDepth = _vertexHeightComputationBlock(ix, iy);
        }
        
        _positions[i] = SCNVector3Make(x, y, vertexZDepth);
        
        /*  Create normals for each vertex */
        _normals[i] = SCNVector3Make(0, -1, 0);
        
        /*  Create texture coords (an X,Y pair for each vertex) */
        int ti = i * 2;
        _textureCoordinates[ti] = ixf;
        _textureCoordinates[ti+1] = iyf;
    }
    
    for (int i = 0; i < totalTriangles; i += 2)
    {
        /*  Define the triangles that make up the terrain mesh */
        int squareIndex = (i / 2);
        int squareX = squareIndex % squaresPerSide;
        int squareY = squareIndex / squaresPerSide;
        
        int vPerSide = (int)_verticesPerSide;
        int toprightIndex = ((squareY * vPerSide) + vPerSide) + squareX + 1;
        int topleftIndex = toprightIndex - 1;
        int bottomleftIndex = toprightIndex - vPerSide - 1;
        int bottomrightIndex = toprightIndex - vPerSide;
        
        int i1 = i * 3;
        
        _indices[i1] = toprightIndex;
        _indices[i1+1] = topleftIndex;
        _indices[i1+2] = bottomleftIndex;
        
        _indices[i1+3] = toprightIndex;
        _indices[i1+4] = bottomleftIndex;
        _indices[i1+5] = bottomrightIndex;
    }
}

#pragma mark - Private Configuration

- (void)configureGeometry
{
    NSAssert(_verticesPerSide > 0, @"Invalid mesh resolution.");
    
    NSArray *originalMaterials = self.geometry.materials;
    
    NSInteger totalVertices = _verticesPerSide * _verticesPerSide;
    NSInteger squaresPerSide = (_verticesPerSide - 1);
    NSInteger totalSquares = squaresPerSide * squaresPerSide;
    NSInteger totalTriangles = totalSquares * 2;

    NSMutableData *textureData = [NSMutableData dataWithBytes:_textureCoordinates length:totalVertices * sizeof(float) * 2];
    SCNGeometrySource *textureSource = [SCNGeometrySource geometrySourceWithData:textureData
                                                                        semantic:SCNGeometrySourceSemanticTexcoord
                                                                     vectorCount:totalVertices
                                                                 floatComponents:YES
                                                             componentsPerVector:2
                                                               bytesPerComponent:sizeof(float)
                                                                      dataOffset:0
                                                                      dataStride:sizeof(float) * 2];
    
    SCNGeometrySource *vertexSource =
    [SCNGeometrySource geometrySourceWithVertices:_positions count:totalVertices];
    
    SCNGeometrySource *normalSource =
    [SCNGeometrySource geometrySourceWithNormals:_normals count:totalVertices];
    
    NSData *indexData = [NSData dataWithBytes:_indices length:sizeof(int) * totalTriangles * 3];
    SCNGeometryElement *element = [SCNGeometryElement geometryElementWithData:indexData
                                                                primitiveType:SCNGeometryPrimitiveTypeTriangles
                                                               primitiveCount:totalTriangles
                                                                bytesPerIndex:sizeof(int)];
    
    SCNGeometry *geometry = [SCNGeometry geometryWithSources:@[vertexSource, normalSource, textureSource] elements:@[element]];
    geometry.materials = originalMaterials;
    
    self.geometry = geometry;
}

#pragma mark - Deforming Terrain

- (void)derformTerrainAt:(CGPoint)point
             brushRadius:(double)brushRadius
               intensity:(double)intensity
{
    double radiusInIndices = brushRadius * (double)_verticesPerSide;
    double vx = ((double)_verticesPerSide * point.x);
    double vy = ((double)_verticesPerSide * point.y);
    
    for (int y = 0; y < _verticesPerSide; y++)
    {
        for (int x = 0; x < _verticesPerSide; x++)
        {
            double xDelta = (vx - x);
            double yDelta = (vy - y);
            double dist = sqrt((xDelta * xDelta) + (yDelta * yDelta));
            
            if (dist < radiusInIndices)
            {
                int index = (y * _verticesPerSide) + x;
                
                double relativeIntensity = (1.0 - (dist / radiusInIndices));
                
                relativeIntensity = sin(relativeIntensity * M_PI_2);
                relativeIntensity *= intensity;
                
                _positions[index].z += relativeIntensity;
            }
        }
    }
    
    [self configureGeometry];
}

@end
