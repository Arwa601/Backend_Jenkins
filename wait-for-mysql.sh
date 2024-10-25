#!/bin/sh

# Attendre que MySQL soit prêt
set -e

host="$1"
shift
cmd="$@"

# Vérifier si MySQL est accessible
until nc -z "$host" 3306; do
  >&2 echo "MySQL n'est pas encore prêt - attente..."
  sleep 1
done

>&2 echo "MySQL est prêt - exécution de la commande."
exec $cmd
