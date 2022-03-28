---
title: "Multi cluster Istio with Gloo Mesh and vCluster"
date: 2022-02-07

tags: ['k8s', 'promtail', 'prometheus', 'grafana']
author: "Antonio Berben"
---

Multi cluster Istio with Gloo Mesh and vCluster

At Solo.io we listen to the community and their needs and help on the path to meet the community and customers goals.

That drove us to create Gloo Mesh. To reduce the complexities that, as you might know, Istio has.

The intention is to make the Service Mesh easy to operate for everyone.

The challenge comes when you need to test. Gloo Mesh is a multi-cluster solution for a Service Mesh that can be installed in one cluster only (mono-cluster).

However, to test properly, you need to simulate a real scenario. Therefore, we are talking about a minimum of 3 clusters: 1 management cluster and 2 remote clusters.
