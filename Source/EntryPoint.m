@import AppKit;
@import Metal;
@import simd;

typedef int8_t int8;
typedef int16_t int16;
typedef int32_t int32;
typedef int64_t int64;

typedef uint8_t uint8;
typedef uint16_t uint16;
typedef uint32_t uint32;
typedef uint64_t uint64;

typedef uint8 bool8;
typedef uint16 bool16;
typedef uint32 bool32;
typedef uint64 bool64;

typedef size_t umm;
typedef ptrdiff_t imm;

#define Assert(b) \
	if (!(b)) \
	{ \
		__builtin_debugtrap(); \
	}

#include "CGView.h"
#include "MetalView.h"
#include "MainViewController.h"
#include "AppDelegate.h"

#include "CGView.m"
#include "MetalView.m"
#include "MainViewController.m"
#include "AppDelegate.m"

int32
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
