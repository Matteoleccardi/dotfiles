# komorebi: Fedora KDE Plasma + NVIDIA 940MX setup guide

Machine: Acer Aspire E 15 E5-575G-58UZ
Graphics: Intel HD Graphics 620 (drives the display) + NVIDIA GeForce 940MX, 2 GB VRAM (used on demand)
Verified working on: Fedora KDE Plasma 44, Plasma **Wayland** session, NVIDIA driver 580.178.04 (October 2026)

Versions and package names change over time. If something below no longer matches, check the RPM Fusion NVIDIA howto and the Fedora Discussion forum before improvising.

---

## 0. The one thing to remember

The 940MX is a **Maxwell** GPU. On Fedora 44 that means:

| Driver package | Use it? | Why |
|---|---|---|
| `akmod-nvidia-580xx` | **Yes** | The legacy branch for Maxwell and Pascal. It supports GBM, so it works on Wayland. |
| `akmod-nvidia` (current, 595+) | **No** | Dropped Maxwell. The driver fails to load and the system falls back to nouveau. |
| `akmod-nvidia-470xx` | **No** | It is meant for the older Kepler generation. It runs the card but has no GBM support, so Wayland is nearly unusable and games land on llvmpipe. It only worked on an X11 session. |

The 580 series is NVIDIA's last branch for Maxwell. It will eventually stop getting updates, so check before every Fedora version upgrade (see section 9).

---

## 1. Update the system

```
sudo dnf upgrade --refresh
sudo reboot
```

## 2. Enable the full RPM Fusion repositories

The legacy 580xx packages are **not** in the NVIDIA-only repo that comes with Fedora. You need the full free and nonfree repos.

```
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
```

## 3. Secure Boot check

```
mokutil --sb-state
```

- **Disabled**: nothing to do.
- **Enabled**: the NVIDIA kernel module must be signed with a key you enroll. This is the standard RPM Fusion procedure. Do it **before** installing the driver:
  ```
  sudo dnf install kmodtool akmods mokutil openssl
  sudo kmodgenca -a
  sudo mokutil --import /etc/pki/akmods/certs/public_key.der
  sudo reboot
  ```
  At the blue MOK screen choose Enroll MOK and enter the password you set. (Alternative: disable Secure Boot in the BIOS.)

## 4. Install the driver

If the current driver (`akmod-nvidia`) is installed, remove it first:

```
sudo dnf remove xorg-x11-drv-nvidia akmod-nvidia
```

If the old 470 driver is installed:

```
sudo dnf remove 'xorg-x11-drv-nvidia-470xx*' 'akmod-nvidia-470xx*' 'kmod-nvidia-470xx*'
```

Install the 580xx driver:

```
sudo dnf install akmod-nvidia-580xx xorg-x11-drv-nvidia-580xx xorg-x11-drv-nvidia-580xx-cuda
```

The `-cuda` package provides `nvidia-smi` and the CUDA library that Python frameworks need.

**Wait about 5 minutes** for the kernel module to build in the background. Do not reboot until this prints a version starting with 580:

```
modinfo -F version nvidia
```

If it errors, wait and retry, then run `sudo akmods --force`. Build logs are in `/var/cache/akmods/nvidia-580xx/.last.log` and `/var/log/akmods/akmods.log`.

Then reboot.

## 5. Verify the driver (on the normal Plasma Wayland session)

```
echo $XDG_SESSION_TYPE                           # should print: wayland
nvidia-smi                                       # should show 580.x
cat /sys/module/nvidia_drm/parameters/modeset    # should print: Y
```

- `nvidia-smi` prints "CUDA Version: 13.0". That is just the highest CUDA version the driver supports, not something installed. Older CUDA builds run fine on it.
- If `modeset` prints `N`:
  ```
  sudo grubby --update-kernel=ALL --args="nvidia-drm.modeset=1"
  sudo reboot
  ```

## 6. How GPU selection works (hybrid laptop)

The desktop runs on the **Intel** chip, and apps use Intel by default. NVIDIA only works when you ask for it, and it sits idle (state P8) otherwise, which is good for battery life.

Ways to run an app on NVIDIA:
- KDE menu: right-click the app and choose **Run Using Discrete Graphics Card**.
- Terminal: `switcherooctl launch <app>`
- Environment variables: `__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia <app>`

Check which GPU an app gets:

```
sudo dnf install glx-utils
glxinfo | grep "OpenGL renderer"
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia glxinfo | grep "OpenGL renderer"
```

The first should print Mesa Intel HD Graphics 620 and the second NVIDIA GeForce 940MX.

## 7. Flatpak apps and the NVIDIA runtime

Flatpak apps are sandboxed and cannot see the system driver. They need an NVIDIA runtime whose version matches the system driver **exactly**.

```
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak update
flatpak list | grep nvidia
```

`flatpak update` normally installs the matching runtime by itself (for driver 580.178.04 it installed `org.freedesktop.Platform.GL.nvidia-580-178-04`; dots become dashes). Remove old ones with:

```
flatpak uninstall --unused
```

**After every NVIDIA driver update, run `flatpak update`.** If Flathub does not yet have the runtime for your new driver version, Flatpak apps lose NVIDIA acceleration until it appears.

## 8. Minecraft (Prism Launcher)

```
flatpak install flathub org.prismlauncher.PrismLauncher
```

