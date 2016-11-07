//
//  AppDelegate.m
//  TerrainMesh3D
//
//  Created by Matt Reagan on 11/5/16.
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

#import "AppDelegate.h"
#import <SceneKit/SceneKit.h>
#import "TerrainMesh.h"
#import "TerrainView.h"

#define BIGRANDOMVAL 9999999
#define RANDOMPERCENTAGE ((float)((arc4random()%BIGRANDOMVAL) / (float)BIGRANDOMVAL))

@interface AppDelegate ()

//Outlets
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSView *toolsView;

//Demo properties
@property (strong) TerrainMesh *mesh;
@property (strong) TerrainView *terrainView;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    /*  Set up our TerrainView. This is a simple SCNView subclass which
        handles the mouse events and passes those clicks along to the mesh
        so we can deform the terrain in the demo. */
    
    TerrainView *terrainView = [[TerrainView alloc] initWithFrame:self.window.contentView.bounds
                                                   options:nil];
    terrainView.allowsCameraControl = NO;
    terrainView.autoenablesDefaultLighting = NO;
    terrainView.showsStatistics = YES;
    [self.window.contentView addSubview:terrainView];
    self.terrainView = terrainView;
    
    /*  Create a simple scene with a sky background */
    SCNScene *scene = [SCNScene scene];
    scene.background.contents = [NSImage imageNamed:@"sky2"];
    terrainView.scene = scene;
    
    /*  Give our scene some basic lighting */
    [self configureDefaultLighting];
    
    /*  Create the terrain mesh */
    const int kMeshResolution = 40;
    TerrainMesh *mesh = [TerrainMesh terrainMeshWithResolution:kMeshResolution sideLength:10.0];
    
    /*  Give the terrain a nice terrain-y texture */
    SCNMaterial *mat = [SCNMaterial material];
    mat.diffuse.contents = [NSImage imageNamed:@"grass1"];
    mat.doubleSided = YES;
    mesh.geometry.materials = @[mat];
    
    /*  Add the terrain to the scene */
    [scene.rootNode addChildNode:mesh];
    self.mesh = mesh;
    
    /*  Give the starting terrain a nice little spin intro for the Demo */
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:2.2];
    mesh.rotation = SCNVector4Make(1.0, 0.2, 0, -M_PI_4);
    mesh.position = SCNVector3Make(0.0, 2.0, 0.0);
    [SCNTransaction commit];
    
    /*  Add the tools view, make sure it's above the SCNView debug controls */
    [self.window.contentView addSubview:self.toolsView positioned:NSWindowAbove relativeTo:terrainView];
    NSRect toolsFrame = self.toolsView.frame;
    toolsFrame.origin.y += 20.0;
    self.toolsView.frame = toolsFrame;
}

#pragma mark - Helper Methods

- (void)configureDefaultLighting
{
    SCNScene *scene = self.terrainView.scene;
    
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [NSColor colorWithWhite:0.70 alpha:1.0];
    ambientLightNode.light.intensity = 800;
    [scene.rootNode addChildNode:ambientLightNode];
    
    SCNNode *spotLightNode = [SCNNode node];
    spotLightNode.light = [SCNLight light];
    spotLightNode.light.type = SCNLightTypeSpot;
    spotLightNode.light.color = [NSColor colorWithRed:1.0 green:1.0 blue:0.75 alpha:1.0];
    spotLightNode.light.intensity = 500;
    spotLightNode.position = SCNVector3Make(5.0, 5.0, 10);
    [scene.rootNode addChildNode:spotLightNode];
}

#pragma mark - Demo Actions

- (IBAction)paintBrushToolClicked:(id)sender
{
    self.terrainView.allowsCameraControl = NO;
}

- (IBAction)cameraToolClicked:(id)sender
{
    self.terrainView.allowsCameraControl = YES;
}

- (IBAction)resetClicked:(id)sender
{
    int meshResolution = self.mesh.verticesPerSide;
    
    [self.mesh updateGeometry:^double(int x, int y) {
        /* Randomize terrain to be slightly bumpy
           with a small mountain in the center. */
        
        int mapHalf = (meshResolution/2);
        double xDelta = (x - mapHalf);
        double yDelta = (y - mapHalf);
        double distance = sqrt((xDelta * xDelta) + (yDelta * yDelta));
        distance /= mapHalf;
        distance /= 1;
        distance = 1.0 - distance;
        distance = sin((distance * distance) * M_PI_2);
        
        return (distance * 1.75) + (RANDOMPERCENTAGE * .15);
    }];
}

@end
