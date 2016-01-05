//
//  ViewController.m
//  AlertDemo
//
//  Created by GuoXiaoLiang on 15/12/31.
//  Copyright © 2015年 erliangzi. All rights reserved.
//

#import "ViewController.h"

#import "GJAlertController.h"
#import "GJAlertAction.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)showAlert:(UIButton *)sender {
    GJAlertController *alertVC = [GJAlertController alertControllerWithTitle:@"testTitle" message:@"testMessage" preferredStyle:GJAlertControllerStyleAlert];
    [alertVC addAction:[GJAlertAction actionWithTitle:@"ok" style:GJAlertActionStyleDefault handler:^(GJAlertAction * _Nonnull action) {
        NSLog(@"%@", action.title);
        
        for (UITextField *tempTextField in alertVC.textFields) {
            NSLog(@"---------------:%@", tempTextField.placeholder);
        }
        
    }]];
    
    [alertVC addAction:[GJAlertAction actionWithTitle:@"cancel" style:GJAlertActionStyleDefault handler:^(GJAlertAction * _Nonnull action) {
        NSLog(@"%@", action.title);
    }]];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"haha";
    }];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"huhu";
    }];
    
    [alertVC testShow];
}

- (IBAction)showActionSheet:(UIButton *)sender {
    GJAlertController *alertVC = [GJAlertController alertControllerWithTitle:@"testTitle" message:@"testMessage" preferredStyle:GJAlertControllerStyleActionSheet];
    [alertVC addAction:[GJAlertAction actionWithTitle:@"ok" style:GJAlertActionStyleDefault handler:^(GJAlertAction * _Nonnull action) {
        NSLog(@"%@", action.title);
    }]];
    [alertVC testShowActonSheet];
    
//    [alertVC addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"%@", action.title);
//    }]];
//    
//    [alertVC addAction:[UIAlertAction actionWithTitle:@"test" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"%@", action.title);
//    }]];
    
//    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
