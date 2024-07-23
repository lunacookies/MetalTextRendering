@import AppKit;
@import Metal;

#include "MetalView.h"
#include "MainViewController.h"
#include "AppDelegate.h"

#include "MetalView.m"
#include "MainViewController.m"
#include "AppDelegate.m"

int32_t
main(void)
{
	setenv("MTL_SHADER_VALIDATION", "1", 1);
	setenv("MTL_DEBUG_LAYER", "1", 1);
	setenv("MTL_DEBUG_LAYER_WARNING_MODE", "nslog", 1);

	[NSApplication sharedApplication];
	AppDelegate *appDelegate = [[AppDelegate alloc] init];
	NSApp.delegate = appDelegate;
	[NSApp run];
}
