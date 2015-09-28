//
//  UICKeyChainStore.h
//  UICKeyChainStore
//
//  Created by Kishikawa Katsumi on 11/11/20.
//  Copyright (c) 2011 Kishikawa Katsumi. All rights reserved.
//


#import <Foundation/Foundation.h>



//errSecSuccess                               = 0,       /* No error. */
//errSecUnimplemented                         = -4,      /* Function or operation not implemented. */
//errSecIO                                    = -36,     /*I/O error (bummers)*/
//errSecOpWr                                  = -49,     /*file already open with with write permission*/
//errSecParam                                 = -50,     /* One or more parameters passed to a function where not valid. */
//errSecAllocate                              = -108,    /* Failed to allocate memory. */
//errSecUserCanceled                          = -128,    /* User canceled the operation. */
//errSecBadReq                                = -909,    /* Bad parameter or invalid state for operation. */
//errSecInternalComponent                     = -2070,
//errSecNotAvailable                          = -25291,  /* No keychain is available. You may need to restart your computer. */
//errSecDuplicateItem                         = -25299,  /* The specified item already exists in the keychain. */
//errSecItemNotFound                          = -25300,  /* The specified item could not be found in the keychain. */
//errSecInteractionNotAllowed                 = -25308,  /* User interaction is not allowed. */
//errSecDecode                                = -26275,  /* Unable to decode the provided data. */
//errSecAuthFailed                            = -25293,  /* The user name or passphrase you entered is not correct. */




@interface UICKeyChainStore : NSObject

@property (nonatomic, readonly) NSString *service;
@property (nonatomic, readonly) NSString *accessGroup;

+ (NSString *)stringForKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service;
+ (NSString *)stringForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key;
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service;
+ (BOOL)setString:(NSString *)value forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

+ (NSData *)dataForKey:(NSString *)key;
+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service;
+ (NSData *)dataForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key;
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service;
+ (BOOL)setData:(NSData *)data forKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;

+ (BOOL)removeItemForKey:(NSString *)key;
+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service;
+ (BOOL)removeItemForKey:(NSString *)key service:(NSString *)service accessGroup:(NSString *)accessGroup;
+ (BOOL)removeAllItems;
+ (BOOL)removeAllItemsForService:(NSString *)service;
+ (BOOL)removeAllItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup;

+ (UICKeyChainStore *)keyChainStore;
+ (UICKeyChainStore *)keyChainStoreWithService:(NSString *)service;
+ (UICKeyChainStore *)keyChainStoreWithService:(NSString *)service accessGroup:(NSString *)accessGroup;
- (id)init;
- (id)initWithService:(NSString *)service;
- (id)initWithService:(NSString *)service accessGroup:(NSString *)accessGroup;

- (void)setString:(NSString *)string forKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;

- (void)setData:(NSData *)data forKey:(NSString *)key;
- (NSData *)dataForKey:(NSString *)key;

- (void)removeItemForKey:(NSString *)key;
- (void)removeAllItems;

- (void)synchronize;

@end
