//
//  AppDelegate.m
//  3DTerrainThing
//
//  Created by Matt Reagan on 11/5/16.
//  Copyright © 2016 Matt Reagan. All rights reserved.
//

#import "AppDelegate.h"
#import <SceneKit/SceneKit.h>
#import "TerrainScene.h"
#import "TerrainMesh.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    SCNView *view = [[SCNView alloc] initWithFrame:self.window.contentView.bounds
                                           options:nil];
    view.showsStatistics = YES;
    [self.window.contentView addSubview:view];
    
    TerrainScene *scene = [TerrainScene scene];
    view.scene = scene;
    view.allowsCameraControl = YES;
    view.autoenablesDefaultLighting = NO;
    
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
    
    TerrainMesh *mesh = [TerrainMesh terrainMeshWithResolution:40 sideLength:10.0];
    
    SCNMaterial *mat = [SCNMaterial material];
    mat.diffuse.contents = [NSImage imageNamed:@"grass1"];
    mat.doubleSided = YES;
    mesh.geometry.materials = @[mat];
    
    [scene.rootNode addChildNode:mesh];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
