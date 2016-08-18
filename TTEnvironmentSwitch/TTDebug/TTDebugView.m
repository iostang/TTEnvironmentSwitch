//
//  TTDebugView.m
//  TTEnvironmentSwitch
//
//  Created by TangChi on 16/8/8.
//  Copyright © 2016年 tangchi. All rights reserved.
//

#import "TTDebugView.h"
#import "AppDelegate.h"
#import "TTHUDView.h"
#import <objc/runtime.h>

#define PADDING     0
#define kSize_ButtonSize                       ((CGSize){64,44})

#define kFont_ButtonTitleLabelFont             ([UIFont systemFontOfSize:14])
#define kColor_ButtonTitleLabelColor           ([UIColor whiteColor])
#define kColor_DisColor                        ([UIColor colorWithRed:52.0f/255.0f green:54.0f/255.0f blue:69.0f/255.0f alpha:1.0])
#define kColor_DevColor                        ([UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:65.0f/255.0f alpha:0.8])


@interface TTDebugModel ()

@end

@implementation TTDebugModel


+ (TTDebugModel *)configDebugModelWithIP:(NSString *)IP
                                    type:(NSInteger)type {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    TTDebugModel *model = [TTDebugModel new];
    model.tt_kIP          = IP;
    model.tt_kCurrentType = type;
    
    [ud setInteger:model.tt_kCurrentType forKey:kCurrentType];
    [ud synchronize];
    
    return model;
}

@end

@interface TTDebugView ()

@property (nonatomic, strong) UIButton *btnLocal;
@property (nonatomic, strong) UIButton *btnDevelop;
@property (nonatomic, strong) UIButton *btnDistribution;

@end

@implementation TTDebugView

#pragma mark - init && config

/** init */
- (instancetype)init {
    self = [super init];
    if (self) {
    
        self.clipsToBounds = YES;
        self.layer.cornerRadius = kSize_ButtonSize.height / 2.0f;
        
        [self setupViews];
        
    }
    return self;
}

/** 设置UI */
- (void)setupViews {
    
    UIWindow *window =  [[[UIApplication sharedApplication]delegate] window];
    
    [self setDragEnable:YES];
    [self setAdsorbEnable:YES];
    [self configButtonEnable:NO];
    [self addTarget:self action:@selector(debugAction:) forControlEvents:UIControlEventTouchUpInside];
    [window insertSubview:self atIndex:window.subviews.count];
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(window).offset(CGRectGetHeight(window.bounds)/2.0-kSize_ButtonSize.height/2.0);
        make.left.mas_equalTo(window).offset(PADDING);
        make.size.mas_equalTo((CGSize){kSize_ButtonSize.width-20,kSize_ButtonSize.height});
    }];
    
    [self defaultLayout];
    
    [self configButtonFromUserDefault];
    
    
}

/** 设置默认状态 */
- (void)configButtonFromUserDefault {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    TTDebugType type = [ud integerForKey:kCurrentType];
    switch (type) {
        case TTDebugTypeWithDevelop: {
            [self configButtonState:self.btnDevelop];
            break;
        }
        case TTDebugTypeWithDistribution: {
            [self configButtonState:self.btnDistribution];
            break;
        }
        case TTDebugTypeWithLocal: {
            [self configButtonState:self.btnLocal];
            break;
        }
        default: {
            [self configButtonState:self.btnDevelop];
            break;
        }
        
    }

}

/** 设置button点击状态 */
- (void)configButtonEnable:(BOOL)enable {
    self.btnDevelop.enabled = enable;
    self.btnDistribution.enabled = enable;
    self.btnLocal.enabled = enable;
}

/** 设置button颜色及显示状态*/
- (void)configButtonState:(UIButton *)button {
    
    if (button == self.btnDevelop) {
        
        self.btnDevelop.backgroundColor      = kColor_DisColor;
        self.btnDistribution.backgroundColor = kColor_DevColor;
        self.btnLocal.backgroundColor        = kColor_DevColor;
        
    } else if (button == self.btnDistribution) {
        
        self.btnDevelop.backgroundColor      = kColor_DevColor;
        self.btnDistribution.backgroundColor = kColor_DisColor;
        self.btnLocal.backgroundColor        = kColor_DevColor;
        
    } else if (button == self.btnLocal) {
        
        self.btnDevelop.backgroundColor      = kColor_DevColor;
        self.btnDistribution.backgroundColor = kColor_DevColor;
        self.btnLocal.backgroundColor        = kColor_DisColor;
    }
    
    if (button != self) {
        
        [self bringSubviewToFront:button];
    }
}

#pragma mark - layout

/** 默认布局 */
- (void)defaultLayout {
  
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo((CGSize){kSize_ButtonSize.width-20,kSize_ButtonSize.height});
    }];
    
    [@[self.btnDevelop, self.btnDistribution, self.btnLocal] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

/** 横向布局 */
- (void)horizontalLayout {
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo((CGSize){kSize_ButtonSize.width * 3.0f,kSize_ButtonSize.height});
    }];
    
    [self.btnDevelop mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(kSize_ButtonSize.width);
    }];
    
    [self.btnDistribution mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(kSize_ButtonSize.width);
        make.left.mas_equalTo(self.btnDevelop.mas_right);
    }];
    
    [self.btnLocal mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(kSize_ButtonSize.width);
    }];
}

