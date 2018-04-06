//
//  FreeNowTests.m
//  FreeNowTests
//
//  Created by Techwin Labs 28 Dec on 30/03/17.
//  Copyright © 2017 Techwin Labs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FreeStatus.h"

@interface FreeNowTests : XCTestCase
@property (nonatomic) FreeStatus *vcToTest;

@end

@implementation FreeNowTests

- (void)setUp {
    [super setUp];
    self.vcToTest = [[FreeStatus alloc] init];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testReverseString {
//    NSString *originalString = @"himynameisandy";
//    NSString *reversedString = [self.vcToTest reverseString:originalString];
//    
//    NSString *expectedReversedString = @"ydnasiemanymih";
//    XCTAssertEqualObjects(expectedReversedString, reversedString, @"The reversed string did not match the expected reverse”);
//}

@end
