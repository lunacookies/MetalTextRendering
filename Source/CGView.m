@implementation CGView
{
	NSNotificationCenter *notificationCenter;
	NSAttributedString *attributedString;
	id<MTLDevice> device;
	id<MTLTexture> texture;
}

- (instancetype)initWithNotificationCenter:(NSNotificationCenter *)notificationCenter_
{
	self = [super init];

	self.wantsLayer = YES;
	notificationCenter = notificationCenter_;
	device = MTLCreateSystemDefaultDevice();

	return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[self drawRectInner];

	NSGraphicsContext *originalContext = NSGraphicsContext.currentContext;

	uint8 *pixels = calloc(texture.width * texture.height * 4, sizeof(uint8));
	NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
	        initWithBitmapDataPlanes:&pixels
	                      pixelsWide:(imm)texture.width
	                      pixelsHigh:(imm)texture.height
	                   bitsPerSample:8
	                 samplesPerPixel:4
	                        hasAlpha:YES
	                        isPlanar:NO
	                  colorSpaceName:NSDeviceRGBColorSpace
	                    bitmapFormat:NSBitmapFormatThirtyTwoBitLittleEndian
	                     bytesPerRow:4 * (imm)texture.width
	                    bitsPerPixel:32];

	NSGraphicsContext.currentContext =
	        [NSGraphicsContext graphicsContextWithBitmapImageRep:rep];

	NSAffineTransform *transform = [[NSAffineTransform alloc] init];
	[transform scaleXBy:self.window.backingScaleFactor yBy:self.window.backingScaleFactor];
	[transform set];

	[self drawRectInner];

	[texture replaceRegion:MTLRegionMake2D(0, 0, texture.width, texture.height)
	           mipmapLevel:0
	             withBytes:pixels
	           bytesPerRow:4 * texture.width];

	free(pixels);

	[notificationCenter postNotificationName:UpdatedTextureANotificationName object:texture];

	NSGraphicsContext.currentContext = originalContext;
}

- (void)drawRectInner
{
	[NSColor.windowBackgroundColor setFill];
	NSRectFill(self.bounds);
	[attributedString drawInRect:self.bounds];
}

- (void)viewDidChangeBackingProperties
{
	[super viewDidChangeBackingProperties];
	[self updateTexture];
}

- (void)setFrameSize:(NSSize)size
{
	[super setFrameSize:size];
	[self updateTexture];
}

- (void)updateTexture
{
	NSSize size = [self convertSizeToBacking:self.bounds.size];

	if (size.width == 0 || size.height == 0)
	{
		return;
	}

	MTLTextureDescriptor *descriptor = [[MTLTextureDescriptor alloc] init];
	descriptor.width = (umm)size.width;
	descriptor.height = (umm)size.height;
	texture = [device newTextureWithDescriptor:descriptor];
	texture.label = @"Rendered CGView Layer";
}

- (NSAttributedString *)attributedString
{
	return attributedString;
}

- (void)setAttributedString:(NSAttributedString *)attributedString_
{
	attributedString = attributedString_;
	self.needsDisplay = YES;
}

@end