#pragma mark - Action
/** 展开Button */
- (void)debugAction:(UIButton *)button {
    
    if (button.selected) {
        [self configButtonEnable:NO];
        [self defaultLayout];
        
    } else {
        [self configButtonEnable:YES];
        [self horizontalLayout];
    }

    button.selected = !button.selected;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

/** dev 点击事件 */
- (void)devAction:(UIButton *)button {
    
    [self configDebugModelWithType:TTDebugTypeWithDistribution IP:kIP toast:@"已切换为开发模式" button:button];
}

/** dis 点击事件 */
- (void)disAction:(UIButton *)button {
    
    [self configDebugModelWithType:TTDebugTypeWithDistribution IP:kIP_Dis toast:@"已切换为生产模式" button:button];
}

/** local 点击事件 */
- (void)localAction:(UIButton *)button {
    
    [self configDebugModelWithType:TTDebugTypeWithLocal IP:kIP_Local toast:@"已切换为本地模式" button:button];
    
}

/** 配置DebugModel */
- (void)configDebugModelWithType:(TTDebugType)type
                              IP:(NSString *)IP
                           toast:(NSString *)toast
                          button:(UIButton *)button {
    
    [self debugAction:self];
    
    [self configButtonState:button];
    
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    delegate.debugModel   = [TTDebugModel configDebugModelWithIP:IP type:type];
    
    UIWindow *window =  [[[UIApplication sharedApplication]delegate] window];
    [TTHUDView showHUDToViewBottom:window message:toast];
    
    float marginLeft = self.frame.origin.x;
    float marginRight = self.superview.frame.size.width - self.frame.origin.x - self.frame.size.width;
    
    CGFloat x = marginLeft<marginRight?PADDING:self.superview.frame.size.width -self.frame.size.width-PADDING;
    
   [self mas_remakeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo(x);
       make.top.mas_equalTo(self.frame.origin.y);
       make.size.mas_equalTo(self.bounds.size);
   }];
       
   [UIView animateWithDuration:0.25 animations:^{
       [self layoutIfNeeded];
   }];
    
}

#pragma mark - lazy load

- (UIButton *)btnDevelop {
    if (!_btnDevelop) {
        _btnDevelop = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"开发" forState:UIControlStateNormal];
            [btn setTitleColor:kColor_ButtonTitleLabelColor forState:UIControlStateNormal];
            btn.titleLabel.font = kFont_ButtonTitleLabelFont;
            [btn addTarget:self action:@selector(devAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            btn;
        });
    }
    return _btnDevelop;
}

- (UIButton *)btnDistribution {
    if (!_btnDistribution) {
        _btnDistribution = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"生产" forState:UIControlStateNormal];
            [btn setTitleColor:kColor_ButtonTitleLabelColor forState:UIControlStateNormal];
            btn.titleLabel.font = kFont_ButtonTitleLabelFont;
            [btn addTarget:self action:@selector(disAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            btn;
        });
    }
    return _btnDistribution;
}

- (UIButton *)btnLocal {
    if (!_btnLocal) {
        _btnLocal = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:@"本地" forState:UIControlStateNormal];
            [btn setTitleColor:kColor_ButtonTitleLabelColor forState:UIControlStateNormal];
            btn.titleLabel.font = kFont_ButtonTitleLabelFont;
            [btn addTarget:self action:@selector(localAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            btn;
        });
    }
    return _btnLocal;
}


@end

#pragma mark - DragButton
//感谢 https://github.com/Aster0id/DragButtonDemo.git
#define Nav_HEIGHT  64+10
#define Tab_HEIGHT  49-10

static void *DragEnableKey   = &DragEnableKey;
static void *AdsorbEnableKey = &AdsorbEnableKey;

CGPoint beginPoint;

@implementation UIButton (DragCategory)

-(void)setDragEnable:(BOOL)dragEnable {
    objc_setAssociatedObject(self, DragEnableKey,@(dragEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isDragEnable {
    return [objc_getAssociatedObject(self, DragEnableKey) boolValue];
}

-(void)setAdsorbEnable:(BOOL)adsorbEnable {
    objc_setAssociatedObject(self, AdsorbEnableKey,@(adsorbEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(BOOL)isAdsorbEnable {
    return [objc_getAssociatedObject(self, AdsorbEnableKey) boolValue];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.highlighted = YES;
    if (![objc_getAssociatedObject(self, DragEnableKey) boolValue]) {
        [super touchesBegan:touches withEvent:event];
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    beginPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.highlighted = NO;
    if (![objc_getAssociatedObject(self, DragEnableKey) boolValue]) {
        [super touchesMoved:touches withEvent:event];
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.highlighted) {
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
        self.highlighted = NO;
    }
    
    if (self.superview && [objc_getAssociatedObject(self,AdsorbEnableKey) boolValue] ) {
        
        float marginLeft = self.frame.origin.x;
        float marginRight = self.superview.frame.size.width - self.frame.origin.x - self.frame.size.width;
        float marginTop = self.frame.origin.y;
        float marginBottom = self.superview.frame.size.height - self.frame.origin.y - self.frame.size.height;
        
        CGFloat x = marginLeft<marginRight?PADDING:self.superview.frame.size.width -self.frame.size.width-PADDING;
        
        if (marginTop<60) {
            
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(x);
                make.top.mas_equalTo(PADDING+Nav_HEIGHT);
                make.size.mas_equalTo(self.bounds.size);
            }];
            
        } else if (marginBottom<60) {
            
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(x);
                make.size.mas_equalTo(self.bounds.size);
                make.top.mas_equalTo(self.superview.frame.size.height - self.frame.size.height-PADDING-Tab_HEIGHT);
            }];
            
        } else {

            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(x);
                make.size.mas_equalTo(self.bounds.size);
                make.top.mas_equalTo(self.frame.origin.y);
            }];
        }
    
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
        }];
        
    }
}

@end
