# Tools and scripts for Fedora Developer Portal.

For building website, and website maintenance.

Expects the following structure:

```
.
├── developer.fedoraproject.org
├── tools
└── website
```

## Basic usage

Check the usage for any script with:

    $ tools/common.sh -h

## Building website

Latest way to build the website is using the container:

```
$ tools/container.sh
```

## Changes overview

To get links with changed files, run:

```
$ tools/links.sh -s de3274559907af5e25377717be58e2305801986c
```
 - `-s` for staging
 - and commit to diff to.

Alternatively, there's `email.sh` script that uses `developer.fedoraproject.org` (latest commit only), and is more accurate/detailed (i.e. includes whitespace changes).
