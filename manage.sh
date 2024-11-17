#!/bin/bash

# Parametri: Namespace e modalità (start o update)
NAMESPACE="${1:-dataforge-test}"  # Default è dataforge-test se non passato come parametro
MODE="${2:-start}"  # Default è start se non passato come parametro

# Setup del logging
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_DIR="./logs"
LOG_FILE="${LOG_DIR}/${MODE}_${NAMESPACE}_${TIMESTAMP}.log"


# Crea la directory dei log se non esiste
mkdir -p $LOG_DIR

# Funzione per il logging
log_message() {
    local message="[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    echo "$message" | tee -a "$LOG_FILE"
}

# Funzione per gestire errori
handle_error() {
    log_message "ERROR: Errore durante l'esecuzione dello script allo step: $1"
    exit 1
}

build_image() {
    log_message ">> Creando l'immagine Docker per Django..."
    
    # Definisci il nome dell'immagine
    IMAGE_NAME="django-dev:latest"

    # Costruisci l'immagine Docker
    docker build -t $IMAGE_NAME ./src/django || handle_error "Creazione immagine Docker"

    # Usa un file temporaneo per salvare l'immagine
    TEMP_IMAGE_FILE=$(mktemp)
    log_message ">> Salvando l'immagine Docker in un file temporaneo..."
    docker save $IMAGE_NAME -o $TEMP_IMAGE_FILE || handle_error "Salvataggio immagine Docker"

    # Importa l'immagine in MicroK8s
    log_message ">> Importando l'immagine Docker nel registry MicroK8s..."
    microk8s ctr image import $TEMP_IMAGE_FILE || handle_error "Importazione immagine in MicroK8s"

    # Elimina il file temporaneo
    log_message ">> Pulizia del file temporaneo..."
    rm -f $TEMP_IMAGE_FILE || handle_error "Eliminazione del file temporaneo"

    # Aggiorna il file values con il nome dell'immagine
    log_message ">> Aggiornando il file values.yaml..."
    sed -i "s|your-django-image|django-dev|g" ./helm/django/values.yml || handle_error "Aggiornamento values.yaml"
}

# Funzione per creare PV e PVC
create_storage() {
    local namespace=$1
    log_message ">> Creando Persistent Volumes e Claims per Django..."

    # Applica i PV
    log_message ">> Creando Persistent Volumes..."
    microk8s kubectl apply -f ./helm/django/templates/pv.yml || handle_error "Creazione PV"

    # Applica i PVC
    log_message ">> Creando Persistent Volume Claims..."
    microk8s kubectl apply -f ./helm/django/templates/pvc.yml -n $namespace || handle_error "Creazione PVC"

    # Verifica lo stato
    log_message ">> Verificando lo stato dei PV e PVC..."
    microk8s kubectl get pv || handle_error "Verifica PV"
    microk8s kubectl get pvc -n $namespace || handle_error "Verifica PVC"
}


log_message "Namespace = $NAMESPACE"
log_message "Mode = $MODE"

# Funzione per l'avvio iniziale (start)
start_deployment() {
    log_message ">> Avviando il deployment iniziale nel namespace $NAMESPACE..."

    # Step 1: Assicurarsi che MicroK8s sia attivo
    log_message ">> Avviando MicroK8s..."
    microk8s start || handle_error "Avvio di MicroK8s"

    # Step 2: Abilitare gli addon necessari
    log_message ">> Abilitando gli addon MicroK8s..."
    microk8s enable dns || handle_error "Abilitazione addon DNS"
    microk8s enable helm3 || handle_error "Abilitazione addon Helm3"
    microk8s enable storage || handle_error "Abilitazione addon Storage"
    microk8s enable metallb 192.168.1.200-192.168.1.250 || handle_error "Abilitazione addon metallb"

    # Step 3: Creare il namespace se non esiste
    log_message ">> Creando il namespace $NAMESPACE..."
    if ! microk8s kubectl get namespace $NAMESPACE; then
        microk8s kubectl create namespace $NAMESPACE || handle_error "Creazione del namespace"
    else
        log_message ">> Il namespace $NAMESPACE esiste già."
    fi

    # Step 4: Creare PV e PVC
    create_storage $NAMESPACE

    # Step 5: Installare PostgreSQL Silver
    log_message ">> Deployando PostgreSQL Silver..."
    if ! microk8s helm3 install postgres-silver ./helm/postgres -n $NAMESPACE -f ./helm/postgres/values_silver.yml; then
        handle_error "Deployment di PostgreSQL Silver"
    fi

    # Step 6: Installare PostgreSQL Gold
    log_message ">> Deployando PostgreSQL Gold..."
    if ! microk8s helm3 install postgres-gold ./helm/postgres -n $NAMESPACE -f ./helm/postgres/values_gold.yml; then
        handle_error "Deployment di PostgreSQL Gold"
    fi

    # Step 7: Installare Django
    log_message ">> Deployando Django..."
    if ! microk8s helm3 install django ./helm/django -n $NAMESPACE -f ./helm/django/values.yml; then
        handle_error "Deployment di Django"
    fi

    # Step 8: Verifica delle risorse
    log_message ">> Verifica dello stato delle risorse nel namespace $NAMESPACE..."
    if ! microk8s kubectl get all -n $NAMESPACE; then
        handle_error "Verifica dello stato delle risorse"
    fi

    log_message ">> Tutto è stato deployato correttamente!"
}

