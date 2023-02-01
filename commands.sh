yc managed-kubernetes cluster start kube-infra

kubectl port-forward svc/argocd-server -n argocd 8080:443

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

export SOPS_AGE_KEY_FILE=$(pwd)/key.txt
#Public key
export SOPS_AGE_RECIPIENTS=age1fh20mqtv0jh6zgvu8st2qqwfx666t5a8e3pkmwzpnfghs7s7ta0qf3d2lj

yc managed-kubernetes cluster stop kube-infra