1. Open Prism and add the Microsoft account that owns Minecraft Java Edition.
2. **Add Instance** -> **Custom** -> name it, pick the latest **Release** version. Loader **None** is vanilla. Choose **Fabric** if you want mods.
3. Instance **Settings -> Performance**: tick **Use discrete GPU** (if there is an "Override global settings" checkbox at the top of the page, tick it first). **Do not** add the `__NV_PRIME_RENDER_OFFLOAD` or `__GLX_VENDOR_LIBRARY_NAME` variables. The checkbox handles it.
4. Launch the game, press **F3**, and check the renderer line on the right. It should say NVIDIA GeForce 940MX. If it says `llvmpipe`, the game is rendering on the CPU. If it says Intel, the discrete GPU is not being used.
5. Memory: **Settings -> Java -> Maximum memory allocation**. Check your total with `free -h`. Never allocate more than about half of it. Around 3 to 4 GB is plenty for vanilla on an 8 GB machine.
6. With only 2 GB of VRAM, skip shaders for now. Install **Fabric API**, **Sodium** and **Lithium** (Modrinth, through the instance's mod download button). In Video Settings use render distance 6 to 8, Graphics: Fast, Clouds off.

If F3 shows `llvmpipe`: first check that `flatpak list | grep nvidia` shows a runtime matching `nvidia-smi`'s driver version, then fully close and reopen Prism.

## 9. Video tools (mpv, ffmpeg)

Fedora ships `ffmpeg-free`, which lacks some codecs and NVIDIA support. Use the full build from RPM Fusion:

```
sudo dnf swap ffmpeg-free ffmpeg --allowerasing
```

Suggested tests (these were run on the older X11 setup, so re-check them on Wayland). Keep `watch -n 1 nvidia-smi` open in another terminal and look for the process in its list:

```
mpv --hwdec=auto video.mp4                          # Shift+I shows the active decoder
switcherooctl launch mpv --hwdec=nvdec video.mp4    # force NVIDIA
ffmpeg -hwaccel cuda -i video.mp4 -f null -         # NVDEC decoding test
```

Notes:
- The Intel HD 620 handles more modern codecs (HEVC, VP9) in hardware than the 940MX, which is an early Maxwell chip. For everyday video playback, Intel is probably the better choice. For Intel hardware decoding install `intel-media-driver` and `libva-utils` (RPM Fusion), then test with `vainfo`.
- `ffplay` is a poor test of hardware decoding. Use mpv.

## 10. Python / PyTorch (CUDA)

The 940MX has compute capability 5.0 (Maxwell), and **recent PyTorch builds no longer include it**:
- The default PyPI wheels use CUDA 13.0, which does not support GPUs older than Turing.
- CUDA 12.6 builds are the last ones covering Maxwell. As of the September 2026 notice, PyTorch 2.14 is the last release shipping CUDA 12.x wheels.

So use a virtual environment and the CUDA 12.6 index, and do not upgrade past 2.14:

```
python3 -m venv ~/venvs/torch
source ~/venvs/torch/bin/activate
pip install torch --index-url https://download.pytorch.org/whl/cu126
```

Never run a plain `pip install -U torch` in this environment, because it can pull the CUDA 13 build, which has no code for this GPU.

Test:

```
python -c "import torch; print(torch.__version__, torch.version.cuda, torch.cuda.is_available()); print(torch.cuda.get_device_name(0), torch.cuda.get_device_capability(0))"
python -c "import torch; x = torch.rand(1000, 1000, device='cuda'); print((x @ x).sum())"
```

- `is_available()` should be `True` and the capability `(5, 0)`.
- The error "no kernel image is available for execution on the device" means that PyTorch build has no Maxwell code. Use the cu126 build above.
- If you ever install the CUDA toolkit (for `nvcc`), stay on a 12.x version, since 13.x cannot target Maxwell.
- 2 GB of VRAM is enough for learning and small experiments, not for large models.

## 11. Maintenance and troubleshooting

**Before upgrading Fedora to a new version** (for example 44 -> 45): check that `akmod-nvidia-580xx` exists for the new release (`dnf list --available akmod-nvidia-580xx` after enabling the new repos), and read the RPM Fusion and Fedora announcements. The 580 branch is end-of-line for this GPU, so a future Fedora release may stop building it.

**After kernel updates**: `akmods` rebuilds the module automatically on the next boot. If a boot ends up on nouveau or software rendering, run:

```
modinfo -F version nvidia
sudo akmods --force
```

then check the log files listed in section 4.

**Fallbacks, in order**:
1. Plasma **X11** session: `sudo dnf install plasma-workspace-x11`, then pick Plasma (X11) in the session menu on the login screen. It is not needed with driver 580, but it is a safe fallback.
2. Intel graphics only. This works fine for desktop use and light games, especially with Sodium. NVIDIA just stays idle.

## Quick checklist

1. `sudo dnf upgrade --refresh`, reboot
2. Enable RPM Fusion free and nonfree
3. Secure Boot: check, enroll the key if enabled
4. `sudo dnf install akmod-nvidia-580xx xorg-x11-drv-nvidia-580xx xorg-x11-drv-nvidia-580xx-cuda`
5. Wait for `modinfo -F version nvidia` to print 580.x, then reboot
6. Verify with `nvidia-smi` and `modeset` = `Y`, on a Wayland session
7. `flatpak update`, confirm the matching NVIDIA runtime
8. Prism: Use discrete GPU, F3 shows the 940MX
9. PyTorch: cu126 build, version 2.14 or older
