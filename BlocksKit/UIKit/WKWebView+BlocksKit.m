//
//  WKWebView+BlocksKit.m
//  BlocksKit
//

#import "WKWebView+BlocksKit.h"
#import "A2DynamicDelegate.h"
#import "NSObject+A2DynamicDelegate.h"
#import "NSObject+A2BlockDelegate.h"
#import <WebKit/WebKit.h>

#pragma mark Custom delegate

@interface A2DynamicWKWebViewDelegate : A2DynamicDelegate <WKNavigationDelegate>
@end

@implementation A2DynamicWKWebViewDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    BOOL ret = YES;
    
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(webView:decidePolicyForNavigationAction:decisionHandler:)])
        ret = YES;

    BOOL (^block)(WKWebView *, NSURLRequest *, WKNavigationType) = [self blockImplementationForMethod:_cmd];
    if (block)
        ret &= block(webView, navigationAction.request, navigationAction.navigationType);

    decisionHandler(ret ? WKNavigationActionPolicyAllow : WKNavigationActionPolicyCancel);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(webViewDidStartLoad:)])
        [realDelegate webView:webView didStartProvisionalNavigation:navigation];

    void (^block)(WKWebView *) = [self blockImplementationForMethod:_cmd];
    if (block) block(webView);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(webViewDidFinishLoad:)])
        [realDelegate webView:webView didFinishNavigation:navigation];

    void (^block)(WKWebView *) = [self blockImplementationForMethod:_cmd];
    if (block) block(webView);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    id realDelegate = self.realDelegate;
    if (realDelegate && [realDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)])
        [realDelegate webView:webView didFailNavigation:navigation withError:error];

    void (^block)(WKWebView *, NSError *) = [self blockImplementationForMethod:_cmd];
    if (block) block(webView, error);
}

@end

#pragma mark Category

@implementation WKWebView (BlocksKit)

@dynamic bk_shouldStartLoadBlock, bk_didStartLoadBlock, bk_didFinishLoadBlock, bk_didFinishWithErrorBlock;

+ (void)load
{
	@autoreleasepool {
		[self bk_registerDynamicDelegate];
		[self bk_linkDelegateMethods:@{
			@"bk_shouldStartLoadBlock": @"webView:shouldStartLoadWithRequest:navigationType:",
			@"bk_didStartLoadBlock": @"webViewDidStartLoad:",
			@"bk_didFinishLoadBlock": @"webViewDidFinishLoad:",
			@"bk_didFinishWithErrorBlock": @"webView:didFailLoadWithError:"
		}];
	}
}

@end
