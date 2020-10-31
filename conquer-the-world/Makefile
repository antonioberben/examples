create-nip.io-certs:
	rm -rf /tmp/certs/*
	mkdir -p /tmp/certs
	# Root certificate
	openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=pan-net/CN=nip.io' -keyout /tmp/certs/papi-mesh.nip.io.key -out /tmp/certs/papi-mesh.nip.io.crt
	# certificate and a private key for *.nip.io
	openssl req -out /tmp/certs/papi-mesh.all.nip.io.csr -newkey rsa:2048 -nodes -keyout /tmp/certs/papi-mesh.all.nip.io.key -subj '/O=pan-net/CN=*.nip.io'
	openssl x509 -req -days 365 -CA /tmp/certs/papi-mesh.nip.io.crt -CAkey /tmp/certs/papi-mesh.nip.io.key -set_serial 0 -in /tmp/certs/papi-mesh.all.nip.io.csr -out /tmp/certs/papi-mesh.all.nip.io.crt
	# apply certs
	kubectl create -n istio-system secret tls istio-ingressgateway-certs --key /tmp/certs/papi-mesh.all.nip.io.key --cert /tmp/certs/papi-mesh.all.nip.io.crt

create-keycloak:
	kubectl create ns auth-server
	kubectl label namespace auth-server istio-injection=enabled
	helm3 install auth codecentric/keycloak --namespace auth-server -f auth-server-values.yaml