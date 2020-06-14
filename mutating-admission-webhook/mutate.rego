package system

mutate = {
  "apiVersion": "admission.k8s.io/v1beta1",
  "kind": "AdmissionReview",
  "response": {
    "allowed": true,
    "patchType": "JSONPatch",
    "patch": base64url.encode(json.marshal(patch)),
  },
}

patch = [{
  "op": "add",
  "path": "/spec/hostNetwork",
  "value": true,
}]
