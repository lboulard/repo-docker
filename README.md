# Run repo tool inside docker

Docker images to run `repo` in different software configurations.

## Docker images

Use `make` to create Docker images.

| Make target | Docker image | Description |
| --- | --- | --- |
| image         | android-build:latest  | Latest `repo` run on Python 2.7 on Ubuntu 18.04 |
| image-2.7     | android-build:2.7     | Old `repo` run on Python 2.7 on Ubuntu 20.04 |
| image-testing | android-build:testing | Latest `repo` run on Python 3.8 on Debian testing |
| image-trusty  | android-build:trusty  | Latest `repo` run on Python 2.7 on Ubuntu 14.04 |

Image `android-build:latest` run `repo` with last known Ubuntu LTS known to
support it.

Images `android-build:testing` and `android-build:trusty` match official
software requirements from Google for AOSP master build
(<https://source.android.com/setup/build/initializing#setting-up-a-linux-build-environment>).

Image `android-build:2.7` use repo version referenced on this page to force
Python 2.7 on latest Ubuntu LTS:
<https://source.android.com/setup/build/downloading#old-repo-python2>

## Create containers for building AOSP images

Use `make` to enter your home directory with container created from Docker image.

| Make target | Docker image |
| --- | --- |
| run         | android-build:latest  |
| run-2.7     | android-build:2.7     |
| run-testing | android-build:testing |
| run-trusty  | android-build:trusty  |

For example, run `make run-trusty` to enter an environment that use Ubunt
Trusty to build AOSP images.

Once in container, if required, initialize a new build as described here:
<https://source.android.com/setup/build/downloading>.


## Update integrated repo binary

To fetch latest version of `repo` that require Python 3.6+:

```sh
curl https://storage.googleapis.com/git-repo-downloads/repo > repo
chmod a+x repo
```

To fetch latest version of `repo` that support Python 2.7:

```sh
curl https://storage.googleapis.com/git-repo-downloads/repo-1 > repo-1
chmod a+x repo-1
```
And rebuild images.
