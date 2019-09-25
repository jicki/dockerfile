## 用于 jenkins slave 


* oracle-jdk  1.8_161 && 1.8.221     
```
jicki/oracle-jdk:8

jicki/java:alpine-oracle-8
```

* gradle
```
# openjdk
jicki/gradle:3.2.1
jicki/gradle:4.5
jicki/gradle:5.6



# oraclejdk

```

* maven

```
# openjdk
jicki/maven:3.6


# oraclejdk
jicki/oracle-maven:3.6
```

* slave 3.35
```
jicki/slave:gradle3.2

# 如下默认 gradle 5.6
jicki/slave:3.35

# maven oracle
jicki/slave:oracle-maven3.6
```
