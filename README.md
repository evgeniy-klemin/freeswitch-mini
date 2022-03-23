# FreeSwitch с минимальной конфигурацией

> Для тестирования локально

## Настройка

1. Прописать локальный ip в [./Makefile](./Makefile) в переменную `IP`
2. Прописать локальный ip в [./conf/vars.xml](./conf/vars.xml) в переменную `local_ip_v4`
3. Настроить параметры MRCP сервера в [./conf/freeswitch.xml](./conf/freeswitch.xml)

```XML
      <param name="server-ip" value="localhost"/> - адрес MRCP сервера
      <param name="server-port" value="8000"/> - порт MRCP сервера
      <param name="resource-location" value=""/>
      <param name="speechsynth" value="tts"/>
      <param name="speechrecog" value="asr"/>
      <param name="rtp-ip" value="192.168.88.227"/> - локальный адрес
```


## Запуск

```bash
docker-compose up
```

## Регистрация сип-фона (zoiper)

user=101
pass=101
domain=local
ip=<локальный>

Номер для проверки: 0000


## Консоль FreeSwitch

```bash
make fs_cli

```


## Инициация вызова

```bash
make invite

```

## Event socket

Подключение по локальному ip на порт 8021 с паролем ClueCon

```bash

telnet <local_ip> 8021

```
