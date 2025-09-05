#!/bin/sh

# Detect total RAM in MB (leave ~10-15% for OS)
TOTAL_MEM=$(grep MemTotal /proc/meminfo | awk '{print int($2/1024)}')
JAVA_MEM=$((TOTAL_MEM * 85 / 100))  # 85% for Java

echo "Allocating ${JAVA_MEM}M to Java..."

java -Xms${JAVA_MEM}M -Xmx${JAVA_MEM}M \
  -XX:+UseG1GC \
  -XX:+ParallelRefProcEnabled \
  -XX:MaxGCPauseMillis=100 \
  -XX:+UnlockExperimentalVMOptions \
  -XX:+DisableExplicitGC \
  -XX:+AlwaysPreTouch \
  -XX:G1NewSizePercent=40 \
  -XX:G1MaxNewSizePercent=60 \
  -XX:G1HeapRegionSize=8M \
  -XX:G1ReservePercent=15 \
  -XX:G1HeapWastePercent=5 \
  -XX:G1MixedGCCountTarget=8 \
  -XX:InitiatingHeapOccupancyPercent=20 \
  -XX:G1MixedGCLiveThresholdPercent=85 \
  -XX:G1RSetUpdatingPauseTimePercent=5 \
  -XX:SurvivorRatio=8 \
  -XX:+PerfDisableSharedMem \
  -XX:MaxTenuringThreshold=1 \
  -XX:+AlwaysLockClassLoader \
  -XX:+OptimizeStringConcat \
  -XX:+UseLargePages \
  -Dcom.mojang.eula.agree=true \
  -jar paper-1.21.4.jar nogui
