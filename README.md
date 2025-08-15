# zen Slackware

This is not a regular SlackBuild. `slack-desc` does not included  and a binary output `t?z` for installation is **not** provided.
Scripts are for **x86_64 arch** and **Slackware-current**.
Use it at your own risk... no one will support you if your system break.
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

2. **zen-linux.SlackInstall** will install zen kernel-zen modules and zen headers in your system. Also it will upgrade grub and create an initrd.img <br>
If you dont use grub or dracut... you can modify fuctions in script...<br>
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
- install NVIDIA driver ;)
- run Waydroid
- have a litle faster compiling 
- and more good things...

---

### zen .config

zen .config is the stock Slackware-current config plus:
```
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_IOAM6_LWTUNNEL=y
CONFIG_IP_VS_IPV6=m
CONFIG_IPV6_SIT_6RD=m
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_PREEMPT=y
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_BINDERFS=n
CONFIG_ANDROID_BINDER_DEVICES="binder,hwbinder,vndbinder"

#CONFIG_PREEMPT_VOLUNTARY
#CONFIG_DEBUG_PREEMPT
``` 
Do not touch this^^ but feel free to remove HARDWARE drivers you dont need. <br>

`/etc/udev/rules.d/99-hwrng-symlink.rules` needed, we have /dev/hwrng but waydroid want /dev/hw_random :D<br>

If you place it after reboot then cmd:
```
sudo udevadm control --reload-rules
sudo udevadm trigger /dev/hwrng
```

---

### benchmark-latency-test

You might want to READ and ran the benchmark-latency-test.sh<br>
Please READ it first... 

---

