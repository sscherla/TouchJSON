//
//  CJSONDeserializer_UnitTests.m
//  TouchCode
//
//  Created by Luis de la Rosa on 8/6/08.
//  Copyright 2008 toxicsoftware.com. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "CJSONDeserializer_UnitTests.h"
#import "CJSONDeserializer.h"

@implementation CJSONDeserializer_UnitTests

static BOOL Scan(NSString *inString, id *outResult, NSDictionary *inOptions)
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
	theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;

    for (NSString *theKey in inOptions)
        {
        id theValue = [inOptions objectForKey:theKey];
        [theDeserializer setValue:theValue forKey:theKey];
        }

    NSData *theData = [inString dataUsingEncoding:NSUTF8StringEncoding];
    id theResult = [theDeserializer deserialize:theData error:NULL];

    return(theResult != NULL);
    }

#pragma mark -

// Disabled for now - this can in fact cause crashes!!!
//- (void)testInvalidDictionaries_1
//    {
//    NSString *theString = @"{ \"key\":";
//    NSData *theData = [theString dataUsingEncoding:NSUTF8StringEncoding];
//    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
//	theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;
//    NSError *theError = NULL;
//    id theDeseralizedValue = [theDeserializer deserialize:theData error:&theError];
//    STAssertNil(theDeseralizedValue, @"This test should return nil");
//    STAssertNotNil(theError, @"This test should return an error");
//    }

- (void)testInvalidDictionaries_2
    {
    NSString *theString = @"{ \"key\"•";
    NSData *theData = [theString dataUsingEncoding:NSUTF8StringEncoding];
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
	theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;
    NSError *theError = NULL;
    id theDeseralizedValue = [theDeserializer deserialize:theData error:&theError];
    STAssertNil(theDeseralizedValue, @"This test should return nil");
    STAssertNotNil(theError, @"This test should return an error");
    }

#pragma mark -

#pragma mark Old tests - these are still being reviewed for value and possibly due for clean up.

- (void)testWhitespace2
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"[ true, false ]", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    //STAssertTrue([theObject isEqual:TXPropertyList(@"(1, 0)")], @"Result of scan didn't match expectations.");
    }

- (void)testWhitespace3
    {
    id theObject = NULL;
    BOOL theResult = Scan(@"{ \"x\" : [ 1 , 2 ] }", &theObject, NULL);
    STAssertTrue(theResult, @"Scan return failure.");
    //STAssertTrue([theObject isEqual:TXPropertyList(@"{x, (1, 2)}")], @"Result of scan didn't match expectations.");
    }

#pragma mark -

- (void)testDanielPascoCode1
    {
    NSString *theSource = @"{\"status\": \"ok\", \"operation\": \"new_task\", \"task\": {\"status\": 0, \"updated_at\": {}, \"project_id\": 7179, \"dueDate\": null, \"creator_id\": 1, \"type_id\": 0, \"priority\": 1, \"id\": 37087, \"summary\": \"iPhone test\", \"description\": null, \"creationDate\": {}, \"owner_id\": 1, \"noteCount\": 0, \"commentCount\": 0}}";
	NSData *theData = [theSource dataUsingEncoding:NSUTF32BigEndianStringEncoding];
    NSDictionary *theObject = [[CJSONDeserializer deserializer] deserialize:theData error:nil];
    STAssertNotNil(theObject, @"Scan return failure.");
    }

- (void)testDanielPascoCode2
    {
    NSString *theSource = @"{\"status\": \"ok\", \"operation\": \"new_task\", \"task\": {\"status\": 0, \"project_id\": 7179, \"dueDate\": null, \"creator_id\": 1, \"type_id\": 0, \"priority\": 1, \"id\": 37087, \"summary\": \"iPhone test\", \"description\": null, \"owner_id\": 1, \"noteCount\": 0, \"commentCount\": 0}}";
	NSData *theData = [theSource dataUsingEncoding:NSUTF32BigEndianStringEncoding];
    NSDictionary *theObject = [[CJSONDeserializer deserializer] deserialize:theData error:nil];
    STAssertNotNil(theObject, @"Scan return failure.");
    }

