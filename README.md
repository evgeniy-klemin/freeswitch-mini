# FreeSwitch с минимальной конфигурацией

> Для тестирования локально

## Настройка

Требуется только для тестирования с медиа-трафиком в сип-фоне

1. Прописать локальный ip в [./Makefile](./Makefile) в переменную `IP`
2. Прописать локальный ip в [./conf/vars.xml](./conf/vars.xml) во все переменные


## Запуск

```bash
docker-compose up
```

## Регистрация сип-фона

Для хождения media-трафика, в docker-compose.yml поменять сеть на `network_mode: host`

user=101

pass=101

ip - локальный


## Инициация вызова

```bash
make invite

```


## Консоль FreeSwitch

```bash
make fs_cli

```

## Event socket

Подключение по локальному ip на порт 8021 с паролем ClueCon

```bash

telnet <local_ip> 8021

```
