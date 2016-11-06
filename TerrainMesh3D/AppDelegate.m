//
//  AppDelegate.m
//  3DTerrainThing
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
    TerrainView *terrainView = [[TerrainView alloc] initWithFrame:self.window.contentView.bounds
                                                   options:nil];
    terrainView.allowsCameraControl = NO;
    terrainView.autoenablesDefaultLighting = NO;
    terrainView.showsStatistics = YES;
    self.terrainView = terrainView;
    
    [self.window.contentView addSubview:terrainView];
    
    SCNScene *scene = [SCNScene scene];
    scene.background.contents = [NSImage imageNamed:@"sky2"];
    terrainView.scene = scene;
    
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
    
    TerrainMesh *mesh = [TerrainMesh terrainMeshWithResolution:60 sideLength:10.0];
    
    SCNMaterial *mat = [SCNMaterial material];
    mat.diffuse.contents = [NSImage imageNamed:@"grass1"];
    mat.doubleSided = YES;
    mesh.geometry.materials = @[mat];
    
    [scene.rootNode addChildNode:mesh];
    self.mesh = mesh;
    
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:2.2];
    mesh.rotation = SCNVector4Make(1.0, 0.2, 0, -M_PI_4);
    mesh.position = SCNVector3Make(0.0, 2.0, 0.0);
    [SCNTransaction commit];
    
    [self.window.contentView addSubview:self.toolsView positioned:NSWindowAbove relativeTo:terrainView];
    
//    [NSTimer scheduledTimerWithTimeInterval:1.0/40.0
//                                     target:self
//                                   selector:@selector(demoTimer:)
//                                   userInfo:nil
//                                    repeats:YES];
}

- (void)demoTimer:(NSTimer *)timer
{
//    double randomX = RANDOMPERCENTAGE;
//    double randomY = RANDOMPERCENTAGE;
//    [self.mesh derformTerrainAt:CGPointMake(randomX, randomY)
//                    brushRadius:0.1
//                      intensity:.20];
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
