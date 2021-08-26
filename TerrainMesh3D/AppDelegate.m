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
//
// web page: <http://mattreagandev.com/?article=20161108>
// github sources: <https://github.com/matthewreagan/TerrainMesh3D>
//
// Modifications by <geowar1@mac.com> on Aug 26, 2021
// Added orbiting omni light
//

#import "AppDelegate.h"
#import <SceneKit/SceneKit.h>
#import "TerrainMesh.h"
#import "TerrainView.h"

#define RANDOMPERCENTAGE ((CGFloat) (arc4random() / (CGFloat) RAND_MAX))

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
    //resize our window to our main monitor screen size
    NSScreen *screen = [[NSScreen screens] objectAtIndex: 0];

    //set the window's orgin and frame based on the screen's orgin and frame
    NSRect screenFrame = [screen visibleFrame];
    [self.window setFrameOrigin:screenFrame.origin];
    [self.window setFrame:screen.frame display:YES animate:NO];

    /*  Set up our TerrainView. This is a simple SCNView subclass which
        handles the mouse events and passes those clicks along to the mesh
        so we can deform the terrain in the demo. */

    TerrainView *terrainView = [[TerrainView alloc] initWithFrame:self.window.contentView.bounds
                                                   options:nil];
    terrainView.allowsCameraControl = NO;
    terrainView.autoenablesDefaultLighting = NO;
    terrainView.showsStatistics = YES;
    //terrainView.debugOptions = SCNDebugOptionRenderAsWireframe;
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

    [self exampleClicked:NULL]; // add a mountain

    /*  Give the starting terrain a nice little spin intro for the Demo */
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:2.2];
//    mesh.rotation = SCNVector4Make(1.0, 0.2, 0, -M_PI_4);
//    mesh.position = SCNVector3Make(0.0, 2.0, 0.0);
    scene.rootNode.rotation = SCNVector4Make(1.0, 0.0, 0, -M_PI_4);
    [SCNTransaction commit];

    /*  Add the tools view, make sure it's above the SCNView debug controls */
    [self.window.contentView addSubview:self.toolsView positioned:NSWindowAbove relativeTo:terrainView];
    NSRect toolsFrame = self.toolsView.frame;
    toolsFrame.origin.y += 20;
    self.toolsView.frame = toolsFrame;
}

#pragma mark - Helper Methods

- (void)configureDefaultLighting
{
    SCNScene *scene = self.terrainView.scene;

    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [NSColor colorWithRed:1 green:1 blue:0.7 alpha:1];
    ambientLightNode.light.intensity = 300;
    [scene.rootNode addChildNode:ambientLightNode];

    SCNNode *spotLightNode = [SCNNode node];
    spotLightNode.light = [SCNLight light];
    spotLightNode.light.type = SCNLightTypeOmni;
    spotLightNode.light.color = [NSColor colorWithWhite:1.0 alpha:0.0];
    spotLightNode.light.intensity = 1000;
    spotLightNode.position = SCNVector3Make(0, 5, 3);
    [scene.rootNode addChildNode:spotLightNode];

    SCNNode *planetNode = [SCNNode node];
    planetNode.geometry = [SCNSphere sphereWithRadius:.1];
    [spotLightNode addChildNode:planetNode];

    NSTimeInterval duration = 6;
    [spotLightNode runAction:[SCNAction repeatActionForever:[SCNAction customActionWithDuration:duration
                                                                                    actionBlock:^(SCNNode * _Nonnull node, CGFloat elapsedTime) {
        double angleRAD = elapsedTime * M_PI * 2 / duration;
        CGFloat orbit_radius = 3;
        node.position = SCNVector3Make(5 + (orbit_radius * sin(angleRAD)), 5 + (orbit_radius * cos(angleRAD)), 3);
    }]]];
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
    /*  Reset the mesh to be completely flat. */

     [self.mesh updateGeometry:^double(int x, int y) {
         return 0;
     }];
}

- (IBAction)exampleClicked:(id)sender
{
    int meshResolution = self.mesh.verticesPerSide;
    int mapHalf = (meshResolution/2);

    [self.mesh updateGeometry:^double(int x, int y) {
        /* Randomize terrain to be slightly bumpy
           with a small mountain in the center. */

        double xDelta = (x - mapHalf);
        double yDelta = (y - mapHalf);
        double distance = sqrt((xDelta * xDelta) + (yDelta * yDelta));
        distance /= mapHalf;
        distance = 1 - distance;
        distance = sin((distance * distance) * M_PI_2);

        return (distance * 2.75) + (RANDOMPERCENTAGE * .1);
    }];
}

@end
