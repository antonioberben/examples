# Helm repo for helm chart development

Run
```
helm fetch glooe/gloo-ee --version 1.11.27 --devel  --untar --untardir .
```

Make changes in the template (like adding to the job some sleep)

Then
```
helm package gloo-ee-1.11.27
```

Then
```
helm repo index .
```

At this point you have a `.tgz` with the changed chart and an `index.yaml` file

Now let's create a server and push the chart to it
```
kubectl create deploy demo  --image nginx

kubectl expose deployment demo --port 80 --type LoadBalancer
```

Get the IP to access the nginx and assing it to a var
example: 192.168.0.2
```
nginx_ip=192.168.0.2
```

Let's push the files
```
pod=$(kubectl get po -l app=demo -ojsonpath='{.items[].metadata.name}')

kubectl cp index.yaml ${pod}:/usr/share/nginx/html/index.yaml

kubectl cp gloo-ee-1.11.27.tgz ${pod}:/usr/share/nginx/html/gloo-ee-1.11.27.tgz
```

Now add the helm repo with name `dev`
```
helm repo add dev http://${nginx_ip}

helm repo up
```

And finally you are ready to fetch:
```
helm fetch dev/gloo-ee --version 1.11.27
```

Now you can quickly make changes in the helm chart and test them.

In the case of argo, update the version every time you make a change to be sure there are no cache involved.

The argo app looks like this:
```
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: gloo-edge-oss
  namespace: argocd
  finalizers:
  - resources-finalizer.argocd.argoproj.io
spec:
  destination:
    namespace: gloo-system
    server: https://kubernetes.default.svc
  project: default
  source:
    chart: gloo-ee
    helm:
      releaseName: gloo-ee
      values: |
        # no values takes the default values.yaml
    repoURL: http://<HERE THE NGINX IP>   # <------------ CHANGE HERE!!! it can be the IP or the k8s domain demo.default.svc.cluster.local
    targetRevision: 1.11.27   # <--------- SPECIFY CHART VERSION HERE!!!
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```
