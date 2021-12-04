#  Brooklyn

## Components
### Rubicon
> "The die is cast."

Crosses Apple's last river between IMCore and the rest of the system.

### BrooklynBridge
The underlying API. Probably doesn't need to be .xm -- will look at that. Sparse for now, but will have many methods very soon

### Brooklyn.app
iMessage runtime inspection tool. Also api testing grounds.

## Build
### macOS
#### Xcode
1. Set up [theos](https://github.com/theos/theos).
2. Open brooklyn.xcodeproj.
3. Go to the brooklyn *target*, then click Build Settings
4. Change `THEOS_DEVICE_IP` to the Bonjour or IP address of the targeted device.
5. Change `THEOS` to *your full theos path.* No cheating with ~.
6. Update the directory under Targets > Brooklyn > Info from the `ethanrdoesmc` directory to the full path where your code is checked out
7. Edit the Makefile and update the IP behind `THEOS_DEVICE_IP` to the IP of your iPhone.
8. Open a terminal and type `ssh-copy-id root@`, followed by the address you set in Step 4. The default password for iOS is `alpine`. (If it gives an error, run `ssh-keygen` and spam enter, then try again.)
9. Connect a device to Xcode, select `brooklyn>(device)` in the tab bar, and click Run!

Optional code highlighting, autocomplete, error checking:
1. Set the build target to `xchighlight>Any iOS Device (armv7, arm64)` in the tab bar.
2. Press Command-B.
3. When this is done building, set the target back to `brooklyn>(device)`.
4. Every time you add a source file, go to the brooklyn xcodeproj in Xcode, click the xchighlight target, click Build Phases, and add it to the appropriate phase.

#### make
1. Set up [theos](https://github.com/theos/theos).
2. Open the makefile.
3. At the top, add: `export THEOS_DEVICE_IP = `, followed by your device's Bonjour or IP address.
4. Open a terminal to the brooklyn folder.
5. Run `ssh-copy-id root@`, followed by the address from Step 3. The default password is `alpine`. (If it gives an error, run `ssh-keygen` and spam enter, then try again.)
6. Run `make clean do`.

#### Notes
If you make changes to .xib files, make sure to commit the built .nib files in the Resources folder as well. That way, other platforms can build without Xcode. This will not be a requirement in the future. 

## Troubleshooting

```
bash: ldid: command not found
...
make[1]: *** [internal-application-all_] Error 2
make: *** [Brooklyn.all.application.variables] Error 2
Command ExternalBuildToolExecution failed with a nonzero exit code
```

Take a look at the logs above and spot the PATH variable. Most likely brew installed ldid to `/opt/homebrew/bin/ldid` but `/opt/homebrew/bin` is not part of you xcode path. You can create a link from your `/usr/local/bin` dir by running `sudo ln -s /opt/homebrew/bin/ldid /usr/local/bin/ldid` (make sure that this is your homebrew install location by running `which ldid`, `/opt/homebrew` is the default on M1 Macs)


```
dm.pl: building package `com.beeper.brooklyn:iphoneos-arm' in `./packages/com.beeper.brooklyn_0.0.1-2+debug_iphoneos-arm.deb'
open2: exec of lzma -c1 failed: No such file or directory at /Users/carl/theos/bin/dm.pl line 118.
make: *** [internal-package] Error 2
```

I wasn't able to get `lzma` to work, so I edited `vim ~/theos/makefiles/package/deb.mk` and changed `_THEOS_PLATFORM_DPKG_DEB_COMPRESSION ?= lzma` to `_THEOS_PLATFORM_DPKG_DEB_COMPRESSION ?= gzip`.

### Linux / Windows
I'll add these instructions soon. I don't have theos set up on Windows. I also don't have a Linux install yet. For shame, I know, for shame! :P