- (void)testTomHaringtonCode1
    {
    NSString *theSource = @"{\"r\":[{\"name\":\"KEXP\",\"desc\":\"90.3 - Where The Music Matters\",\"icon\":\"\\/img\\/channels\\/radio_stream.png\",\"audiostream\":\"http:\\/\\/kexp-mp3-1.cac.washington.edu:8000\\/\",\"type\":\"radio\",\"stream\":\"fb8155000526e0abb5f8d1e02c54cb83094cffae\",\"relay\":\"r2b\"}]}";
	NSData *theData = [theSource dataUsingEncoding:NSUTF32BigEndianStringEncoding];
    NSDictionary *theObject = [[CJSONDeserializer deserializer] deserialize:theData error:nil];
    STAssertNotNil(theObject, @"Scan return failure.");
    }

#pragma mark -

- (void)testScottyCode1
    {
    // This should fail.
    NSString *theSource = @"{\"a\": [ { ] }";
	NSData *theData = [theSource dataUsingEncoding:NSUTF32BigEndianStringEncoding];
    NSDictionary *theObject = [[CJSONDeserializer deserializer] deserialize:theData error:nil];
    STAssertNil(theObject, @"Scan return failure.");
    }

- (void)testUnterminatedString
    {
    // This should fail.
    NSString *theSource = @"\"";
	NSData *theData = [theSource dataUsingEncoding:NSUTF32BigEndianStringEncoding];
    NSDictionary *theObject = [[CJSONDeserializer deserializer] deserialize:theData error:nil];
    STAssertNil(theObject, @"Scan return failure.");
    }

- (void)testGarbageCharacter
    {
    // This should fail.
    NSString *theSource = @">";
	NSData *theData = [theSource dataUsingEncoding:NSUTF32BigEndianStringEncoding];
    NSDictionary *theObject = [[CJSONDeserializer deserializer] deserialize:theData error:nil];
    STAssertNil(theObject, @"Scan return failure.");
    }

#pragma mark -

