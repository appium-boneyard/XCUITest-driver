//
//  Copyright (c) 2014-2015 Apple Inc. All rights reserved.
//

#import <XCTest/XCTestDefines.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#import <XCTest/XCUIElementAttributes.h>
#import <XCTest/XCUIElementTypeQueryProvider.h>

NS_ASSUME_NONNULL_BEGIN

#if XCT_UI_TESTING_AVAILABLE

NS_ENUM_AVAILABLE(10_11, 9_0)
typedef NS_OPTIONS(NSUInteger, XCUIKeyModifierFlags) {
    XCUIKeyModifierNone       = 0,
    XCUIKeyModifierAlphaShift = (1UL << 0),
    XCUIKeyModifierShift      = (1UL << 1),
    XCUIKeyModifierControl    = (1UL << 2),
    XCUIKeyModifierAlternate  = (1UL << 3),
    XCUIKeyModifierOption     = XCUIKeyModifierAlternate,
    XCUIKeyModifierCommand    = (1UL << 4),
};

@class XCUIElementQuery;

/*!
 * @class XCUIElement (/seealso XCUIElementAttributes)
 * Elements are objects encapsulating the information needed to dynamically locate a user interface
 * element in an application. Elements are described in terms of queries /seealso XCUIElementQuery.
 */
NS_CLASS_AVAILABLE(10_11, 9_0)
@interface XCUIElement : NSObject <XCUIElementAttributes, XCUIElementTypeQueryProvider>

/*! Test to determine if the element exists. */
@property (readonly) BOOL exists;

/*! Returns a query for all descendants of the element matching the specified type. */
- (XCUIElementQuery *)descendantsMatchingType:(XCUIElementType)type;

/*! Returns a query for direct children of the element matching the specified type. */
- (XCUIElementQuery *)childrenMatchingType:(XCUIElementType)type;

/*!
 @discussion
 Provides debugging information about the element. The data in the string will vary based on the
 time at which it is captured, but it may include any of the following as well as additional data:
    • Values for the elements attributes.
    • The entire tree of descendants rooted at the element.
    • The element's query.
 This data should be used for debugging only - depending on any of the data as part of a test is unsupported.
 */
@property (readonly, copy) NSString *debugDescription;

@end

#pragma mark - Event Synthesis

/*!
 * @category Events
 * Events that can be synthesized relative to an XCUIElement object. When an event API is called, the element
 * will be resolved. If zero or multiple matches are found, an error will be raised.
 */
@interface XCUIElement (XCUIElementEventSynthesis)

#if TARGET_OS_IPHONE

/*!
 * Sends a tap event to the center coordinate of the element.
 */
- (void)tap;

/*!
 * Sends a double tap event to the center coordinate of the element.
 */
- (void)doubleTap;

/*!
 * Sends a two finger tap event to the center coordinate of the element.
 */
- (void)twoFingerTap;

/*!
 * Sends a long press gesture to the element, holding for the specified duration.
 *
 * @param duration
 * Duration in seconds.
 */
- (void)pressForDuration:(NSTimeInterval)duration;

/*!
 * Initiates a press-and-hold gesture that then drags to another element, suitable for table cell reordering and similar operations.
 * @param duration
 * Duration of the initial press-and-hold.
 * @param otherElement
 * The element to finish the drag gesture over. In the example of table cell reordering, this would be the reorder element of the destination row.
 */
- (void)pressForDuration:(NSTimeInterval)duration thenDragToElement:(XCUIElement *)otherElement;

/*!
 * Sends a swipe-up gesture.
 */
- (void)swipeUp;

/*!
 * Sends a swipe-down gesture.
 */
- (void)swipeDown;

/*!
 * Sends a swipe-left gesture.
 */
- (void)swipeLeft;

/*!
 * Sends a swipe-right gesture.
 */
- (void)swipeRight;

/*!
 * Types a string into the element. The element or a descendant must
 * have keyboard focus; otherwise, an error is raised.
 */
- (void)typeText:(NSString *)text;

#else

/*!
 * Moves the cursor over the element.
 */
- (void)hover;

/*!
 * Sends a click event to the center coordinate of the element.
 */
- (void)click;

/*!
 * Sends a double click event to the center coordinate of the element.
 */
- (void)doubleClick;

/*!
 * Sends a right click event to the center coordinate of the element.
 */
- (void)rightClick;

/*!
 * Clicks and holds for a specified duration (generally long enough to start a drag operation) then drags
 * to the other element.
 */
- (void)clickForDuration:(NSTimeInterval)duration thenDragToElement:(XCUIElement *)otherElement;

/*!
 * Hold modifier keys while the given block runs. This method pushes and pops the modifiers as global state
 * without need for reference to a particular element. Inside the block, elements can be clicked on, dragged
 * from, typed into, etc.
 */
+ (void)performWithKeyModifiers:(XCUIKeyModifierFlags)flags block:(void (^)(void))block;

/*!
 * Types a string into the element. The element or a descendant must
 * have keyboard focus; otherwise, an error is raised.
 */
- (void)typeText:(NSString *)text;

/*!
 Types a single key with the specified modifier flags. Although `key` is a string, it must represent a single key on a physical keyboard; 
 strings that resolve to multiple keys will raise an error at runtime.
 */
- (void)typeKey:(NSString *)key modifierFlags:(XCUIKeyModifierFlags)flags;

/*!
 * Scroll the view the specified pixels, x and y.
 */
- (void)scrollByDeltaX:(CGFloat)deltaX deltaY:(CGFloat)deltaY;

#endif

@end

#endif

NS_ASSUME_NONNULL_END
