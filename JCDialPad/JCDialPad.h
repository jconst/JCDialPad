
@class JCDialPad, JCPadButton;

@protocol JCDialPadDelegate <NSObject>

@optional
- (BOOL)dialPad:(JCDialPad *)dialPad shouldInsertText:(NSString *)text forButtonPress:(JCPadButton *)button;

@end

@interface JCDialPad : UIView

@property (nonatomic, strong) UIColor *labelColor UI_APPEARANCE_SELECTOR;

@property (strong, nonatomic, readonly) NSString *rawText;
@property (nonatomic) BOOL formatTextToPhoneNumber;

@property (nonatomic, strong) UIView* backgroundView;

@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UITextField *digitsTextField;

@property (weak, nonatomic) id<JCDialPadDelegate> delegate;

/**
 Standard cell phone buttons: 0-9, # and * buttons
 */
+ (NSArray *)defaultButtons;

- (id)initWithFrame:(CGRect)frame buttons:(NSArray *)buttons;

@end