// Rubicon
// The die is cast.
// Created by EthanRDoesMC for NovaChat


// Convince IMDaemon that all is good (we'll figure out security problems later)
// See https://github.com/andrewwiik/Tweaks/blob/master/imhack/Tweak.xm

#include <dlfcn.h>
%hook IMDaemon
-(BOOL)daemonInterface:(id)arg1 shouldGrantAccessForPID:(int)arg2 auditToken:(id)arg3 portName:(id)arg4 listenerConnection:(id)arg5 setupInfo:(id)arg6 setupResponse:(id)arg7 {
	%orig;
    return YES;
}
-(BOOL)daemonInterface:(id)arg1 shouldGrantPlugInAccessForPID:(int)arg2 auditToken:(id)arg3 portName:(id)arg4 listenerConnection:(id)arg5 setupInfo:(id)arg6 setupResponse:(id)arg7 {
	%orig;
    return YES;
}
%end

%hook UINavigationController
- (BOOL)_clipUnderlapWhileTransitioning {
return YES;
}
%end

// make IMDaemonController give out permissions like candy
%hook IMDaemonController
-(unsigned)_capabilities {
    return 17159;
    // thanks, https://iphonedevwiki.net/index.php/IMCore.framework and https://iphonedevwiki.net/index.php/ChatKit.framework
}
- (void)_setCapabilities:(unsigned int)arg1 {
    %orig(17159);
}
- (unsigned int)capabilities {
    return 17159;
}
- (unsigned int)capabilitiesForListenerID:(id)arg1 {
    return 17159;
}
%end



// Other inspiration: https://github.com/andrewwiik/Tweaks/blob/master/chatshort/Tweak.xm and https://github.com/hbang/TypeStatus

//
//%ctor {
//    dlopen("System/Library/PrivateFrameworks/IMCore.framework/IMCore", RTLD_NOW);
//    %init;
//}
