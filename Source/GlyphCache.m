typedef struct GlyphCacheEntry GlyphCacheEntry;
struct GlyphCacheEntry
{
	CGGlyph glyph;
	CTFontRef font;
	CGPoint subpixelOffset;
	CachedGlyph cachedGlyph;
};

static const CGFloat padding = 2;

@implementation GlyphCache
{
	imm diameter;
	CGFloat scaleFactor;
	id<MTLTexture> texture;
	CGContextRef context;
	CGPoint cursor;
	CGFloat largestGlyphHeight;

	GlyphCacheEntry *entries;
	imm entryCapacity;
	imm entryCount;
}

- (instancetype)initWithDevice:(id<MTLDevice>)device scaleFactor:(CGFloat)scaleFactor_
{
	self = [super init];
	scaleFactor = scaleFactor_;

	diameter = 128;

	MTLTextureDescriptor *descriptor = [[MTLTextureDescriptor alloc] init];
	descriptor.width = (umm)diameter;
	descriptor.height = (umm)diameter;
	descriptor.pixelFormat = MTLPixelFormatR8Unorm;
	descriptor.storageMode = MTLStorageModeShared;
	texture = [device newTextureWithDescriptor:descriptor];
	texture.label = @"Glyph Cache";

	context = CGBitmapContextCreate(NULL, (umm)diameter, (umm)diameter, 8, (umm)diameter,
	        CGColorSpaceCreateWithName(kCGColorSpaceLinearGray), kCGImageAlphaOnly);
	CGContextScaleCTM(context, scaleFactor, scaleFactor);

	entryCapacity = 1024;
	entries = malloc((umm)entryCapacity * sizeof(GlyphCacheEntry));

	return self;
}

- (CachedGlyph)cachedGlyph:(CGGlyph)glyph
                      font:(CTFontRef)font
            subpixelOffset:(CGPoint)subpixelOffset
{
	for (imm entryIndex = 0; entryIndex < entryCount; entryIndex++)
	{
		GlyphCacheEntry *entry = entries + entryIndex;
		if (entry->glyph == glyph && CFEqual(entry->font, font) &&
		        entry->subpixelOffset.x == subpixelOffset.x &&
		        entry->subpixelOffset.y == subpixelOffset.y)
		{
			return entry->cachedGlyph;
		}
	}

	if (entryCount == entryCapacity)
	{
		entryCapacity *= 2;
		entries = realloc(entries, (umm)entryCapacity * sizeof(GlyphCacheEntry));
	}

	GlyphCacheEntry *entry = entries + entryCount;
	entryCount++;

	CFRetain(font);
	memset(entry, 0, sizeof(*entry));
	entry->glyph = glyph;
	entry->font = font;
	entry->subpixelOffset = subpixelOffset;
	CachedGlyph *cachedGlyph = &entry->cachedGlyph;

	CGRect boundingRect = {0};
	CTFontGetBoundingRectsForGlyphs(font, kCTFontOrientationDefault, &glyph, &boundingRect, 1);

	if ((cursor.x + boundingRect.size.width) * scaleFactor >= diameter)
	{
		cursor.x = 0;
		cursor.y += largestGlyphHeight + padding;
		largestGlyphHeight = 0;
	}

	CGPoint position = cursor;
	cachedGlyph->position.x = (float)(position.x * scaleFactor);
	cachedGlyph->position.y = (float)(position.y * scaleFactor);

	position.x -= boundingRect.origin.x;
	position.y -= boundingRect.origin.y;

	position.x += padding / scaleFactor;
	position.y += padding / scaleFactor;

	largestGlyphHeight = Max(largestGlyphHeight, boundingRect.size.height);

	CTFontDrawGlyphs(font, &glyph, &position, 1, context);
	[texture replaceRegion:MTLRegionMake2D(0, 0, (umm)diameter, (umm)diameter)
	           mipmapLevel:0
	             withBytes:CGBitmapContextGetData(context)
	           bytesPerRow:(umm)diameter];

	cursor.x += boundingRect.size.width + padding;

	cachedGlyph->size.x = (float)(boundingRect.size.width * scaleFactor);
	cachedGlyph->size.y = (float)(boundingRect.size.height * scaleFactor);
	cachedGlyph->size += 2 * padding;

	cachedGlyph->offset = padding;

	return *cachedGlyph;
}

- (void)dealloc
{
	for (imm entryIndex = 0; entryIndex < entryCount; entryIndex++)
	{
		GlyphCacheEntry *entry = entries + entryIndex;
		CFRelease(entry->font);
	}

	free(entries);

	CFRelease(context);
}

- (id<MTLTexture>)texture
{
	return texture;
}

@end
