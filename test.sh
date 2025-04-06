#!/bin/bash

director_radacina="/tmp/active_users"

mkdir -p "$director_radacina"

actualizare_utilizatori_activi()
{
    utilizatori_activi=$(who | awk '{print $1}' | sort | uniq)

    for utilizator in $utilizatori_activi; do
        director_utilizator="$director_radacina/$utilizator"

        if [ ! -d "$director_utilizator" ]; then
            mkdir -p "$director_utilizator"
        fi

        if [ -f "$director_utilizator/lastlogin" ]; then
            rm "$director_utilizator/lastlogin"
        fi

        ps -u "$utilizator" > "$director_utilizator/procs"
    done

    for director_utilizator in "$director_radacina"/*; do
        utilizator=$(basename "$director_utilizator")

        if ! echo "$utilizatori_activi" | grep -q "$utilizator"; then
            > "$director_utilizator/procs"

            if [ ! -f "$director_utilizator/lastlogin" ]; then
                date "+%Y-%m-%d %H:%M:%S" > "$director_utilizator/lastlogin"
            fi
        fi
    done
}

while true; do
    echo "Actualizare informatii..."
    actualizare_utilizatori_activi
    sleep 30
done
