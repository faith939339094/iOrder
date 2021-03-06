//
//  IORegisterView.h
//  iOrder
//
//  Created by 易无解 on 8/17/16.
//  Copyright © 2016 易无解. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IORegisterView;

@protocol IORegisterViewDelegate <NSObject>

- (void)registerView:(IORegisterView *)registerView registerBtnDidPressed:(UIButton *)regitserBtn;

@end

#pragma mark - interface IORegisterView

@interface IORegisterView : UIView

@property (nonatomic, weak) id<IORegisterViewDelegate> delegate;

@end

#pragma mark - interface IORegisterTextField

@interface IORegisterTextField : UITextField

@end