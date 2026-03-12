
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
| `/bin/package_search`              | regex installed package search   |
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
sudo make install
sudo make install DESTDIR=`pwd`/_install
sudo package_init
sudo PACKAGE_OVERWRITE=y package_install package-VERSION ./_install
```

## Usage

Globally accepted environment variables, if not otherwise mention, these 
environment variables affect all commands:

- `PACKAGE_CONF` use alternate config file

### package_install

`/bin/package_install PKG DESTDIR`

Accepts 2 command-line arguements:

- `PKG` name of the package, optional may include versioning information.
- `DESTDIR` source directory of the packages install location, ie DESTDIR

This command accepts several unique environment variables for configuration:

- `PACKAGE_DB_ONLY` disables installation of files or directories, and instead 
  only caches the files in the database
- `PACAKGE_OVERWRITE` disables file's colision detection, and allows you to 
  re-install packages, overwriting the currently installed files

### package_query

`/bin/package_query DB SQL ARG...`

tldr. basic sqlite3 command but with bind/sanitization support.

Accepts 2 or more command-line arguements:

- `DB` database file to execute statement against.
- `SQL` sqlite3 statement to preform, will only execute 1 statement.
- `ARG...` 0 or more arguments to be used as bind material to properly sanitize 
  input data for the statement

This program does not respond to any global environment variables.

