
# Package

Simple DESTDIR based package manager.

## Installed Files

|                                    |                                  |
|:---------------------------------- |:-------------------------------- |
| `/etc/package/package.conf`        | configuration file               |
| `/etc/package/protected_folders`   | system/unmanaged directory list  |
| `/lib/libpackage.sh`               | shared function library          |
| `/bin/package_init`                | initialize package database      |
| `/bin/package_install PKG DESTDIR` | install PacKaGe from DESTDIR     |
| `/bin/package_uninstall PKG`       | uninstall a PacKaGe              |
| `/bin/package_list`                | list installed packages          |
| `/bin/package_provides PKG`        | list files installed by PacKaGe  |
| `/bin/package_whatprovides FILE`   | to what package does FILE belong |
| `/bin/package_check`               | compare checksums against files  |
| `/bin/package_query DB SQL ARG...` | run SQL with ARG binds           |

## Build

```sh
make
sudo make install
```

## Build & Register self in Package Manager

```sh
make
make destdir.conf DESTDIR=`pwd`/_install
sudo make install DESTDIR=`pwd`/_install
sudo PACKAGE_CONF=destdir.conf ./_install/usr/local/bin/package_init
sudo PACKAGE_CONF=destdir.conf ./_install/usr/local/bin/package_install package-1.0 ./_install
```

