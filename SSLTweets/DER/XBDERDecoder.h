//
//  XBDERDecoder.h
//  SSLTweets
//
//  Created by Andrew Snare on 4/12/2011.
//  Copyright (c) 2011 Xebia Nederland B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

enum derIdentifierClass
{
    derIdentifierUniversalClass = 0x00,
    derIdentifierApplicationClass = 0x40,
    derIdentifierContextSpecificClass = 0x80,
    derIdentifierPrivateClass = 0xc0,

    derIdentifierInvalidClass = -1,
};

enum derIdentifierPC
{
    derIdentifierPrimitive = 0x00,
    derIdentifierConstructed = 0x20,

    derIdentifierInvalidPC = derIdentifierInvalidClass,
};

enum derIdentifierUniversalTagNumber
{
    derIdentifierUniversalSequence = 0x10,
};

@interface XBDERDecoder : NSObject

- (id)initWithData:(NSData *)data;

@property (copy, nonatomic, readonly) NSData *data;
@property (assign, nonatomic, readonly) enum derIdentifierClass derIdentifierClass;
@property (assign, nonatomic, readonly) enum derIdentifierPC derIdentifierPrimitiveOrConstructed;
@property (strong, nonatomic, readonly) NSNumber *derIdentifierTag;
@property (copy, nonatomic, readonly) NSData *derContent;
@property (copy, nonatomic, readonly) NSArray *nestedContent;

@end

@interface XBDERDecoder (Diagnostics)

- (void)dumpHierarchy;

@end

@interface NSData (X509)

- (NSData *)dataForX509CertificateSubjectPublicKeyInfo;

@end
