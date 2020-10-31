# Conquer the world


- Port-forward
Online-boutique
```
kubectl -n online-boutique  port-forward svc/frontend-external 8082:80
```

Kiali
```
kubectl -n istio-system port-forward svc/kiali 8080:20001
```

Grafana
```
kubectl -n istio-system  port-forward svc/grafana 8083:3000
```

Jaeger
```
kubectl -n istio-system  port-forward svc/tracing 8084:80
```

Keycloak
```
kubectl -n auth-server  port-forward svc/auth-keycloak-http 8085:80
```

```
user: user-eshop
pass: password
```

```
kubectl exec -it auth-keycloak-0 /opt/jboss/keycloak/bin/standalone.sh -Djboss.socket.binding.port-offset=100 -Dkeycloak.migration.action=export -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.realmName=sample -Dkeycloak.migration.usersExportStrategy=REALM_FILE -Dkeycloak.migration.file=/tmp/auth-server-realm.json

kubectl cp -n auth-server auth-keycloak-0:/tmp/auth-server-realm.json ./auth-server-realm.json

kubectl create secret generic auth-server-realm-secret --from-file=./auth-server-realm.json -n auth-server
```

- Verify mTLS
```
kubectl -n online-boutique exec -it deploy/adservice -c istio-proxy \
     -- openssl s_client -showcerts -connect cartservice:7070
```

- TLS for external connection
```
make create-nip.io-certs

kubectl apply -f online-boutique-ingress.yaml
```

- Gatekeeper
```
helm install gabibbo97/keycloak-gatekeeper \
    --set discoveryURL=https://auth.172.27.0.3.nip.io/auth/realms/sample \
    --set upstreamURL=http://frontend:8088 \
    --set ClientID=myOIDCClientID \
    --set ClientSecret=deadbeef-b000-1337-abcd-aaabacadaeaf \
    --set ingress.enabled=true \
    --set ingress.hosts[0]=my-svc-auth.example.com
```


- Give nodeport to ingress gateway
```
30280
```

https://online.boutique.172.27.0.3.nip.io:30280/
https://auth.172.27.0.3.nip.io:30280/