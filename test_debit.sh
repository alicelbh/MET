#!/bin/bash
#first we collect the data from a single download into a file
n=100 #nombre de valeurs moyennées pour un point du graphe
period=1200 #durée d'une itération en s
SECONDS=$period
hour=0
hour_duration=71 #nombre d'itérations
#liste.txt contient une version plus digeste des mesures, avec les dates complètes et les valeurs avec unités
#data.dat contient uniquement les valeurs qui serviront à tracer le graphe
echo "début des mesures" > liste.txt
echo "" >> liste.txt
echo "" > data.dat #ces deux lignes permettent de vider les fichiers, si tu veux garder d'anciennes valeurs pense bien à les renommer où à les mettre ailleurs
while (($hour<$hour_duration))
do
  if (($SECONDS > $period))
  then
    total=0
    SECONDS=0
    hour=$((hour+1))
    echo "new set of measures"
    date=$(date)
    day=$(date | sed 's/ *..:.*//') #pour récupérer uniquement le jour
    time=$(date | grep -o '..:..:..') #pour récupérer uniquement l'heure
    echo $date >> liste.txt
    for ((i=0; i<$n; i++))
    do
      echo "coucou"
    	wget -p https://www.youtube.com/ 2>&1 | grep '\([0-9.]\+ [KM]B/s\)' | grep -o '\([0-9.]\+ [KM]B/s\)' | tail -1 > result.txt #renvoie uniquement le débit moyen sur le téléchargement des 22 fichiers correpsondant à l'adresse
      number=$(grep -o '\([0-9.]\+\)' result.txt | tail -1)
      unit=$(grep -o '\([KMG]B/s\)' result.txt | tail -1) #j'ai pas pris le temps d'implémenter la prise en compte de l'unité, en partant du principe que pour une connexion donnée on devrait pas passer d'une unité à l'autre. Je mettrai peut-être ça à jour plus tard
      total=$(echo "$total + $number" | bc)
      echo $total #un peu inutile, c'est surtout pour vérifier en temps réel que tout se passe bien

    done
    mean=$(echo "$total / $n" | bc)
    echo "mean throughput over $n values:$mean $unit" >> liste.txt
    echo "" >> liste.txt
    echo "$time        $mean" >> data.dat
  fi
done
gnuplot throughput.p #permet de récupérer le graphe en appelant le deuxième script
