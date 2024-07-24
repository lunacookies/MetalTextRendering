@implementation CGView

- (void)drawRect:(NSRect)dirtyRect
{
	NSAttributedString *attributedString = [[NSAttributedString alloc]
	        initWithString:@"The quick brown fox jumps over the lazy dog."
	            attributes:@{
		            NSFontAttributeName : [NSFont fontWithName:@"Zapfino" size:50],
		            NSForegroundColorAttributeName : NSColor.labelColor,
	            }];

	[attributedString drawInRect:self.bounds];
}

@end
