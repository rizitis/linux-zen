# zen Slackware

This is not a regular SlackBuild. `slack-desc` does not included  and a binary output `t?z` for installation is **not** provided.

### HOWTO

1. Only ran **zen-linux.SlackBuild** to build a complete zen kernel-modules and zen headers.
   *Ran it first as regular user (no root).*

2. **zen-linux.SlackInstall** will install zen kernel-zen modules and zen headers in your system. Also it will upgrade grub and create an initrd.gz <br>
If you dont use grub or initrd.gz etc... you can modify fuctions in script...<br>
- *the way zen kernel build and install slackpkg upgrade-all will not remove it on next stock kernel upgrade.*

---

  **NOTE**: You dont need to ran **zen-linux.SlackInstall** manually, **zen-linux.SlackBuild** will do it when its time and  will ask for your root pasword (not sudo but su -c) <br>
If you only want to build and then install manually everything  edit **zen-linux.SlackBuild** like this:
```
# run as root installation script.
# script_path="$CWD"/zen-linux.SlackInstall
# su -c "$script_path" -s /bin/bash
```

---

>
> Zen kernels must **NOT** builded in `/usr/src` or `/tmp` etc... 
> The best place is away from root (/) , the pefrect place is `/home/$USER/WorkDir`
> zen-linux.SlackBuild must executed as regular user, NOT AS ROOT, and when its time for installation in will ask for root passwd. (su)
> so all building will be in your user /home.

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
