@implementation MainViewController

- (instancetype)init
{
	self = [super init];
	self.title = @"MetalTextRendering";
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	MetalView *metalView = [[MetalView alloc] init];
	NSViewController *metalViewController = [[NSViewController alloc] init];
	metalViewController.view = metalView;
	NSSplitViewItem *item =
	        [NSSplitViewItem splitViewItemWithViewController:metalViewController];
	[self addSplitViewItem:item];
}

@end
