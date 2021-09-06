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

    $ tools/container.sh


Commit with generated website is created in `developer.fedoraproject.org` directory.


## Changes overview for ML purposes

After you've done building the website, and reviewing the commit, you can use `email.sh` or `links.sh` script to get the links list of changed files.

The `email.sh` script uses `developer.fedoraproject.org` latest pushed commit on `origin/release`, or `origin/master` branch with `-s`, respectively. This output is more detailed (includes Markdown files changes), but needs the changes pushed to `origin` remote.

Example:

    $ tools/email.sh -s

_ _ _ _

Alternatively, you can use `links.sh`, which uses `content` repository to get list of changed files in comparison to specified commit. You need to specify the latest released `content` commit (ideally). It uses current state (actual commit) of `content` repository to diff to. The purpose of this script is to work around large commits, which change all files.

Example:

    $ tools/links.sh -s de3274559907af5e25377717be58e2305801986c

_ _ _ _

For both, there's option `-s` to get changes for staging website/repository.
