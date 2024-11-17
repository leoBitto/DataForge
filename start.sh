#!/bin/bash

# Abilita il debugging per vedere cosa accade (opzionale, utile per debugging)
set -e

# Funzione per gestire errori
handle_error() {
    echo "Errore durante l'esecuzione dello script allo step: $1"
    exit 1
}

# Nome del namespace
NAMESPACE="dataforge-test"

# Step 1: Assicurarsi che MicroK8s sia attivo
echo ">> Avviando MicroK8s..."
microk8s start || handle_error "Avvio di MicroK8s"

# Step 2: Abilitare gli addon necessari
echo ">> Abilitando gli addon MicroK8s..."
microk8s enable dns || handle_error "Abilitazione addon DNS"
microk8s enable helm3 || handle_error "Abilitazione addon Helm3"
microk8s enable storage || handle_error "Abilitazione addon Storage"

# Step 3: Creare il namespace se non esiste
echo ">> Creando il namespace..."
if ! microk8s kubectl get namespace $NAMESPACE; then
    microk8s kubectl create namespace $NAMESPACE || handle_error "Creazione del namespace"
else
    echo ">> Il namespace $NAMESPACE esiste già."
fi

# Step 4: Installare PostgreSQL Silver
echo ">> Deployando PostgreSQL Silver..."
if ! microk8s helm3 install postgres-silver ./helm/postgres -n $NAMESPACE -f ./helm/postgres/values-silver.yml; then
    handle_error "Deployment di PostgreSQL Silver"
fi

# Step 5: Installare PostgreSQL Gold
echo ">> Deployando PostgreSQL Gold..."
if ! microk8s helm3 install postgres-gold ./helm/postgres -n $NAMESPACE -f ./helm/postgres/values-gold.yml; then
    handle_error "Deployment di PostgreSQL Gold"
fi

# Step 6: Installare Django
echo ">> Deployando Django..."
if ! microk8s helm3 install django ./helm/django -n $NAMESPACE; then
    handle_error "Deployment di Django"
fi

# Step 7: Verifica delle risorse
echo ">> Verifica dello stato delle risorse nel namespace $NAMESPACE..."
if ! microk8s kubectl get all -n $NAMESPACE; then
    handle_error "Verifica dello stato delle risorse"
fi

echo ">> Tutto è stato deployato correttamente!"
