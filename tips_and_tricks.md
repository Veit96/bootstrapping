---
title: Tips and Tricks concerning Linux
author: Veit Karpf
date: \today
---


# Often used Commands

## rsync

```bash
rsync [OPTIONS] SOURCE(S) DESTINATION
```

**Option** | **What is does**
--- | ---
-a | -r (recursive) and preserves symbolic links, owners and mods.
-v | shows all steps that are being done
-P | --progress (shows progress while transfer) and --partial (resume transfer after cancellation)
--delete | deletes files that are on destination but no longer on source
-n | dry run, same as '-dry-run'

## diff

```bash
diff -qr dir1 dir2
```

**Options:**
-r, recursively compare subdirectories
-q, report only when different


# Installation of specific programs

## MATLAB

- Installation:

    Matlab downloads into `/tmp` directory. This directory is limited in size.
    Therefore the download may fail or halt due to no more space being available,
    although there's plenty of space on the disk.

    The following forum [post](https://unix.stackexchange.com/questions/470538/matlab-installer-runs-out-of-space)
    gives the solution to the problem:

    > If the installer doesn't honor the `TMP` or `TMPDIR` environment variables, as @thrig pointed out in their answer, and the `/tmp` partition / ramdisk by itself is too small, then simply mount something else on it:

    > `mkdir "$HOME/matlabdl"`

    > `mount --bind -o nonempty "$HOME/matlabdl" /tmp`

    > Contrary to a normal mount, a `--bind` mount takes an existing directory and mounts it at a different place, i.e. instead of downloading into the ramdisk that normally is at `/tmp` the download actually goes into `$HOME/matlabdl` in this case. `-o nonempty` makes sure that the mount takes place even if `/tmp` is not empty, as would normally be required.

    > After the installation completes, unmount /tmp again:

    > `umount /tmp`

    > This will make the ramdisk visible again. In case some process is still using your overridden /tmp, look for which one it is with tools like `lsof`.

- Adding toolboxes after installation:

    Run normal installer again and check the wanted boxes.

