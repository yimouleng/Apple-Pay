//
//  ViewController.m
//  Apple Pay
//
//  Created by Eli on 16/5/27.
//  Copyright © 2016年 Ely. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1.是否支持Apple Pay
    if (![PKPaymentAuthorizationViewController canMakePayments])
    {
        NSLog(@"不支持Apple Pay");
        // 判断是否添加了银行卡
    }else if(![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay]])
    {
        //跳转到添加银行卡
        PKPaymentButton * btn = [PKPaymentButton buttonWithType:PKPaymentButtonTypeSetUp style:PKPaymentButtonStyleWhiteOutline];
        btn.frame  = CGRectMake(100, 100, 100, 20);
        [btn addTarget:self  action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }else
    {
        //创建购买按钮
        PKPaymentButton * btn = [PKPaymentButton buttonWithType:PKPaymentButtonTypeBuy style:PKPaymentButtonStyleBlack];
        btn.frame  = CGRectMake(100, 100, 100, 20);
        [btn addTarget:self  action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}
//跳转添加银行卡页面
-(void)jump
{
    PKPassLibrary * pl = [[PKPassLibrary alloc]init];
    [pl openPaymentSetup];
    NSLog(@"跳转设置界面");
}
//购买
-(void)buy
{
    NSLog(@"开始购买");
    //1.创建支付请求
    PKPaymentRequest * request = [[PKPaymentRequest alloc]init];
    //2.配置商家ID
    request.merchantIdentifier = @"yimouelng.com";
    //3.配置货币代码和国家代码
    request.countryCode = @"CN";
    request.currencyCode = @"CNY";
    //4.配置请求支持的支付网络
    request.supportedNetworks = @[PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
    //5.配置处理方式
    request.merchantCapabilities = PKMerchantCapability3DS;
    //6.配置购买的商品列表 注意支付列表最后一个代表总和 注意名称和价钱
    NSDecimalNumber * num = [NSDecimalNumber decimalNumberWithString:@"998"];
    PKPaymentSummaryItem * item = [PKPaymentSummaryItem summaryItemWithLabel:@"商品" amount:num];
    request.paymentSummaryItems  = @[item];
    
    
    //附加选项 --------
    request.requiredBillingAddressFields = PKAddressFieldAll;//添加收货地址
    request.requiredShippingAddressFields = PKAddressFieldAll;//运输地址
    
    //添加快递
     NSDecimalNumber * num2 = [NSDecimalNumber decimalNumberWithString:@"998"];
    PKShippingMethod * method = [PKShippingMethod summaryItemWithLabel:@"顺丰" amount:num2];
    method.identifier =@"sf";
    method.detail = @"货到付款";//备注
    request.shippingMethods =@[method];
    
    
    request.applicationData = [@"id = 1" dataUsingEncoding:NSUTF8StringEncoding];//添加附加数据
    
    //7.验证用户的支付请求并跳转支付页面
    PKPaymentAuthorizationViewController * auth = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:request];
    [self presentViewController:auth animated:YES completion:nil];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
