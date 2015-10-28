//
//  ViewController.m
//  PopupViewDemo
//
//  Created by Nick's Creative Studio on 10/28/15.
//  Copyright © 2015 Nick's Creative Studio. All rights reserved.
//

#import "ViewController.h"
#import "PopupView.h"

@interface ViewController ()

@property (nonatomic) PopupView *popup;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/2 - 20, 200, 40)];
    [button setTitle:@"Click me for a popup!" forState:UIControlStateNormal];
    [button setTitleColor:button.tintColor forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button addTarget:self action:@selector(showPopup:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    self.popup = [[PopupView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/2 - 20 - 100, 200, 100)];

    self.popup.arrowDirection = Down;
    self.popup.arrowSize = 10.0f;
    self.popup.arrowPosition = 90.0f;
    self.popup.borderWidth = 2.0f;
    self.popup.cornerRadius = 10.0f;
    self.popup.layer.hidden = YES;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.popup.frame.size.width, self.popup.frame.size.height)];
    label.text = @"I'm a popup!";
    label.textAlignment = NSTextAlignmentCenter;
    [self.popup addSubview:label];

    [self.view addSubview:self.popup];
}

- (IBAction)showPopup:(id)sender {
    self.popup.layer.hidden = !self.popup.layer.hidden;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
