#import "UserActivity.h"
@import CoreSpotlight;
@import MapKit;

@implementation UserActivity

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(
  createActivity:(NSString *)activityType
  isEligibleForSearch:(BOOL)isEligibleForSearch
  isEligibleForPrediction:(BOOL) isEligibleForPrediction
  isEligibleForPublicIndexing:(BOOL)isEligibleForPublicIndexing
  isEligibleForHandoff:(BOOL)isEligibleForHandoff
           title:(NSString *)title
           persistentIdentifier:(NSString *)persistentIdentifier
      webpageURL:(NSString *)webpageURL
        userInfo:(NSDictionary *)userInfo
    locationInfo:(NSDictionary *)locationInfo
supportsNavigation:(BOOL)supportsNavigation
supportsPhoneCall:(BOOL)supportsPhoneCall
      phoneNumber:(NSString *)phoneNumber
      description:(NSString *)description
     thumbnailURL:(NSString *)thumbnailURL
       identifier:(NSString *)identifier
)
{
  // Your implementation here
  if([NSUserActivity class] && [NSUserActivity instancesRespondToSelector:@selector(setEligibleForSearch:)]){

    if(!self.lastUserActivities) {
      self.lastUserActivities = [@[] mutableCopy];
    }

    NSUserActivity* activity = [[NSUserActivity alloc] initWithActivityType:activityType];

    activity.eligibleForSearch = isEligibleForSearch;
    activity.eligibleForPublicIndexing = isEligibleForPublicIndexing;
    activity.eligibleForHandoff = isEligibleForHandoff;

    activity.title = title;
    activity.webpageURL = [NSURL URLWithString:webpageURL];
    activity.userInfo = userInfo;

    #ifdef __IPHONE_12_0
        if (@available(iOS 12.0, *)) {
            activity.eligibleForPrediction = isEligibleForPrediction;
            activity.persistentIdentifier = persistentIdentifier;
        }
    #endif

    activity.keywords = [NSSet setWithArray:@[title]];

    if ([CSSearchableItemAttributeSet class]) {
        CSSearchableItemAttributeSet *contentSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:activityType];
        contentSet.title = title;
        contentSet.URL = [NSURL URLWithString:webpageURL];
        if (description) {
            contentSet.contentDescription = description;
        }
        if (thumbnailURL) {
            contentSet.thumbnailURL = [NSURL fileURLWithPath:thumbnailURL];
        }
        if (identifier) {
            contentSet.identifier = identifier;
        }
        if (phoneNumber) {
            contentSet.phoneNumbers = @[phoneNumber];
        }
        contentSet.supportsNavigation = @(supportsNavigation);
        contentSet.supportsPhoneCall = @(supportsPhoneCall);
        activity.contentAttributeSet = contentSet;
    }

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    if ([activity respondsToSelector:@selector(mapItem)] && [locationInfo objectForKey:@"lat"] && [locationInfo objectForKey:@"lon"]) {
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake([locationInfo[@"lat"] doubleValue], [locationInfo[@"lon"] doubleValue])];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        mapItem.name = title;
        mapItem.url = [NSURL URLWithString:webpageURL];
        activity.mapItem = mapItem;
    }
#endif

    self.lastUserActivity = activity;
    [self.lastUserActivities addObject:activity];
    [activity becomeCurrent];

    if (self.lastUserActivities.count > 5) {
      [self.lastUserActivities removeObjectAtIndex:0];
    }
  }
}

@end