-(void)testEmptyDictionary
    {
	NSString *theSource = @"{}";
	NSData *theData = [theSource dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSDictionary *theObject = [[CJSONDeserializer deserializer] deserializeAsDictionary:theData error:nil];
	NSDictionary *dictionary = [NSDictionary dictionary];
	STAssertEqualObjects(dictionary, theObject, nil);
    }

-(void)testSingleKeyValuePair
    {
	NSString *theSource = @"{\"a\":\"b\"}";
	NSData *theData = [theSource dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSDictionary *theObject = [[CJSONDeserializer deserializer] deserializeAsDictionary:theData error:nil];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"b" forKey:@"a"];
	STAssertEqualObjects(dictionary, theObject, nil);
    }

-(void)testRootArray
    {
	NSString *theSource = @"[\"a\",\"b\",\"c\"]";
	NSData *theData = [theSource dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSArray *theObject = [[CJSONDeserializer deserializer] deserializeAsArray:theData error:nil];
	NSArray *theArray = [NSArray arrayWithObjects:@"a", @"b", @"c", NULL];
	STAssertEqualObjects(theArray, theObject, nil);
    }

-(void)testDeserializeDictionaryWithNonDictionary
    {
	NSString *emptyArrayInJSON = @"[]";
	NSData *emptyArrayInJSONAsData = [emptyArrayInJSON dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSDictionary *deserializedDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:emptyArrayInJSONAsData error:nil];
	STAssertNil(deserializedDictionary, nil);
    }

-(void)testDeserializeDictionaryWithAnEmbeddedArray
    {
	NSString *theSource = @"{\"version\":\"1.0\", \"method\":\"a_method\", \"params\":[ \"a_param\" ]}";
	NSData *theData = [theSource dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSDictionary *theObject = [[CJSONDeserializer deserializer] deserializeAsDictionary:theData error:nil];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
								@"1.0", @"version",
								@"a_method", @"method",
								[NSArray arrayWithObject:@"a_param"], @"params",
								nil];
	STAssertEqualObjects(dictionary, theObject, nil);	
    }

-(void)testDeserializeDictionaryWithAnEmbeddedArrayWithWhitespace
    {
	NSString *theSource = @"{\"version\":\"1.0\", \"method\":\"a_method\", \"params\":    [ \"a_param\" ]}";
	NSData *theData = [theSource dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSDictionary *theObject = [[CJSONDeserializer deserializer] deserializeAsDictionary:theData error:nil];
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								@"1.0", @"version",
								@"a_method", @"method",
								[NSMutableArray arrayWithObject:@"a_param"], @"params",
								nil];
	STAssertEqualObjects(dictionary, theObject, nil);	
    }


-(void)testCheckForError
    {
	NSString *jsonString = @"!";
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	STAssertNotNil(error, @"An error should be reported when deserializing a badly formed JSON string", nil);
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testCheckForErrorWithEmptyJSON
    {
	NSString *jsonString = @"";
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	STAssertNotNil(error, @"An error should be reported when deserializing a badly formed JSON string", nil);
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testCheckForErrorWithEmptyJSONAndIgnoringError
    {
	NSString *jsonString = @"";
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:nil];
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testCheckForErrorWithNilJSON
    {
	NSError *error = nil;
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:nil error:&error];
	STAssertNotNil(error, @"An error should be reported when deserializing a badly formed JSON string", nil);
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testCheckForErrorWithNilJSONAndIgnoringError
    {
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:nil error:nil];
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testNoError
    {
	NSString *jsonString = @"{}";
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	STAssertNil(error, @"No error should be reported when deserializing an empty dictionary", nil);
	STAssertNotNil(dictionary, @"Dictionary will be nil when there is not an error deserializing", nil);
    }

-(void)testCheckForError_Deprecated
    {
	NSString *jsonString = @"{!";
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
	STAssertNotNil(error, @"An error should be reported when deserializing a badly formed JSON string", nil);
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testCheckForErrorWithEmptyJSON_Deprecated
    {
	NSString *jsonString = @"";
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSError *error = nil;
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
	STAssertNotNil(error, @"An error should be reported when deserializing a badly formed JSON string", nil);
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testCheckForErrorWithEmptyJSONAndIgnoringError_Deprecated
    {
	NSString *jsonString = @"";
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserialize:jsonData error:nil];
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testCheckForErrorWithNilJSON_Deprecated
    {
	NSError *error = nil;
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserialize:nil error:&error];
	STAssertNotNil(error, @"An error should be reported when deserializing a badly formed JSON string", nil);
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testCheckForErrorWithNilJSONAndIgnoringError_Deprecated
    {
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserialize:nil error:nil];
	STAssertNil(dictionary, @"Dictionary will be nil when there is an error deserializing", nil);
    }

-(void)testSkipNullValueInArray
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    theDeserializer.nullObject = NULL;
    NSData *theData = [@"[null]" dataUsingEncoding:NSUTF8StringEncoding];
	NSArray *theArray = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theArray, [NSArray array], @"Skipping null did not produce empty array");
    }

-(void)testAlternativeNullValueInArray
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    theDeserializer.nullObject = @"foo";
    NSData *theData = [@"[null]" dataUsingEncoding:NSUTF8StringEncoding];
	NSArray *theArray = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theArray, [NSArray arrayWithObject:@"foo"], @"Skipping null did not produce array with placeholder");
    }

-(void)testDontSkipNullValueInArray
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSData *theData = [@"[null]" dataUsingEncoding:NSUTF8StringEncoding];
	NSArray *theArray = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theArray, [NSArray arrayWithObject:[NSNull null]], @"Didnt get the array we were looking for");
    }

-(void)testSkipNullValueInDictionary
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    theDeserializer.nullObject = NULL;
    NSData *theData = [@"{\"foo\":null}" dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, [NSDictionary dictionary], @"Skipping null did not produce empty dict");
    }

-(void)testMultipleRuns
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSData *theData = [@"{\"hello\":\"world\"}" dataUsingEncoding:NSUTF8StringEncoding];
	NSDictionary *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, [NSDictionary dictionaryWithObject:@"world" forKey:@"hello"], @"Dictionary did not contain expected contents");
    theData = [@"{\"goodbye\":\"cruel world\"}" dataUsingEncoding:NSUTF8StringEncoding];
	theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, [NSDictionary dictionaryWithObject:@"cruel world" forKey:@"goodbye"], @"Dictionary did not contain expected contents");
    }

