#!/bin/sh

set -e

clang-format -i Source/*.h Source/*.m Source/*.metal

rm -rf "Build"

mkdir -p "Build/MetalTextRendering.app/Contents/MacOS"
mkdir -p "Build/MetalTextRendering.app/Contents/Resources"

cp "Data/MetalTextRendering-Info.plist" "Build/MetalTextRendering.app/Contents/Info.plist"
plutil -convert binary1 "Build/MetalTextRendering.app/Contents/Info.plist"

clang \
	-o "Build/MetalTextRendering.app/Contents/MacOS/MetalTextRendering" \
	-fmodules -fobjc-arc \
	-g3 \
	-fsanitize=undefined \
	-W \
	-Wall \
	-Wextra \
	-Wpedantic \
	-Wconversion \
	-Wimplicit-fallthrough \
	-Wmissing-prototypes \
	-Wshadow \
	-Wstrict-prototypes \
	"Source/EntryPoint.m"

xcrun metal \
	-o "Build/MetalTextRendering.app/Contents/Resources/default.metallib" \
	-gline-tables-only -frecord-sources \
	"Source/Shaders.metal"
