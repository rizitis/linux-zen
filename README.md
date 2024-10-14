# zen Slackware

This is not a regular SlackBuild. `slack-desc` does not included  and a binary output `t?z` for installation is **not** provided.

---

>
> Zen kernels must **NOT** builded in `/usr/src` or `/tmp` etc...
>
> The best place is away from root (/) , the pefrect place is `/home/$USER/WorkDir`
>
> zen-linux.SlackBuild must executed as regular user, NOT AS ROOT, and when its time for installation in will ask for root passwd. (su)
>
> so all building will be in your user's /home.

### HOWTO

1. Only ran **zen-linux.SlackBuild** to build a complete zen kernel-modules and zen headers.
   - *Ran it as regular user (no root).*

2. **zen-linux.SlackInstall** will install zen kernel-zen modules and zen headers in your system. Also it will upgrade grub and create an initrd.gz <br>
If you dont use grub or initrd.gz etc... you can modify fuctions in script...<br>
- *the way zen kernel is builded and installed, slackpkg upgrade-all will not remove it on next stock kernel upgrade.*

---

  **NOTE**: You dont need to ran **zen-linux.SlackInstall** manually, **zen-linux.SlackBuild** will do it when its time and  will ask for your root pasword (not sudo but su -c) <br>
But if you want only to build and then install manually everything  edit **zen-linux.SlackBuild** like this:
```
# run as root installation script.
# script_path="$CWD"/zen-linux.SlackInstall
# su -c "$script_path" -s /bin/bash
```
Also if you modify **zen-linux.SlackInstall** do not remove it from `$CWD` because it read a `.env` file which was exported from **zen-linux.SlackBuild**. 

---

#### TIPS
*the way zen slackware kernel is builded you can:*
- install NVIDIA driver
- run Waydroid
- and more good things...

---

### zen .config

zen .config is the stock Slackware-current config plus:
```
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_BINDERFS=n
CONFIG_ANDROID_BINDER_DEVICES="binder,hwbinder,vndbinder" 
``` 
Do not touch this^^ but feel free to remove HARDWARE drivers you dont need.


---
### Attention

Its **not recomended** to run a zen kernel for Intel cpu, errors like this will appear:
```
0.349305] ACPI: Skipping parse of AML opcode: OpcodeName unavailable (0x0014)
[    0.349346] ACPI BIOS Error (bug): Failure creating named object [\_SB.PC00.XHCI.RHUB.HS07._UPC], AE_ALREADY_EXISTS (20240322/dswload2-326)
[    0.349353] ACPI Error: AE_ALREADY_EXISTS, During name lookup/catalog (20240322/psobject-220)
```
```
[    6.066994] proc_thermal_pci 0000:00:04.0: error: proc_thermal_add, will continue
```
```
[    6.673855] usbhid 3-2:1.2: couldn't find an input interrupt endpoint
```
System will be very unstable. system={hardware,software}
Build a generic kernel with Slackware stock config plus [this](https://github.com/rizitis/linux-zen/tree/main#zen-config) for Wayndorid etc...