//-(void)testWindowsCP1252StringEncoding
//    {
//	CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
//	NSString *jsonString = @"[\"Expos\u00E9\"]";
//	NSData *jsonData = [jsonString dataUsingEncoding:NSWindowsCP1252StringEncoding];
//	NSError *error = nil;
//	NSArray *array = [theDeserializer deserialize:jsonData error:&error];
//	STAssertNotNil(error, @"An error should be reported when deserializing a non unicode JSON string", nil);
//	STAssertEqualObjects([error domain], kJSONScannerErrorDomain, @"The error must be of the CJSONDeserializer error domain");
//	STAssertEquals([error code], (NSInteger)kJSONScannerErrorCode_CouldNotDecodeData, @"The error must be 'Invalid encoding'");
//	theDeserializer.allowedEncoding = NSWindowsCP1252StringEncoding;
//	array = [theDeserializer deserialize:jsonData error:nil];
//	STAssertEqualObjects(array, [NSArray arrayWithObject:@"Expos\u00E9"], nil);
//    }

- (void)testCloseHashes
    {
    STAssertEquals(
        [[@"0.000000,0.000000,2.000000,2.000000" dataUsingEncoding:NSUTF8StringEncoding] hash],
        [[@"2.000000,0.000000,0.000000,2.000000" dataUsingEncoding:NSUTF8StringEncoding] hash],
        @"Ohoh");

    NSData *theData = [@"[\"0.000000,0.000000,2.000000,2.000000\",\"2.000000,0.000000,0.000000,2.000000\"]" dataUsingEncoding:NSUTF8StringEncoding];

    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
	id theResult = [theDeserializer deserialize:theData error:nil];
    id theExpectedResult = @[
        @"0.000000,0.000000,2.000000,2.000000",
        @"2.000000,0.000000,0.000000,2.000000"
        ];
	STAssertEqualObjects(theResult, theExpectedResult, @"");
    }

-(void)testEscapeCodes1
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
	theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;
    NSData *theData = [@"\"\\u003c\"" dataUsingEncoding:NSASCIIStringEncoding];
	NSError *theError = NULL;
	id theResult = [theDeserializer deserialize:theData error:&theError];
	STAssertNil(theError, @"Got an error when expected none.");
	STAssertEqualObjects(theResult, @"<", @"Mismatch");
	}

-(void)testEscapeCodes2
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
	theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;
    NSData *theData = [@"\"\\u003ca href=\\\"\\\"\\u003e\"" dataUsingEncoding:NSASCIIStringEncoding];
	NSError *theError = NULL;
	id theResult = [theDeserializer deserialize:theData error:&theError];
	STAssertNil(theError, @"Got an error when expected none.");
	STAssertEqualObjects(theResult, @"<a href=\"\">", @"Mismatch");
	}

-(void)testNullEscapeCode
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
	theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;
    NSData *theData = [@"\"\\u0000\"" dataUsingEncoding:NSASCIIStringEncoding];
	NSError *theError = NULL;
	id theResult = [theDeserializer deserialize:theData error:&theError];
	STAssertNil(theError, @"Got an error when expected none.");
	STAssertEqualObjects(theResult, @"\0", @"Mismatch");
	}

-(void)testMalformedEscapeCodes0
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
	theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;
    NSData *theData = [@"\"\\u\"" dataUsingEncoding:NSASCIIStringEncoding];
	NSError *theError = NULL;
	id theResult = [theDeserializer deserialize:theData error:&theError];
	STAssertNotNil(theError, @"Expected an error!");
	STAssertNil(theResult, @"Expected a nil");
	}

-(void)testMalformedEscapeCodes1
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
	theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;
    NSData *theData = [@"\"\\u2\"" dataUsingEncoding:NSASCIIStringEncoding];
	NSError *theError = NULL;
	id theResult = [theDeserializer deserialize:theData error:&theError];
	STAssertNotNil(theError, @"Expected an error!");
	STAssertNil(theResult, @"Expected a nil");
	}

-(void)testMalformedEscapeCodes2
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
	theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;
    NSData *theData = [@"\"\\u20\"" dataUsingEncoding:NSASCIIStringEncoding];
	NSError *theError = NULL;
	id theResult = [theDeserializer deserialize:theData error:&theError];
	STAssertNotNil(theError, @"Expected an error!");
	STAssertNil(theResult, @"Expected a nil");
	}

