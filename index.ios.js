/**
 * @providesModule UserActivity
 * @flow
 */
'use strict';
import {
  NativeModules,
  Platform,
} from 'react-native';

var NativeUserActivity = NativeModules.UserActivity;

/**
 * High-level docs for the UserActivity iOS API can be written here.
 */

 export type ActivityOptions = {
   activityType: string,
   isEligibleForSearch: boolean,
   isEligibleForPublicIndexing?: boolean,
   isEligibleForHandoff?: boolean,
   isEligibleForPrediction: boolean,
   title: string,
   persistentIdentifier: string,
   webpageURL?: string,
   userInfo: any,
   locationInfo?: any,
   supportsNavigation?: boolean,
   supportsPhoneCall?: boolean,
   phoneNumber?: string,
   description?: string,
   thumbnailURL?: string,
   identifier?: string
 };

 const MIN_IOS_VERSION = 12;

var UserActivity = {
  createActivity: function (options: ActivityOptions) {
    const majorVersionIOS = parseInt(Platform.Version, 10);
    if (majorVersionIOS <= MIN_IOS_VERSION) {
      NativeUserActivity.createActivity(
        options.activityType,
        options.isEligibleForSearch,
        options.isEligibleForPrediction,
        options.isEligibleForPublicIndexing || false,
        options.isEligibleForHandoff || false,
        options.title,
        options.persistentIdentifier,
        options.webpageURL,
        options.userInfo,
        options.locationInfo,
        options.supportsNavigation || false,
        options.supportsPhoneCall || false,
        options.phoneNumber,
        options.description,
        options.thumbnailURL,
        options.identifier
      );
    }
  },
};

export default UserActivity;