# Funzione per l'aggiornamento (update)
update_deployment() {
    log_message ">> Eseguendo l'aggiornamento delle risorse nel namespace $NAMESPACE..."

    # Step 1: Aggiorna PV e PVC se necessario
    create_storage $NAMESPACE

    # Step 2: Verifica e upgrade di PostgreSQL Silver
    log_message ">> Aggiornando PostgreSQL Silver..."
    if microk8s helm3 list -n $NAMESPACE | grep -q "postgres-silver"; then
        microk8s helm3 upgrade postgres-silver ./helm/postgres -n $NAMESPACE -f ./helm/postgres/values_silver.yml || handle_error "Aggiornamento PostgreSQL Silver"
    else
        log_message ">> PostgreSQL Silver non trovato, eseguendo installazione..."
        microk8s helm3 install postgres-silver ./helm/postgres -n $NAMESPACE -f ./helm/postgres/values_silver.yml || handle_error "Installazione di PostgreSQL Silver"
    fi

    # Step 3: Verifica e upgrade di PostgreSQL Gold
    log_message ">> Aggiornando PostgreSQL Gold..."
    if microk8s helm3 list -n $NAMESPACE | grep -q "postgres-gold"; then
        microk8s helm3 upgrade postgres-gold ./helm/postgres -n $NAMESPACE -f ./helm/postgres/values_gold.yml || handle_error "Aggiornamento PostgreSQL Gold"
    else
        log_message ">> PostgreSQL Gold non trovato, eseguendo installazione..."
        microk8s helm3 install postgres-gold ./helm/postgres -n $NAMESPACE -f ./helm/postgres/values_gold.yml || handle_error "Installazione di PostgreSQL Gold"
    fi

    # Step 4: Aggiornamento di Django
    log_message ">> Aggiornando Django..."
    if microk8s helm3 list -n $NAMESPACE | grep -q "django"; then
        microk8s helm3 upgrade django ./helm/django -n $NAMESPACE -f ./helm/django/values.yml || handle_error "Aggiornamento Django"
    else
        log_message ">> Django non trovato, eseguendo installazione..."
        microk8s helm3 install django ./helm/django -n $NAMESPACE -f ./helm/django/values.yml || handle_error "Installazione di Django"
    fi

    log_message ">> Aggiornamento completato con successo!"
}

# Funzione per fermare e rimuovere le risorse (teardown)
stop_deployment() {
    log_message ">> Fermando e rimuovendo tutte le risorse nel namespace $NAMESPACE..."

    # Step 1: Disinstallare Django
    microk8s helm3 uninstall django -n $NAMESPACE || handle_error "Disinstallazione di Django"

    # Step 2: Disinstallare PostgreSQL Silver
    microk8s helm3 uninstall postgres-silver -n $NAMESPACE || handle_error "Disinstallazione di PostgreSQL Silver"

    # Step 3: Disinstallare PostgreSQL Gold
    microk8s helm3 uninstall postgres-gold -n $NAMESPACE || handle_error "Disinstallazione di PostgreSQL Gold"

    # Step 4: Rimuovere PVC
    log_message ">> Rimuovendo PVC..."
    microk8s kubectl delete pvc --all -n $NAMESPACE || handle_error "Rimozione PVC"

    # Step 5: Rimuovere PV
    log_message ">> Rimuovendo PV..."
    microk8s kubectl delete pv django-media-pv django-static-pv || handle_error "Rimozione PV"

    # Step 6: Eliminare il namespace
    log_message ">> Eliminando il namespace $NAMESPACE..."
    microk8s kubectl delete namespace $NAMESPACE || handle_error "Eliminazione del namespace"

    log_message ">> Tutte le risorse sono state rimosse correttamente!"
}

if [ "$MODE" == "start" ]; then
    build_image
    start_deployment
elif [ "$MODE" == "update" ]; then
    build_image
    update_deployment
elif [ "$MODE" == "stop" ]; then
    stop_deployment
else
    log_message "Utilizzo: $0 [namespace] {start|update|stop}"
    exit 1
fi