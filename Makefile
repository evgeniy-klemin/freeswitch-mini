IP=192.168.255.138

up:
	docker-compose up

fs_cli:
	docker-compose exec freeswitch fs_cli -H ${IP}

invite:
	docker-compose exec freeswitch-mini fs_cli -H ${IP} -x "originate user/101@${IP} 'playback:background.wav,hangup' inline"
