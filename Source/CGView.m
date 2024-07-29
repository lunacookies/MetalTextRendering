@implementation CGView
{
	NSAttributedString *attributedString;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[attributedString drawInRect:self.bounds];
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
