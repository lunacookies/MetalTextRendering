@implementation AppDelegate
{
	NSWindow *window;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
	NSWindowStyleMask styleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable |
	                              NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;

	window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 500, 600)
	                                     styleMask:styleMask
	                                       backing:NSBackingStoreBuffered
	                                         defer:NO];

	window.contentView = [[MainView alloc] init];

	[window center];
	[window makeKeyAndOrderFront:nil];

	[NSApp activate];
}

@end
