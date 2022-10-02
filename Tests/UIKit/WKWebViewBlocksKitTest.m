//
//  WKWebViewBlocksKitTest.m
//  BlocksKit Unit Tests
//

@import XCTest;
@import BlocksKit.Dynamic.UIKit;

@interface WKWebViewBlocksKitTest : XCTestCase <WKNavigationDelegate>

@end

@implementation WKWebViewBlocksKitTest {
	WKWebView *_subject;
	BOOL shouldStartLoadDelegate, didStartLoadDelegate, didFinishLoadDelegate, didFinishWithErrorDelegate;
}

- (void)setUp {
	_subject = [[WKWebView alloc] initWithFrame:CGRectZero];
}

- (BOOL)webView:(WKWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WKNavigationType)navigationType {
	shouldStartLoadDelegate = YES;
	return YES;
}

- (void)webViewDidStartLoad:(WKWebView *)webView {
	didStartLoadDelegate = YES;
}

- (void)webViewDidFinishLoad:(WKWebView *)webView {
	didFinishLoadDelegate = YES;
}

- (void)webView:(WKWebView *)webView didFailLoadWithError:(NSError *)error {
	didFinishWithErrorDelegate = YES;
}

- (void)testShouldStartLoad {
	_subject.navigationDelegate = self;

	__block BOOL shouldStartLoadBlock = NO;
	_subject.bk_shouldStartLoadBlock = ^BOOL(WKWebView *view, NSURLRequest *req, WKNavigationType type) {
		shouldStartLoadBlock = YES;
		return YES;
	};

	BOOL shouldStartLoad = [_subject.bk_dynamicDelegate webView:_subject shouldStartLoadWithRequest:nil navigationType:WKNavigationTypeLinkActivated];

	XCTAssertTrue(shouldStartLoad, @"Web view is allowed to load");
	XCTAssertTrue(shouldStartLoadBlock, @"Block handler was called");
	XCTAssertTrue(shouldStartLoadDelegate, @"Delegate was called");
}

- (void)testDidStartLoad {
	_subject.navigationDelegate = self;

	__block BOOL didStartLoadBlock = NO;
	_subject.bk_didStartLoadBlock = ^(WKWebView *view) {
		didStartLoadBlock = YES;
	};

	[_subject.bk_dynamicDelegate webViewDidStartLoad:_subject];

	XCTAssertTrue(didStartLoadBlock, @"Block handler was called");
	XCTAssertTrue(didStartLoadDelegate, @"Delegate was called");
}

- (void)testDidFinishLoad {
	_subject.navigationDelegate = self;

	__block BOOL didFinishLoadBlock = NO;
	_subject.bk_didFinishLoadBlock = ^(WKWebView *view) {
		didFinishLoadBlock = YES;
	};

	[_subject.bk_dynamicDelegate webViewDidFinishLoad:_subject];

	XCTAssertTrue(didFinishLoadBlock, @"Block handler was called");
	XCTAssertTrue(didFinishLoadDelegate, @"Delegate was called");
}

- (void)testDidFinishWithError {
	_subject.navigationDelegate = self;

	__block BOOL didFinishWithErrorBlock = NO;
	_subject.bk_didFinishWithErrorBlock = ^(WKWebView *view, NSError *err) {
		didFinishWithErrorBlock = YES;
	};

	[_subject.bk_dynamicDelegate webView:_subject didFailLoadWithError:nil];

	XCTAssertTrue(didFinishWithErrorBlock, @"Block handler was called");
	XCTAssertTrue(didFinishWithErrorDelegate, @"Delegate was called");
}

@end
