set terminal postscript eps size 3.5,2.62 enhanced colour solid \
font 'Helvetica,18' linewidth 2

set output ("11-SSIoverhead.ps")

set yrange[0:70]
set xrange[-1:5]
set grid

set ylabel "SSI overhead %"
set xlabel "CPU configuration"

set key left top

plot "11-SSIoverhead.data" using ($2*100) title column(1) ps 1.5, '' using ($3*100):xticlabels(1) title column(2) ps 1.5
