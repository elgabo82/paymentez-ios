// Generated by Apple Swift version 2.2 (swiftlang-703.0.18.1 clang-703.0.29)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if defined(__has_feature) && __has_feature(modules)
@import ObjectiveC;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"

SWIFT_CLASS("_TtC12PaymentezSDK13PaymentezCard")
@interface PaymentezCard : NSObject
@property (nonatomic, copy) NSString * _Nullable cardReference;
@property (nonatomic, copy) NSString * _Nullable type;
@property (nonatomic, copy) NSString * _Nullable cardHolder;
@property (nonatomic, copy) NSString * _Nullable termination;
@property (nonatomic, copy) NSString * _Nullable expiryMonth;
@property (nonatomic, copy) NSString * _Nullable expiryYear;
@property (nonatomic, copy) NSString * _Nullable bin;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC12PaymentezSDK24PaymentezDebitParameters")
@interface PaymentezDebitParameters : NSObject
@property (nonatomic, copy) NSString * _Nonnull uid;
@property (nonatomic, copy) NSString * _Nonnull cardReference;
@property (nonatomic) double productAmount;
@property (nonatomic, copy) NSString * _Nonnull productDescription;
@property (nonatomic, copy) NSString * _Nonnull devReference;
@property (nonatomic) double vat;
@property (nonatomic, copy) NSString * _Nonnull email;
@property (nonatomic) double productDiscount;
@property (nonatomic) NSInteger installments;
@property (nonatomic, copy) NSString * _Nonnull buyerFiscalNumber;
@property (nonatomic, copy) NSString * _Nonnull sellerId;
@property (nonatomic, copy) NSString * _Nonnull shippingStreet;
@property (nonatomic, copy) NSString * _Nonnull shippingHouseNumber;
@property (nonatomic, copy) NSString * _Nonnull shippingCity;
@property (nonatomic, copy) NSString * _Nonnull shippingZip;
@property (nonatomic, copy) NSString * _Nonnull shippingState;
@property (nonatomic, copy) NSString * _Nonnull shippingCountry;
@property (nonatomic, copy) NSString * _Nonnull shippingDistrict;
@property (nonatomic, copy) NSString * _Nonnull shippingAdditionalAddressInfo;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class UIViewController;
@class PaymentezSDKError;
@class PaymentezTransaction;

SWIFT_CLASS_NAMED("PaymentezSDKClient")
@interface PaymentezSDKClient : NSObject
+ (void)setEnvironment:(NSString * _Nonnull)apiCode secretKey:(NSString * _Nonnull)secretKey testMode:(BOOL)testMode;
+ (void)showAddViewControllerForUser:(NSString * _Nonnull)uid email:(NSString * _Nonnull)email presenter:(UIViewController * _Nonnull)presenter callback:(void (^ _Nonnull)(PaymentezSDKError * _Nullable, BOOL, BOOL))callback;
+ (void)addCardForUser:(NSString * _Nonnull)uid email:(NSString * _Nonnull)email expiryYear:(NSInteger)expiryYear expiryMonth:(NSInteger)expiryMonth holderName:(NSString * _Nonnull)holderName cardNumber:(NSString * _Nonnull)cardNumber cvc:(NSString * _Nonnull)cvc callback:(void (^ _Nonnull)(PaymentezSDKError * _Nullable, BOOL))callback;
+ (void)listCards:(NSString * _Null_unspecified)uid callback:(void (^ _Nonnull)(PaymentezSDKError * _Nullable, NSArray<PaymentezCard *> * _Nullable))callback;
+ (void)deleteCard:(NSString * _Nonnull)uid cardReference:(NSString * _Nonnull)cardReference callback:(void (^ _Nonnull)(PaymentezSDKError * _Nullable, BOOL))callback;
+ (void)debitCard:(PaymentezDebitParameters * _Nonnull)parameters callback:(void (^ _Nonnull)(PaymentezSDKError * _Nullable, PaymentezTransaction * _Nullable))callback;
+ (void)verifyWithCode:(NSString * _Nonnull)transactionId uid:(NSString * _Nonnull)uid verificationCode:(NSString * _Nonnull)verificationCode callback:(void (^ _Nonnull)(PaymentezSDKError * _Nullable, NSInteger, PaymentezTransaction * _Nullable))callback;
+ (void)verifyWithAmount:(NSString * _Nonnull)transactionId uid:(NSString * _Nonnull)uid amount:(double)amount callback:(void (^ _Nonnull)(PaymentezSDKError * _Nullable, NSInteger, PaymentezTransaction * _Nullable))callback;
+ (void)scanCard:(UIViewController * _Nonnull)presenterViewController callback:(void (^ _Nonnull)(BOOL, NSString * _Nullable, NSString * _Nullable, NSString * _Nullable))callback;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC12PaymentezSDK17PaymentezSDKError")
@interface PaymentezSDKError : NSObject
@property (nonatomic) NSInteger code;
@property (nonatomic, copy) NSString * _Nonnull descriptionCode;
@property (nonatomic, strong) id _Nullable details;
- (BOOL)shouldVerify;
- (NSString * _Nullable)getVerifyTrx;
@end

@class NSDate;

SWIFT_CLASS("_TtC12PaymentezSDK20PaymentezTransaction")
@interface PaymentezTransaction : NSObject
@property (nonatomic, strong) NSDate * _Nullable paymentDate;
@property (nonatomic, copy) NSString * _Nullable transactionId;
@property (nonatomic, copy) NSDictionary<NSString *, id> * _Nullable carrierData;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

#pragma clang diagnostic pop
