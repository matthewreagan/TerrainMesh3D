//
//  TerrainMesh.m
//  3DTerrainThing
//
//  Created by Matt Reagan on 11/6/16.
//  Copyright © 2016 Matt Reagan. All rights reserved.
//

#import "TerrainMesh.h"

@interface TerrainMesh ()

@property (nonatomic, readonly) int verticesPerSide;

@end

@implementation TerrainMesh

+ (instancetype)terrainMeshWithResolution:(int)verticesPerSide
{
    TerrainMesh *mesh = [[TerrainMesh alloc] initWithResolution:verticesPerSide];
    
    return mesh;
}

- (instancetype)initWithResolution:(int)verticesPerSide
{
    self = [super init];
    
    if (self)
    {
        _verticesPerSide = verticesPerSide;
        [self configureGeometry];
    }
    
    return self;
}

- (void)configureGeometry
{
    const double sideLength = 10.0; //The actual side length in units of the mesh in the scene
    
    NSInteger totalVertices = _verticesPerSide * _verticesPerSide;
    NSInteger squaresPerSide = (_verticesPerSide - 1);
    NSInteger totalSquares = squaresPerSide * squaresPerSide;
    NSInteger totalTriangles = totalSquares * 2;
    
    SCNVector3 *positions = malloc(sizeof(SCNVector3) * totalVertices);
    SCNVector3 *normals = malloc(sizeof(SCNVector3) * totalVertices);
    int *indices = malloc(sizeof(int) * totalTriangles * 3);
    float *textureCoordinates  = malloc(sizeof(float) * totalVertices * 2);
    
    for (int i = 0; i < totalVertices; i++)
    {
        NSInteger ix = i % _verticesPerSide;
        NSInteger iy = i / _verticesPerSide;
        
        double ixf = ((double)ix / (double)(_verticesPerSide - 1));
        double iyf = ((double)iy / (double)(_verticesPerSide - 1));
        double x = ixf * sideLength;
        double y = iyf * sideLength;
        positions[i] = SCNVector3Make(x, y, ((double)(random()%10)) / 10.0);
        
        normals[i] = SCNVector3Make(0, -1, 0);
        
        int ti = i * 2;
        textureCoordinates[ti] = ixf;
        textureCoordinates[ti+1] = iyf;
    }
    
    //Create the actual triangles
    for (int i = 0; i < totalTriangles; i++)
    {
        int squareIndex = (i / 2);
        int squareX = squareIndex % squaresPerSide;
        int squareY = squareIndex / squaresPerSide;
        
        int toprightIndex = ((squareY * (int)_verticesPerSide) + (int)_verticesPerSide) + squareX + 1;
        int topleftIndex = toprightIndex - 1;
        int bottomleftIndex = toprightIndex - (int)_verticesPerSide - 1;
        int bottomrightIndex = toprightIndex - (int)_verticesPerSide;
        
        int i1 = i * 3;
        int i2 = i1 + 1;
        int i3 = i1 + 2;
        
        if (i % 2 == 0)
        {
            indices[i1] = toprightIndex;
            indices[i2] = topleftIndex;
            indices[i3] = bottomleftIndex;
        }
        else
        {
            indices[i1] = toprightIndex;
            indices[i2] = bottomleftIndex;
            indices[i3] = bottomrightIndex;
        }
    }

    NSMutableData *textureData = [NSMutableData dataWithBytes:textureCoordinates length:totalVertices * sizeof(float) * 2];
    
    SCNGeometrySource *textureSource = [SCNGeometrySource geometrySourceWithData:textureData
                                                                        semantic:SCNGeometrySourceSemanticTexcoord
                                                                     vectorCount:totalVertices
                                                                 floatComponents:YES
                                                             componentsPerVector:2
                                                               bytesPerComponent:sizeof(float)
                                                                      dataOffset:0
                                                                      dataStride:sizeof(float) * 2];
    
    SCNGeometrySource *vertexSource =[SCNGeometrySource geometrySourceWithVertices:positions count:totalVertices];
    SCNGeometrySource *normalSource = [SCNGeometrySource geometrySourceWithNormals:normals count:totalVertices];
    
    NSData *indexData = [NSData dataWithBytes:indices length:sizeof(int) * totalTriangles * 3];
    
    SCNGeometryElement *element = [SCNGeometryElement geometryElementWithData:indexData
                                                                primitiveType:SCNGeometryPrimitiveTypeTriangles
                                                               primitiveCount:totalTriangles
                                                                bytesPerIndex:sizeof(int)];
    
    SCNGeometry *geometry = [SCNGeometry geometryWithSources:@[vertexSource, normalSource, textureSource]
                                                    elements:@[element]];
    geometry.subdivisionLevel = 2.0;
    
    SCNMaterial *mat = [SCNMaterial material];
    mat.diffuse.contents = [NSImage imageNamed:@"grass1"];
    mat.normal.contents = [NSImage imageNamed:@"grass1"];
    mat.specular.contents = [NSImage imageNamed:@"grass1"];
    mat.ambient.contents = [NSImage imageNamed:@"grass1"];
    mat.doubleSided = YES;
    geometry.materials = @[mat];
    
    self.geometry = geometry;
}

@end
