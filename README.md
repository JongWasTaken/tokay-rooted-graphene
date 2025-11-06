tokay-rooted-graphene
===
Fork of [rooted-graphene](https://github.com/Tiebe/rooted-graphene), modified to use [pixincreate's Magisk fork](https://github.com/pixincreate/Magisk/releases) and built only for `tokay` (Pixel 9).  
If you have another GrapheneOS-supported phone model and would like to use this project as well, open an issue and I will add it to the automatic build system.

### Installation
##### Installing the base system

I recommend installing GrapheneOS manually. Do not use the Web-Installer.

Download the [**factory image**](https://grapheneos.org/releases) and follow the [official instructions](https://grapheneos.org/install/cli)  to install GrapheneOS.

TLDR:

* Enable OEM unlocking
* Obtain latest `fastboot`
* Unlock Bootloader:
  Enable usb debugging and execute `adb reboot bootloader`, or
  > The easiest approach is to reboot the device and begin holding the volume down button until it boots up into the bootloader interface.
   ```shell
   fastboot flashing unlock
   ```
* flash factory image

  ```shell
  bsdtar xvf DEVICE_NAME-factory-VERSION.zip # tar on windows and mac
  ./flash-all.sh # or .bat on windows
  ````
* Stop after that and reboot (leave bootloader unlocked)

#### Installing a patched OTA from this repo

Once GrapheneOS is installed:

* Download the patched [OTA from releases](https://github.com/JongWasTaken/tokay-rooted-graphene/releases) with **the same version** that you just installed. 
* Obtain latest `fastboot`
* Install [avbroot](https://github.com/chenxiaolong/avbroot)
* Extract the downloaded OTA using avbroot:
    ```bash
    avbroot ota extract \
        --input /path/to/downloaded/ota.zip \
        --directory extracted \
        --fastboot
    ```
* Set this environment variable to match the extracted folder:

  For Linux/macOS:
  ```bash
  export ANDROID_PRODUCT_OUT=extracted
  ```

  For Windows (powershell):
  ```powershell
  $env:ANDROID_PRODUCT_OUT = "extracted"
  ```
  or (bat):
  ```bat
  set ANDROID_PRODUCT_OUT=extracted
  ```

* Flash the partitions using the command:
  ```bash
  fastboot flashall --skip-reboot
  ```
* Install this repo's custom AVB public key in the bootloader.
    ```bash
    fastboot reboot-bootloader
    fastboot erase avb_custom_key
    curl -s https://raw.githubusercontent.com/JongWasTaken/tokay-rooted-graphene/refs/heads/main/avb_pkmd.bin > avb_pkmd.bin
    fastboot flash avb_custom_key avb_pkmd.bin
    ```
* Sideload the OTA
  (Necessary to avoid `Device is corrupt. It can't be trusted.` error)
   1. Run `fastboot reboot recovery` to get into recovery mode
   2. You should see an android icon lying down with the text "No command".  
      Hold the power button and press the volume up button a single time to get into the recovery GUI
   3. Use volume buttons to navigate to "Apply update from ADB" and select it with the power button
   4. Like the recovery prompt says, use  
      `adb sideload <path to ota zip>`  
       to sideload the OTA
   5. After sideloading, select reboot to bootloader
* Lock the bootloader using the following command.
  This will trigger a data wipe again.
    ```bash
    fastboot flashing lock
    ```
* Confirm by pressing volume down and then power. Then reboot.
* Remember: **Do not uncheck `OEM unlocking`!** (to avoid [hard-bricking](https://github.com/chenxiaolong/avbroot/blob/v3.12.0/README.md#warnings-and-caveats))  
  That is, in Graphene's startup wizard, leave this box unticked 👇️  
  <img src="https://github.com/schnatterer/rooted-graphene/assets/1824962/6ef90b46-2070-4d08-80d4-5f4a0e749cbe" width="216" height="480" alt="Screenshot of GrapheneOS recommending to lock">  
  Note: The OTA contains [OEMUnlockOnBoot](https://github.com/chenxiaolong/OEMUnlockOnBoot), so OEM locking should be impossible.  
  Still, better safe than sorry, keep it unlocked.

#### Set up automatic OTA updates

* [Disable system updater app](https://github.com/chenxiaolong/avbroot#ota-updates).
* Open Custota app and set the OTA server URL to this: `https://jongwastaken.github.io/tokay-rooted-graphene/magisk/`

Alternatively you could do updates manually via `adb sideload`:
* reboot the device and begin holding the volume down button until it boots up into the bootloader interface
* using volume buttons, toggle to recovery. Confirm by pressing power button
* If the screen is stuck at a `No command` message, press the volume up button once while holding down the power button.
* using volume buttons, toggle to `Apply update from ADB`. Confirm by pressing power button
* `adb sideload xyz.zip`
* See also [here](https://github.com/chenxiaolong/avbroot#updates).
