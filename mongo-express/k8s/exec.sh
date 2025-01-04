#!/bin/bash

# Fungsi untuk memulai deployment (apply) dengan file YAML yang diberikan
apply() {
  echo "Applying deployment..."
  for file in "$@"; do
    if [[ -f "$file.yaml" ]]; then
      echo ""
      echo "Applying $file.yaml..."
      kubectl apply -f "$file.yaml"
    else
      echo "Error: $file.yaml not found!"
    fi
  done
  echo ""
  echo "Deployment applied successfully!"
}

# Fungsi untuk rollout deployment
rollout() {
  echo "Rolling out the deployment..."
  for file in "$@"; do
    if [[ -f "./deployment/$file.yaml" ]]; then
      echo ""
      echo "Rolling out ./deployment/$file.yaml..."
      kubectl rollout restart -f ./deployment/$file.yaml
    else
      echo "Error: ./deployment/$file.yaml not found!"
    fi
  done
  echo ""
  echo "Deployment rollout initiated!"
}

# Fungsi untuk menghentikan deployment (scale down)
stop() {
  echo "Stopping deployment..."
  for file in "$@"; do
    if [[ -f "./deployment/$file.yaml" ]]; then
      echo ""
      echo "Scaling down ./deployment/$file.yaml..."
      kubectl scale -f "./deployment/$file.yaml" --replicas=0
    else
      echo "Error: ./deployment/$file.yaml not found!"
    fi
  done
  echo ""
  echo "Deployment stopped successfully!"
}

# Fungsi untuk menghapus deployment dan resources terkait
uninstall() {
  echo "Uninstalling deployment..."
  for file in "$@"; do
    if [[ -f "./deployment$file.yaml" ]]; then
      echo ""
      echo "Deleting ./deployment/$file.yaml..."
      kubectl delete -f "./deployment/$file.yaml"
    else
      echo "Error: ./deployment/$file.yaml not found!"
    fi
  done
  echo ""
  echo "Deployment uninstalled successfully!"
}

# Memeriksa argumen yang diberikan
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 {apply|rollout|stop|uninstall} <file1.yaml> [<file2.yaml> ...]"
  exit 1
fi

# Menentukan perintah yang akan dijalankan
command=$1
shift  # Menghapus argumen pertama (command) dan menyisakan file YAML

# Menjalankan fungsi sesuai dengan argumen yang diberikan
case "$command" in
  apply)
    apply "$@"
    ;;
  rollout)
    rollout "$@"
    ;;
  stop)
    stop "$@"
    ;;
  uninstall)
    uninstall "$@"
    ;;
  *)
    echo "Usage: $0 {apply|rollout|stop|uninstall} <file1.yaml> [<file2.yaml> ...]"
    exit 1
    ;;
esac
