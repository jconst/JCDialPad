
#import "JCDialPad.h"
#import "JCPadButton.h"
#import "UIView+FrameAccessor.h"
#import "NBAsYouTypeFormatter.h"

#define animationLength 0.3
#define IS_IPHONE5 ([UIScreen mainScreen].bounds.size.height==568)
#define IS_IOS6_OR_LOWER (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface JCDialPad()

@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UIView* backgroundBlurringView;
@property (nonatomic, strong) NBAsYouTypeFormatter *numFormatter;


@end

@implementation JCDialPad

- (id)initWithFrame:(CGRect)frame buttons:(NSArray *)buttons
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setDefaultStyles];
		
		self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, MIN(frame.size.height, 568.0f))];
		self.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
		self.contentView.center = self.center;
		[self addSubview:self.contentView];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteButton addTarget:self action:@selector(didTapDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:24.0];
        [self.deleteButton setTitle:@"◀︎" forState:UIControlStateNormal];
        [self.deleteButton setTitleColor:[UIColor colorWithWhite:1.000 alpha:0.500] forState:UIControlStateHighlighted];
        self.deleteButton.alpha = 0.0;
		self.deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        self.digitsTextField = [UITextField new];
        self.digitsTextField.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:38.0];
        self.digitsTextField.adjustsFontSizeToFitWidth = YES;
        self.digitsTextField.enabled = NO;
        self.digitsTextField.textAlignment = NSTextAlignmentCenter;
        self.digitsTextField.borderStyle = UITextBorderStyleNone;
        
        self.formatTextToPhoneNumber = YES;
        self.numFormatter = [[NBAsYouTypeFormatter alloc] initWithRegionCode:@"US"];
        _rawText = @"";
        
        self.buttons = buttons;
    }
    return self;
}

#pragma mark -
#pragma mark - Lifecycle Methods
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self performLayout];
	[self prepareAppearance];
}

#pragma mark -
#pragma mark - Public Methods
+ (NSArray *)defaultButtons
{
    NSArray *mains = @[@"1", @"2",   @"3",   @"4",   @"5",   @"6",   @"7",    @"8",   @"9",    @"✳︎", @"0", @"＃"];
    NSArray *subs  = @[@"",  @"ABC", @"DEF", @"GHI", @"JKL", @"MNO", @"PQRS", @"TUV", @"WXYZ", @"",  @"+", @""];
    NSMutableArray *ret = [NSMutableArray array];
    
    [mains enumerateObjectsUsingBlock:^(NSString *main, NSUInteger idx, BOOL *stop) {
        JCPadButton *button = [[JCPadButton alloc] initWithMainLabel:main subLabel:subs[idx]];
        if ([main isEqualToString:@"✳︎"]) {
            button.input = @"*";
        } else if ([main isEqualToString:@"＃"]) {
            button.input = @"#";
        }
        [ret addObject:button];
    }];
    
    return ret;
}

- (void)setBackgroundView:(UIView *)backgroundView
{
	[_backgroundView removeFromSuperview];
	_backgroundView = backgroundView;

	if(_backgroundView == nil)
	{
		[self.backgroundBlurringView setHidden:YES];
	}
	else
	{
		if(self.backgroundBlurringView == nil)
		{
			if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
			{
				self.backgroundBlurringView = [[UINavigationBar alloc] initWithFrame:self.bounds];
				[(UINavigationBar*)self.backgroundBlurringView setBarStyle: UIBarStyleBlack];
			}
			else
			{
				self.backgroundBlurringView = [[UIView alloc] initWithFrame:self.bounds];
				self.backgroundBlurringView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.75f];
			}
			self.backgroundBlurringView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			[self insertSubview:self.backgroundBlurringView belowSubview:self.contentView];
		}
		
		[self.backgroundBlurringView setHidden:NO];

		[_backgroundView setFrame:self.bounds];
		[_backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[self insertSubview:_backgroundView belowSubview:self.backgroundBlurringView];
	}
}

#pragma mark -
#pragma mark - Helper Methods
- (void)didTapButton:(UIButton *)sender
{
    if ([sender isKindOfClass:[JCPadButton class]]) {
        JCPadButton *button = (JCPadButton *)sender;
        
        if (![self.delegate respondsToSelector:@selector(dialPad:shouldInsertText:forButtonPress:)] ||
            [self.delegate dialPad:self shouldInsertText:button.input forButtonPress:button]) {
            [self appendText:button.input];
        }
    }
}

