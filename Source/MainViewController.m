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

	NSAttributedString *attributedString = [[NSAttributedString alloc]
	        initWithString:@"The quick brown fox jumps over the lazy dog."
	            attributes:@{
		            NSFontAttributeName : [NSFont fontWithName:@"Zapfino" size:50],
		            NSForegroundColorAttributeName : NSColor.labelColor,
	            }];

	CGView *cgView = [[CGView alloc] init];
	cgView.attributedString = attributedString;

	NSBox *separator = [[NSBox alloc] init];
	separator.boxType = NSBoxSeparator;

	MetalView *metalView = [[MetalView alloc] init];
	metalView.attributedString = attributedString;

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
