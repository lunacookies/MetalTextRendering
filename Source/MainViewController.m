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
		            NSFontAttributeName : [NSFont systemFontOfSize:13],
		            NSForegroundColorAttributeName : NSColor.labelColor,
	            }];

	NSNotificationCenter *notificationCenter = [[NSNotificationCenter alloc] init];

	CGView *cgView = [[CGView alloc] initWithNotificationCenter:notificationCenter];
	cgView.attributedString = attributedString;

	NSBox *separator = [[NSBox alloc] init];
	separator.boxType = NSBoxSeparator;

	MetalView *metalView = [[MetalView alloc] initWithNotificationCenter:notificationCenter];
	metalView.attributedString = attributedString;

	NSBox *separator2 = [[NSBox alloc] init];
	separator2.boxType = NSBoxSeparator;

	DiffView *diffView = [[DiffView alloc] initWithNotificationCenter:notificationCenter];

	NSStackView *stackView = [NSStackView
	        stackViewWithViews:@[ cgView, separator, metalView, separator2, diffView ]];
	stackView.spacing = 0;

	[self.view addSubview:stackView];
	stackView.translatesAutoresizingMaskIntoConstraints = NO;
	[NSLayoutConstraint activateConstraints:@[
		[stackView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
		[stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
		[stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
		[stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
		[cgView.widthAnchor constraintEqualToAnchor:metalView.widthAnchor],
		[cgView.widthAnchor constraintEqualToAnchor:diffView.widthAnchor],
	]];
}

@end