- (void)appendText:(NSString *)text
{
    if (text.length) {
        self.rawText = [self.rawText stringByAppendingString:text];
        NSString *formatted = self.rawText;
        if (self.formatTextToPhoneNumber) {
            [self.numFormatter inputDigit:text];
            formatted = [self.numFormatter description];
        }
        self.digitsTextField.text = formatted;
        
        [self toggleDeleteButtonVisible:YES animated:YES];
    }
}

- (void)didTapDeleteButton:(UIButton *)sender
{
    self.rawText = [self.rawText substringToIndex:self.rawText.length - 1];
    NSString *formatted = self.rawText;
    if (self.formatTextToPhoneNumber) {
        [self.numFormatter removeLastDigit];
        formatted = [self.numFormatter description];
    }
    self.digitsTextField.text = formatted;
    
    if (!self.rawText.length) {
        [self toggleDeleteButtonVisible:NO animated:YES];
    }
}

- (void)setDefaultStyles
{
    self.labelColor = [UIColor whiteColor];
}

- (void)prepareAppearance
{
	self.digitsTextField.textColor = [(JCPadButton*)self.buttons[0] borderColor];
	
	self.digitsTextField.text = @"";
	
    [self.deleteButton setTitleColor:self.labelColor forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark - Leyout Methods
- (void)performLayout
{
    [self layoutTitleArea];
    [self layoutButtons];
}

- (void)layoutTitleArea
{
    CGFloat top = 22;
	
	if(IS_IPHONE5) {
		top = 35;
	} else if (IS_IPAD) {
        top = 60;
    }
    if (IS_IOS6_OR_LOWER) {
        top -= 20;
    }
	
    CGFloat textFieldWidth = 250;
    self.digitsTextField.frame = CGRectMake((self.correctWidth / 2) - (textFieldWidth / 2) - 10, top, textFieldWidth, 40);
    [self.contentView addSubview:self.digitsTextField];
    
    self.deleteButton.frame = CGRectMake(self.digitsTextField.right + 2, self.digitsTextField.center.y - 10, 50, 20);
    [self.contentView addSubview:self.deleteButton];
}

- (void)layoutButtons
{
    CGFloat horizontalButtonPadding = 20;
    CGFloat verticalButtonPadding = 7;
    
    CGFloat topRowTop = self.digitsTextField.bottom + 6;
    NSInteger count = self.buttons.count;
    CGFloat cellWidth = JCPadButtonWidth + horizontalButtonPadding;
    CGFloat center = ([self correctWidth]/2);
    
    if (IS_IPHONE5 || IS_IPAD) {
        topRowTop += 15;
        verticalButtonPadding += 3;
    }
    
    [self.buttons enumerateObjectsUsingBlock:^(JCPadButton *btn, NSUInteger idx, BOOL *stop) {
        NSInteger row = idx / 3;
        NSInteger btnsInRow = MIN(3, count - (row * 3));
        NSInteger col = idx % 3;
        
        CGFloat top = topRowTop + (row * (btn.height+verticalButtonPadding));
        CGFloat rowWidth = (btn.width * btnsInRow) + (horizontalButtonPadding * btnsInRow-1);
        
        CGFloat left = center - (rowWidth/2) + (cellWidth*col);
        [self setUpButton:btn left:left top:top];
    }];
}

- (void)setUpButton:(UIButton *)button left:(CGFloat)left top:(CGFloat)top
{
    button.frame = CGRectMake(left, top, JCPadButtonWidth, JCPadButtonHeight);
    [button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    [self setRoundedView:button toDiameter:JCPadButtonHeight];
}

- (void)toggleDeleteButtonVisible:(BOOL)visible animated:(BOOL)animated
{
    __weak JCDialPad *weakSelf = self;
    [self performAnimations:^{
        weakSelf.deleteButton.alpha = visible;
    } animated:animated completion:^(BOOL finished) {
        weakSelf.deleteButton.hidden = !visible;
    }];
}

- (void)performAnimations:(void (^)(void))animations animated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    CGFloat length = (animated) ? animationLength : 0.0f;
    
    [UIView animateWithDuration:length delay:0.0f options:UIViewAnimationOptionCurveEaseIn
                     animations:animations
                     completion:completion];
}

#pragma mark -
#pragma mark - Orientation height helpers
- (CGFloat)correctWidth
{
	return self.contentView.bounds.size.width;
}

- (CGFloat)correctHeight
{
    return self.contentView.bounds.size.height;
}

#pragma mark -
#pragma mark -  View Methods
- (UILabel *)standardLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = self.labelColor;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (void)setRoundedView:(UIView *)roundedView toDiameter:(CGFloat)newSize;
{
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.clipsToBounds = YES;
    roundedView.layer.cornerRadius = newSize / 2.0;
}

@end