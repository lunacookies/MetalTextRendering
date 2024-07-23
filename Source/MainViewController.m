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

	CGView *cgView = [[CGView alloc] init];

	NSBox *separator = [[NSBox alloc] init];
	separator.boxType = NSBoxSeparator;

	MetalView *metalView = [[MetalView alloc] init];

	NSStackView *stackView = [NSStackView stackViewWithViews:@[ cgView, separator, metalView ]];
	stackView.spacing = 0;

	[self.view addSubview:stackView];
	stackView.translatesAutoresizingMaskIntoConstraints = NO;
	[NSLayoutConstraint activateConstraints:@[
		[stackView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
		[stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
		[stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
		[stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
		[cgView.widthAnchor constraintEqualToAnchor:metalView.widthAnchor],
	]];
}

@end