-(void)testMalformedEscapeCodes3
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
	theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;
    NSData *theData = [@"\"\\u202\"" dataUsingEncoding:NSASCIIStringEncoding];
	NSError *theError = NULL;
	id theResult = [theDeserializer deserialize:theData error:&theError];
	STAssertNotNil(theError, @"Expected an error!");
	STAssertNil(theResult, @"Expected a nil");
	}

-(void)testSurrogatePairs
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
	theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;
    NSData *theData = [@"\"\\uD83D\\uDCA9\"" dataUsingEncoding:NSASCIIStringEncoding];
	NSError *theError = NULL;
	id theResult = [theDeserializer deserialize:theData error:&theError];
	STAssertNil(theError, @"Got an error when expected none.");
	STAssertEqualObjects([theResult decomposedStringWithCanonicalMapping], [@"💩" decomposedStringWithCanonicalMapping], @"Poop mismatch");
	}

-(void)testBrokenSurrogatePair1
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
	theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;
    NSData *theData = [@"\"\\uD83D\"" dataUsingEncoding:NSASCIIStringEncoding];
	NSError *theError = NULL;
	id theResult = [theDeserializer deserialize:theData error:&theError];
	STAssertNotNil(theError, @"Didn't get error when expected one.");
	STAssertNil(theResult, @"Poop mismatch");
	}

-(void)testBrokenSurrogatePair2
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
	theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;
    NSData *theData = [@"\"\\uDCA9\"" dataUsingEncoding:NSASCIIStringEncoding];
	NSError *theError = NULL;
	id theResult = [theDeserializer deserialize:theData error:&theError];
	STAssertNotNil(theError, @"Didn't get error when expected one.");
	STAssertNil(theResult, @"Poop mismatch");
	}

-(void)testFloats1
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
	theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;
    NSData *theData = [@"1.0" dataUsingEncoding:NSASCIIStringEncoding];
	NSError *theError = NULL;
	id theResult = [theDeserializer deserialize:theData error:&theError];
	STAssertNil(theError, @"Got an error when expected none.");
	STAssertEqualObjects(theResult, @(1.0), @"Floating point mismatch");
	}

-(void)testFloats2
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
	theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;
    NSData *theData = [@"1.1" dataUsingEncoding:NSASCIIStringEncoding];
	NSError *theError = NULL;
	id theResult = [theDeserializer deserialize:theData error:&theError];
	STAssertNil(theError, @"Got an error when expected none.");
	STAssertEqualObjects(theResult, @(1.1), @"Floating point mismatch");
	}

-(void)testFloats3
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
	theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;
    NSData *theData = [@"1.1e10" dataUsingEncoding:NSASCIIStringEncoding];
	NSError *theError = NULL;
	id theResult = [theDeserializer deserialize:theData error:&theError];
	STAssertNil(theError, @"Got an error when expected none.");
	STAssertEqualObjects(theResult, @(1.1e10), @"Floating point mismatch");
	}

-(void)testFloats4
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
	theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;
    NSData *theData = [@"1e123" dataUsingEncoding:NSASCIIStringEncoding];
	NSError *theError = NULL;
	id theResult = [theDeserializer deserialize:theData error:&theError];
	STAssertNil(theError, @"Got an error when expected none.");
	STAssertEqualObjects(theResult, @(1e123), @"Floating point mismatch");
	}

-(void)testNumbers1
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSNumber *theNumber = @(100);
    NSData *theData = [[theNumber stringValue] dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, theNumber, @"Numbers did not contain expected contents");
    }

-(void)testNumbers2
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSNumber *theNumber = @(-100);
    NSData *theData = [[theNumber stringValue] dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, theNumber, @"Numbers did not contain expected contents");
    }

-(void)testLargeNumbers
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSNumber *theNumber = @(0xFFFFFFFFFFFFFFFFULL);
    NSData *theData = [[theNumber stringValue] dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, theNumber, @"Numbers did not contain expected contents");
    }

-(void)testScientificNumbers1
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSData *theData = [@"-134e4" dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, @(-134e4), @"Numbers did not contain expected contents");
    }

-(void)testScientificNumbers2
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSData *theData = [@"-134e4" dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, @(-134e4), @"Numbers did not contain expected contents");
    }

-(void)testScientificNumbers3
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSData *theData = [@"-134e-4" dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, @(-134e-4), @"Numbers did not contain expected contents");
    }

