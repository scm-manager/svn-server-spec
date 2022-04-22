# Tests for SVNKit patched for SCM-Manager


## Preparations to run SVNKit

Create a file `~/.gradle/gradle.properties` with this content:

```
scmMavenRepoUsername=
scmMavenRepoPassword=
```

Build the patched SVNKit version:

```
./gradlew build -xtest -xjavadoc
```

Start the SVNKit dav server:

```
./gradlew svnkit-dav:serveDav
```

## Run tests in this repo

Run tests:

```
export SVNKITMQ=/path/to/svnkit
./run.sh
```

On the first request for a passwort for your username, simply press <enter>. Then set username and password to `admin`.
