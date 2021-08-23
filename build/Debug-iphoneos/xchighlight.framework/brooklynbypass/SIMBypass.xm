// Honolulu
// Created by EthanRDoesMC for NovaChat

#import <Foundation/Foundation.h>
#pragma mark - Headers
@interface FTDeviceSupport : NSObject
+(id)sharedInstance;

-(NSDictionary *)telephonyCapabilities; // iPod: nil | iPhone: {...}
-(void)_updateCapabilities;

-(NSString *)deviceTypeIDPrefix; // iPod 5: U | iPhone 4s: m
-(NSString *)telephoneNumber; // nil for both

-(int)deviceType; // iPod: 3 | iPhone: 2
-(int)performanceClass; // iPod 5: 2 | iPhone 4s: -1

-(NSDictionary *)CTNetworkInformation; // nil / {...}

// [iPod / iPhone]
-(char)supportsSMS; // 0 / 1
-(char)isTelephonyDevice; // 0 / 1
-(char)faceTimeSupported; // 1
-(char)callingSupported; // 1
-(char)supportsMMS; // 0 / 1
-(char)supportsSMSIdentification; // 0 / 1
-(char)isC2KEquipment; // 0 / 1
-(char)SIMInserted; // 0 (no sim in iPhone)
-(char)nonWifiFaceTimeAvailable; // 0 / 1
-(char)callingAvailable; // 1
-(char)wantsBreakBeforeMake; // 0 / 1
-(char)supportsNonWiFiFaceTime; // 0 / 1
-(char)mmsConfigured; // (not configured yet)
-(char)supportsWLAN; // 0
-(char)supportsNonWiFiCalling; // 0 / 1
-(char)supportsCellularData; // 0 / 1
-(char)nonWifiCallingAvailable; // 0 / 1

-(void)_watchNotifyTokens;
-(void)_updateManagedConfigurationSettings;
-(void)_registerForCarrierNotifications;
-(void)_registerForCapabilityNotifications;
-(void)_registerForCoreTelephonyNotifications;
-(void)_registerForLockdownNotifications;
-(void)_registerForManagedConfigurationNotifications;
-(void)_unregisterForManagedConfigurationNotifications;
-(void)_unregisterForCoreTelephonyNotifications;
-(void)_unregisterForCarrierNotifications;
-(void)_unregisterForCommCenterReadyNotifications;
-(void)_registerForCommCenterReadyNotifications;
-(void)_registerForInternalCoreTelephonyNotifications;
-(void)_commCenterAlive;
-(void)_operatorChanged;
-(void)_carrierChanged;
-(void)_simStatusChanged:(id)arg1;
-(void)_lockdownStateChanged:(id)arg1;
-(void)carrierSettingsChanged:(id)arg1;
-(void)_handleTechnologyChange:(id)arg1;
-(void)_handlePhoneNumberRegistrationStateChanged:(id)arg1;
@end

#pragma mark - Hook
%group main
%hook FTDeviceSupport
-(char)supportsSMS {
    return NO;
} // 0 / 1
-(char)isTelephonyDevice {
    return NO;
} // 0 / 1
-(char)supportsMMS {
    return NO;
} // 0 / 1
-(char)supportsSMSIdentification {
    return NO;
} // 0 / 1
-(char)isC2KEquipment {
    return NO;
} // 0 / 1
-(char)SIMInserted {
    return NO;
} // 0 (no sim in iPhone)
-(char)nonWifiFaceTimeAvailable {
    return NO;
} // 0 / 1
-(char)callingAvailable {
    return NO;
} // 1
-(char)wantsBreakBeforeMake {
    return NO;
} // 0 / 1
-(char)supportsNonWiFiFaceTime {
    return NO;
} // 0 / 1
-(char)mmsConfigured {
    return NO;
} // (not configured yet)
-(char)supportsWLAN {
    return NO;
} // 0
-(char)supportsNonWiFiCalling {
    return NO;
} // 0 / 1
-(char)supportsCellularData {
    return NO;
} // 0 / 1
-(char)nonWifiCallingAvailable {
    return NO;
} // 0 / 1

-(NSDictionary *)telephonyCapabilities {
    return nil;
} // iPod: nil | iPhone: {...}

-(int)deviceType {
    return 3;
} // iPod: 3 | iPhone: 2

-(NSDictionary *)CTNetworkInformation {
    return nil;
} // nil / {...}
%end
%end

%ctor {
    BOOL enabled;
    NSMutableDictionary * prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.beeper.brooklynsettings.plist"];
    enabled = [prefs objectForKey:@"bypassEnabled"] ? [[prefs objectForKey:@"bypassEnabled"] boolValue] : NO;;
    if (enabled) {
        %init(main)
    }
}
