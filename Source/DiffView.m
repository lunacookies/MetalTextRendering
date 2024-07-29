@interface
DiffView () <CALayerDelegate>
@end

@implementation DiffView
{
	NSNotificationCenter *notificationCenter;

	id<MTLDevice> device;
	id<MTLCommandQueue> commandQueue;
	id<MTLComputePipelineState> pipelineState;

	IOSurfaceRef iosurface;
	id<MTLTexture> texture;

	id<MTLTexture> textureA;
	id<MTLTexture> textureB;
}

- (instancetype)initWithNotificationCenter:(NSNotificationCenter *)notificationCenter_
{
	self = [super init];

	notificationCenter = notificationCenter_;
	[notificationCenter addObserver:self
	                       selector:@selector(didUpdateTextureA:)
	                           name:UpdatedTextureANotificationName
	                         object:nil];
	[notificationCenter addObserver:self
	                       selector:@selector(didUpdateTextureB:)
	                           name:UpdatedTextureBNotificationName
	                         object:nil];

	self.layer = [CALayer layer];
	self.layer.delegate = self;
	self.wantsLayer = YES;

	device = MTLCreateSystemDefaultDevice();
	commandQueue = [device newCommandQueue];

	id<MTLLibrary> library = [device newDefaultLibrary];
	pipelineState =
	        [device newComputePipelineStateWithFunction:[library newFunctionWithName:@"diff"]
	                                              error:nil];

	return self;
}

- (void)displayLayer:(CALayer *)layer
{
	if (textureA == nil || textureB == nil)
	{
		return;
	}

	id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];

	id<MTLComputeCommandEncoder> encoder = [commandBuffer computeCommandEncoder];

	[encoder setComputePipelineState:pipelineState];

	[encoder setTexture:texture atIndex:0];
	[encoder setTexture:textureA atIndex:1];
	[encoder setTexture:textureB atIndex:2];

	[encoder dispatchThreads:MTLSizeMake(texture.width, texture.height, 1)
	        threadsPerThreadgroup:MTLSizeMake(32, 32, 1)];

	[encoder endEncoding];

	[commandBuffer commit];
	[commandBuffer waitUntilCompleted];
	[layer setContentsChanged];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
	[self updateIOSurface];
	[self.layer setNeedsDisplay];
}

- (void)viewDidChangeBackingProperties
{
	[super viewDidChangeBackingProperties];

	self.layer.contentsScale = self.window.backingScaleFactor;
	[self updateIOSurface];
	[self.layer setNeedsDisplay];
}

- (void)updateIOSurface
{
	NSSize size = [self convertSizeToBacking:self.layer.frame.size];

	if (size.width == 0 || size.height == 0)
	{
		return;
	}

	NSDictionary *properties = @{
		(__bridge NSString *)kIOSurfaceWidth : @(size.width),
		(__bridge NSString *)kIOSurfaceHeight : @(size.height),
		(__bridge NSString *)kIOSurfaceBytesPerElement : @4,
		(__bridge NSString *)kIOSurfacePixelFormat : @(kCVPixelFormatType_32BGRA),
	};

	MTLTextureDescriptor *descriptor = [[MTLTextureDescriptor alloc] init];
	descriptor.width = (umm)size.width;
	descriptor.height = (umm)size.height;
	descriptor.usage = MTLTextureUsageShaderWrite;
	descriptor.pixelFormat = MTLPixelFormatBGRA8Unorm;

	if (iosurface != NULL)
	{
		CFRelease(iosurface);
	}

	iosurface = IOSurfaceCreate((__bridge CFDictionaryRef)properties);
	texture = [device newTextureWithDescriptor:descriptor iosurface:iosurface plane:0];
	texture.label = @"Layer Contents";

	self.layer.contents = (__bridge id)iosurface;
}

- (void)didUpdateTextureA:(NSNotification *)notification
{
	textureA = notification.object;
	[self.layer setNeedsDisplay];
}

- (void)didUpdateTextureB:(NSNotification *)notification
{
	textureB = notification.object;
	[self.layer setNeedsDisplay];
}

@end
