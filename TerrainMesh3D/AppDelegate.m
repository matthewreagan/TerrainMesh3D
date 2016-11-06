//
//  AppDelegate.m
//  TerrainMesh3D
//
//  Created by Matt Reagan on 11/5/16.
//  Copyright © 2016 Matt Reagan. All rights reserved.
//

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
    TerrainMesh *mesh = [TerrainMesh terrainMeshWithResolution:40 sideLength:10.0];
    
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
    ambientLightNode.light.color = [NSColor colorWithWhite:1 alpha:1.0];
    ambientLightNode.light.intensity = 800;
    [scene.rootNode addChildNode:ambientLightNode];
    
    SCNNode *omniLightNode = [SCNNode node];
    omniLightNode.light = [SCNLight light];
    omniLightNode.light.type = SCNLightTypeOmni;
    omniLightNode.light.color = [NSColor yellowColor];
    omniLightNode.light.intensity = 500;
    omniLightNode.position = SCNVector3Make(0, 5, 1);
    [scene.rootNode addChildNode:omniLightNode];
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


@end
