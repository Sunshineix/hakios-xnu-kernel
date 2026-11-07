# Device: Qualcomm Technologies, Inc. Canoe MTP,dengta (pma120)

Made by `tools/new-device.py` on 2026-11-07, from the file fdt.dtb. Edit it as the port goes.

| What | Value |
|---|---|
| Board (the tree's `model`) | Qualcomm Technologies, Inc. Canoe MTP,dengta |
| Compatible | `qcom,canoe-mtp qcom,canoe qcom,canoep-mtp qcom,canoep qcom,mtp` |

## The SoC addresses

**This tree differs from the reference phone's** in 7 value(s) and lacks 6: `soc_ipa_base`, `soc_gsi_base`, `soc_ipcc`, `soc_rsc`, `soc_ipa_stream`, `soc_ipa_stream_uc`, `soc_ipa_fw`, `soc_aoss`, `soc_cmd_db`, `soc_mpss_mem`, `modem_ipa_fw_at`, `soc_smem`, `soc_pas_mpss`. Those are this phone's own addresses; `soc.args` carries them to the kernel and the run scripts add the file to the command line.

| Argument | Value | Against the reference |
|---|---|---|
| `soc_ipa_base` | `0x3e40000` | **differs from the reference** (`0x1e40000`) |
| `soc_gsi_base` | `0x3e04000` | **differs from the reference** (`0x1e04000`) |
| `soc_ipcc` | `0x1106000` | **differs from the reference** (`0x408000`) |
| `soc_aoss` | `(not found)` | **missing**: the tree has no node this was read from; see the table in devices/redwood/README.md |
| `soc_rsc` | `0x18920000` | **differs from the reference** (`0x18220000`) |
| `soc_apps_smmu` | `0x15000000` | the same as the reference |
| `soc_cmd_db` | `(not found)` | **missing**: the tree has no node this was read from; see the table in devices/redwood/README.md |
| `soc_mpss_mem` | `(not found)` | **missing**: the tree has no node this was read from; see the table in devices/redwood/README.md |
| `modem_ipa_fw_at` | `(not found)` | **missing**: the tree has no node this was read from; see the table in devices/redwood/README.md |
| `soc_smem` | `(not found)` | **missing**: the tree has no node this was read from; see the table in devices/redwood/README.md |
| `soc_imem` | `0x14600000` | the same as the reference |
| `soc_ipa_stream` | `0x4a0` | **differs from the reference** (`0x480`) |
| `soc_ipa_stream_uc` | `0x4a2` | **differs from the reference** (`0x482`) |
| `soc_pas_mpss` | `(not found)` | **missing**: the tree has no node this was read from; see the table in devices/redwood/README.md |
| `soc_pas_ipa` | `0xf` | the same as the reference |
| `soc_ipa_fw` | `ipa_fws` | **differs from the reference** (`yupik_ipa_fws`) |

`soc.args` is what `tools/soc-args.py` read out of the tree; `pull-soc.sh` makes it again from the phone on
adb. The run scripts add it to the kernel command line. Where each argument comes from in the tree:
`devices/redwood/README.md`.

## What is this phone's own

The kernel, loader and user space know nothing about a phone: addresses, interrupts, rails and firmware
come from its tree and its Android. What is written for one phone is the list below. The head of each file
says where its numbers came from; that is the map of what to rewrite.

- [ ] **UEFI**: the firmware that starts the loader: devices/redwood/uefi/ is a port of Mu-Silicium; the vendor's drivers are extracted from your own phone (uefi/README.md)
- [ ] **Display, buttons, touch**: drivers/input/hakios.input.c, hakios.buttons.c, hakios.goodix.c (the reference phone's controller; another phone has another)
- [ ] **Storage**: hakios.ufs.c and hakios.ufshc.c (UFS); a phone with eMMC needs another driver
- [ ] **CPU clocks**: hakios.cpufreq.c
- [ ] **GPU**: hakios.adreno.c (Adreno 642L here: another generation needs its own firmware and registers)
- [ ] **Wi-Fi**: hakios.wifi.c, hakios.lx.c and wifi/lx/ (the WCN6750 radio of the reference phone)
- [ ] **Audio and battery**: hakios.adsp.c, hakios.audio.c, hakios.sound.c, hakios.speaker.c, hakios.mic.c, hakios.battery.c
- [ ] **Cellular**: hakios.mpss.c, hakios.qmi.c, hakios.nas.c, hakios.ipa.c, hakios.cell.c; soc.args carries the addresses, the IPA layout is for IPA 4.11 (docs/cellular.md)
- [ ] **Haptics and cameras**: hakios.haptic.c, hakios.camera.c

## Configuration

The kernel's settings are layered the way an Android kernel's are: the common kernel, the SoC's, this phone's
(`docs/configs.md`). Two short files make this phone a configuration:

    configs/pma120.config          CONFIG_DEVICE="pma120"   and whatever is true of this phone only
    configs/pma120_defconfig       #include common_defconfig
                                   #include <the SoC's fragment: sc7280.config for the SC7280 family>
                                   #include pma120.config

Then `make pma120_defconfig`. Turn on only what this phone has been shown to do; `tools/hakios-config.py check` says what the
choice needs.

The drivers are part of the configuration too (`docs/drivers-config.md`): every one is built unless a configuration leaves it out,
and the addresses, pins and rails in each are the reference phone's. Leave out in `configs/pma120.config` what has not been
ported to this phone yet (`# CONFIG_HAKIOS_GOODIX is not set`, ...; `configs/qemu_defconfig` leaves out all of them), and put
each one back when it has been made to work here. `tools/hakios-config.py show` lists what is built in.

## Firmware

Pulled from your own phone, never committed: `devices/redwood/pull-firmware.sh`, or
`pull-firmware-root.sh` where the firmware is readable by root only. Check with `make doctor`.

## Before you open a pull request

`tools/provenance-check.py` must pass: no vendor firmware, no UEFI drivers, no Apple files in the tree.

## SM8850 (canoe) node-name differences

`tools/soc-args.py` looks for the reference platform's exact node names; this SoC names them differently. Relocated values (2026-11-07, from the phone's own tree, scripts under `X9U-iOS移植/scripts/`):

| Argument | SM8850 node | Found via |
|---|---|---|
| `soc_aoss` | `/soc/power-controller@c300000` | compatible is bare `qcom,aoss-qmp` (no SoC prefix) |
| `soc_cmd_db` | `/reserved-memory/aop_cmd_db_region@81c60000` | compatible `qcom,cmd-db` (leaf not named `cmd_db`) |
| `soc_mpss_mem` | `/reserved-memory/mpss_region@8aa00000` | leaf `mpss_region`, not `mpss` |
| `modem_ipa_fw_at` | `/reserved-memory/ipa_gsi_region@99590000` | leaf `ipa_gsi_region`, not `ipa_gsi` |
| `soc_smem` | `/reserved-memory/smem_region@81d00000` | node carries `reg` directly, no `memory-region` indirection |
| `soc_pas_mpss` | `/soc/remoteproc-mss@04080000` | TODO: no `qcom,pas-id` property; get the id from SM8850 kernel sources |

All are appended to `soc.args`. Upstream `aoss_mailbox()` could also accept the bare `qcom,aoss-qmp` compatible (candidate upstream patch).

