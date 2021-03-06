//
//  AppDelegate.m
//  MidiTest
//
//  Created by Iain Wood on 30/12/2014.
//  Copyright (c) 2014 soulflyer. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Insert code here to initialize your application
  ItemCount deviceCount = MIDIGetNumberOfDevices();
  // Iterate through all MIDI devices
  for (ItemCount i = 0 ; i < deviceCount ; ++i) {
    
    // Grab a reference to current device
    MIDIDeviceRef device = MIDIGetDevice(i);
    NSLog(@"Device: %@", getName(device));
    
    // Is this device online? (Currently connected?)
    SInt32 isOffline = 0;
    MIDIObjectGetIntegerProperty(device, kMIDIPropertyOffline, &isOffline);
    NSLog(@"Device is online: %s", (isOffline ? "No" : "Yes"));
    
    // How many entities do we have?
    ItemCount entityCount = MIDIDeviceGetNumberOfEntities(device);
    
    // Iterate through this device's entities
    for (ItemCount j = 0 ; j < entityCount ; ++j) {
      
      // Grab a reference to an entity
      MIDIEntityRef entity = MIDIDeviceGetEntity(device, j);
      NSLog(@"  Entity: %@", getName(entity));
      
      // Iterate through this device's source endpoints (MIDI In)
      ItemCount sourceCount = MIDIEntityGetNumberOfSources(entity);
      for (ItemCount k = 0 ; k < sourceCount ; ++k) {
        
        // Grab a reference to a source endpoint
        MIDIEndpointRef source = MIDIEntityGetSource(entity, k);
        NSLog(@"    Source: %@", getName(source));
      }
      
      // Iterate through this device's destination endpoints
      ItemCount destCount = MIDIEntityGetNumberOfDestinations(entity);
      for (ItemCount k = 0 ; k < destCount ; ++k) {
        
        // Grab a reference to a destination endpoint
        MIDIEndpointRef dest = MIDIEntityGetDestination(entity, k);
        NSLog(@"    Destination: %@", getName(dest));
      }
    }
    NSLog(@"------");
  }
}

NSString *getName(MIDIObjectRef object)
{
  // Returns the name of a given MIDIObjectRef as an NSString
  CFStringRef name = nil;
  if (noErr != MIDIObjectGetStringProperty(object, kMIDIPropertyName, &name))
    return nil;
  return (__bridge NSString *)name;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}

@end