-(void)testScientificNumbers4
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSData *theData = [@"-134E4" dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, @(-134e4), @"Numbers did not contain expected contents");
    }

-(void)testScientificNumbers5
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSData *theData = [@"-134E4" dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, @(-134e4), @"Numbers did not contain expected contents");
    }

-(void)testScientificNumbers6
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSData *theData = [@"-134E-4" dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, @(-134e-4), @"Numbers did not contain expected contents");
    }

-(void)testScientificNumbers7
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSData *theData = [@"134E4" dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, @(134e4), @"Numbers did not contain expected contents");
    }

-(void)testScientificNumbers8
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSData *theData = [@"134E4" dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, @(134e4), @"Numbers did not contain expected contents");
    }

-(void)testScientificNumbers9
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSData *theData = [@"134E-4" dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, @(134e-4), @"Numbers did not contain expected contents");
    }

-(void)testScientificNumbers10
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSData *theData = [@"134E0" dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, @(134), @"Numbers did not contain expected contents");
    }


-(void)testLargeNegativeNumbers1
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSNumber *theNumber = @(-14399073641566209LL);
    NSData *theData = [[theNumber stringValue] dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, theNumber, @"Numbers did not contain expected contents");
    }

-(void)testLargeNegativeNumbers2
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSNumber *theNumber = @(-0xFFFFFFFFFFFFFFFLL);
    NSData *theData = [[theNumber stringValue] dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, theNumber, @"Numbers did not contain expected contents");
    }

-(void)test64BitNumbers
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSData *theData = [@"9223372036854775807" dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, @(9223372036854775807ULL), @"Numbers did not contain expected contents");
    }

-(void)test65BitNumbers
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSData *theData = [@"36893488147419103232" dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, [NSDecimalNumber decimalNumberWithString:@"36893488147419103232"], @"Numbers did not contain expected contents");
    }

-(void)testLargeNegativeNumbers
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    NSString *theValue = @"-18446744073709551615";
    NSLog(@"*** %@", theValue);
    NSData *theData = [theValue dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects(theObject, [NSDecimalNumber decimalNumberWithString:theValue], @"Numbers did not contain expected contents");
    }

-(void)testUpperLimitNumbers
    {
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    // NSDecimalNumber can reliably store 38 digits...
	NSString *theValue = [@"" stringByPaddingToLength:38 withString:@"9" startingAtIndex:0];
	STAssertTrue([theValue length] == 38, @"");
    NSData *theData = [theValue dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
	STAssertEqualObjects([theObject stringValue], theValue, @"Numbers did not contain expected contents");
    }

// TODO -- disabling this test. Right now TouchJSON will overflow NSDecimalNumber - if you use JSON for numbers with mantinssas of more than 38 digits you're screwed anyway.
//-(void)testUpperLimitNumbers2
//    {
//    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
//    // NSDecimalNumber can reliably store 38 digits...
//	NSString *theValue = [@"" stringByPaddingToLength:39 withString:@"9" startingAtIndex:0];
//	STAssertTrue([theValue length] == 39, @"");
//    NSData *theData = [theValue dataUsingEncoding:NSUTF8StringEncoding];
//	NSNumber *theObject = [theDeserializer deserialize:theData error:nil];
//	STAssertEqualObjects([theObject stringValue], theValue, @"Numbers did not contain expected contents");
//    }

-(void)testBadInt
    {
    NSError *theError = NULL;
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;
	NSString *theValue = @"1-1-1-1-1";
    NSData *theData = [theValue dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:&theError];
    STAssertNil(theObject, @"Got a value when I shouldnt.");
    STAssertNotNil(theError, @"Didn't get an error.");
    }

-(void)testBadFloat
    {
    NSError *theError = NULL;
    CJSONDeserializer *theDeserializer = [CJSONDeserializer deserializer];
    theDeserializer.options |= kJSONDeserializationOptions_AllowFragments;
	NSString *theValue = @"1.1.1.1.1.";
    NSData *theData = [theValue dataUsingEncoding:NSUTF8StringEncoding];
	NSNumber *theObject = [theDeserializer deserialize:theData error:&theError];
    STAssertNil(theObject, @"Got a value when I shouldnt.");
    STAssertNotNil(theError, @"Didn't get an error.");
    }

@end

