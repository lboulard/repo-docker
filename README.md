# Run repo tool inside docker

Docker images expect that first host user created is building AOSP images.
Directory `/data` is defined as home directory.

Latest `repo` release requires Python 3.6+ on Debian testing/sid and Ubuntu 20.04+.
Docker image use Ubuntu 18.04 to fallback on Python 2.7 with latest `repo` release.


## Build and verify image

Using `repo` for python 3.6+ (note `repo` will fallback running with Python 2.7):

- Build image with `docker build --build-arg user=$USER -t android-repo:latest .`.
- Check image with `docker run --rm -it -v $HOME:/data android-repo:latest repo --version`.


## Build from AOSP source

Enter shell inside docker image:
`docker run --rm -it -v $HOME:/data android-repo:latest`.

Initialize as described here:
<https://source.android.com/setup/build/downloading>.


## Forcing usage of Python 2.7

When changing base image to latest Linux distribution that removed support for
Python 2.7, use older version of `repo`:

- Build image with `docker build --build-arg user=$USER --build-arg repo=repo-1 -f Dockerfile-20.04 -t android-repo:2.7 .`.
- Check image with `docker run --rm -it -v $HOME:/data android-repo:2.7 repo --version`.

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
And rebuild image.
