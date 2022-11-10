set terminal png size 1000,1000
set output 'throughput.png'
set title 'Evolution of throughput from Youtube as a function of time'
set xlabel "Time (hour)"
set ylabel "Throughput (MB/s)"
set xdata time
set timefmt "%H:%M:%S"
set xrange ["00:00:00":"23:50:00"] #à redéfinir manuellement pour une fenêtre de mesure (si c'est sur une journée tu peux faire de minuit à 23h)
set yrange [15:30] #pareil, à redéfinir en fonction de ta connexion. De toute manière si on compte tracer plusieurs courbes sur le même graphe il faudra forcément un script à part donc ça n'a pas vraiment de sens d'avoir un script adaptatif
#plot the graphic
plot "data.dat" using 1:2 lt rgb 'red' w lp  title 'Throughput'
