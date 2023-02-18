#запускаем ресурсы
yc managed-kubernetes cluster start kube-infra
yc managed-kubernetes cluster start kube-prod
yc application-load-balancer load-balancer list
yc application-load-balancer load-balancer start <id балансировщика>

#добавление переменных окружения для команды helm enc
export SOPS_AGE_KEY_FILE=$(pwd)/key.txt
#Public key
export SOPS_AGE_RECIPIENTS=age1fh20mqtv0jh6zgvu8st2qqwfx666t5a8e3pkmwzpnfghs7s7ta0qf3d2lj

 #настройка argocd
kubectl port-forward svc/argocd-server -n argocd 8080:443

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

argocd login <адрес argocd>:443  # далее вводим логин admin и его пароль
# добавляем кластер в argocd
argocd cluster add yc-kube-prod

#создаем новый ip-адрес для балансировщика
yc vpc address create --name=apps-alb \
--labels reserved=true \
--external-ipv4 zone=ru-central1-b

#создаем сертификат
yc certificate-manager certificate request \
  --name kube-prod \
  --domains '*.apps.<домен>' \
  --challenge dns

#останавливаем ресурсы
yc managed-kubernetes cluster stop kube-infra
yc managed-kubernetes cluster stop kube-prod

yc application-load-balancer load-balancer list
yc application-load-balancer load-balancer stop <id балансировщика>

yc managed-postgresql cluster stop postgres-prod