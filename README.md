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
- have a faster compiling time
- Better gaming
- and more good things...

1. Reduces scheduling latency from kernel-to-user space.
2. Main effect: snappier responsiveness, less input lag, better audio/video stability.

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
Or the precompiled rt-tests.tar.gz (required: numactl)from `https://github.com/jlelli/rt-tests` <br> because this kernel is almost a real time kernel too! ;)
```
sudo taskset -c 0-3 ./cyclictest -a -t -n -p99
# /dev/cpu_dma_latency set to 0us
policy: fifo: loadavg: 0.54 0.67 0.70 2/1779 19467          

T: 0 (19096) P:99 I:1000 C:  11434 Min:      1 Act:    1 Avg:    1 Max:     101
T: 1 (19097) P:99 I:1500 C:   7622 Min:      1 Act:    1 Avg:    1 Max:      25
T: 2 (19098) P:99 I:2000 C:   5717 Min:      1 Act:    2 Avg:    1 Max:     112
T: 3 (19099) P:99 I:2500 C:   4573 Min:      1 Act:    1 Avg:    1 Max:      24
T: 4 (19100) P:99 I:3000 C:   3811 Min:      1 Act:    1 Avg:    1 Max:      88
T: 5 (19101) P:99 I:3500 C:   3266 Min:      1 Act:    2 Avg:    1 Max:      94
T: 6 (19102) P:99 I:4000 C:   2858 Min:      1 Act:    2 Avg:    2 Max:      95
T: 7 (19103) P:99 I:4500 C:   2540 Min:      1 Act:    3 Avg:    2 Max:    2052
T: 8 (19104) P:99 I:5000 C:   2286 Min:      1 Act:    2 Avg:    2 Max:     115
T: 9 (19105) P:99 I:5500 C:   2078 Min:      1 Act:    1 Avg:    1 Max:      23
T:10 (19106) P:99 I:6000 C:   1905 Min:      1 Act:    2 Avg:    2 Max:      67
T:11 (19107) P:99 I:6500 C:   1759 Min:      1 Act:    1 Avg:    1 Max:      19
T:12 (19108) P:99 I:7000 C:   1633 Min:      1 Act:    4 Avg:    3 Max:      41
T:13 (19109) P:99 I:7500 C:   1524 Min:      1 Act:    2 Avg:    3 Max:      33
T:14 (19110) P:99 I:8000 C:   1429 Min:      1 Act:    2 Avg:    2 Max:      15
T:15 (19111) P:99 I:8500 C:   1345 Min:      1 Act:    2 Avg:    2 Max:      11
T:16 (19112) P:99 I:9000 C:   1270 Min:      1 Act:    3 Avg:    2 Max:      21
T:17 (19113) P:99 I:9500 C:   1203 Min:      1 Act:    2 Avg:    2 Max:      13
T:18 (19114) P:99 I:10000 C:   1143 Min:      1 Act:    2 Avg:    2 Max:      11
T:19 (19115) P:99 I:10500 C:   1088 Min:      1 Act:    2 Avg:    2 Max:      14
```
Command breakdown:
1. taskset -c 0-3 → pins all threads to CPU 0–3 (your DAW/real-time cores).

2. -a → test all available CPUs

3. -t → number of threads = number of CPUs

4. -n → use high-resolution timers

5. -p99 → set thread priority to FIFO 99 (highest RT priority)

Understanding the output:
1. T:0 → thread ID

2. P:99 → priority

3. I:1000 → interval (µs) between wakeups

4. C:11434 → number of cycles executed

5. Min/Act/Avg/Max → latency in microseconds:

6. Min = minimum measured latency

7. Act = actual latency observed in last cycle

8. Avg = average latency

9. Max = maximum latency

Latency analysis:
- Most threads have Max ≤ 100 µs. Excellent for audio/DAW.
- Thread 7 spikes at 2052 µs. That’s my worst-case latency.
 - Could be caused by IRQs hitting CPU0–3 (maybe NVMe or system timers).
- All other max values are well below 150 µs, which is excellent for real-time audio.

Interpretation:
- Kernel configuration + CPU isolation is mostly working.
- A few spikes (like 2 ms) are rare and may not affect DAW performance unless do very low buffer sizes (<64 samples).
- Average latency ~1–2 µs — that’s fantastic.

Conclusion:
RT setup is excellent. Cyclictest shows near-ideal latencies. <br>
Only occasional NVMe/system IRQ spikes might occasionally push max latency up,<br>
but average latency is extremely low — perfect for DAW work.
---

