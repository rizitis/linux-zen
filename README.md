# zen Slackware

This is not a regular SlackBuild. slack-desc does not included  and a binary output for installation is not provided.

### HOWTO

1. **zen-linux.SlackBuild** build a complete zen kernel-modules and zen headers.
   Ran it first as regular user (no root).

2. **zen-linux.SlackInstall** will install zen kernel and zen header in your system. Also it will upgrade grub and create an initrd.gz <br>
If you dont use grub or initrd.gz etc... you can modify fuctions in script...<br>
   
  **NOTE**: You dont need to ran this script manually, zen-linux.SlackBuild will do it when its time...     <br>when zen-linux.SlackInstall ran it will ask for your root pasword (not sudo but su -c)

>
> Zen kernels must **NOT** builded in `/usr/src` or `/tmp` etc... 
> The best place is away from root (/) , the pefrect place is `/home/$USER/WorkDir`
> zen-linux.SlackBuild must executed as regular user, NOT AS ROOT, and when its time for installation in will ask for root passwd. (su)
> so all building will be in your user /home.

#### TIPS:
You can install NVIDIA driver, you can run Waydroid and more good things...

### zen .config

zen .config is the stock Slackware-current config plus:
```
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_BINDERFS=n
CONFIG_ANDROID_BINDER_DEVICES="binder,hwbinder,vndbinder" 
``` 
Do not touch this^^ but feel free to remove HARDWARE drivers or arch that you dont need.