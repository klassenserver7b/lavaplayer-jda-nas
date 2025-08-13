[latest-version]: https://img.shields.io/github/v/tag/whya5448/lavaplayer-jda-nas

![latest-version]

# JDA-NAS - JDA Native Audio System

JDA-NAS is an alternative to JDA's built-in audio packet sending system. It keeps a buffer of audio packets in native
code and also sends them from there. This way it is unaffected by GC pauses shorter than the duration of the buffer (
400ms by default) and gets rid of stuttering caused by those.

#### Maven package

Replace `x.y.z.m` with the latest version number

* Repository: https://jitpack.io
* Artifact: **com.github.klassenserver7b.lavaplayer-jda-nas:jda-nas:x.y.z.m**

Using in Gradle:

```groovy
repositories {
    maven {
        url 'https://jitpack.io'
    }
}

dependencies {
    implementation 'com.github.klassenserver7b.lavaplayer-jda-nas:jda-nas:x.y.z.m'
}
```

Using in Maven:

```xml
<repositories>
    <repository>
        <id>jitpack.io</id>
        <url>https://jitpack.io</url>
    </repository>
</repositories>

<dependency>
    <groupId>com.github.klassenserver7b.lavaplayer-jda-nas:jda-nas</groupId>
    <artifactId>jda-nas</artifactId>
    <version>x.y.z.m</version>
</dependency>
```

## Usage

Using it is as simple as just calling calling this on a JDABuilder:

```java
.setAudioSendFactory(new NativeAudioSendFactory())
```

For example:

```java
new JDABuilder(AccountType.BOT)
        .setToken(System.getProperty("botToken"))
        .setAudioSendFactory(new NativeAudioSendFactory())
        .buildBlocking()
```

## Supported platforms

As it includes a native library, it is only supported on a specific set of platforms currently:

* Windows (x86 and x64)
* Linux (x86 and x64, glibc >= 2.15)
