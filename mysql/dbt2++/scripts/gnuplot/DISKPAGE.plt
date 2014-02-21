set terminal postscript eps size 3.5,2.62 enhanced colour solid \
font 'Helvetica,18' linewidth 2

set yrange[-55:30]
set xrange[-1:6]
set grid

set ylabel "Performance increase %"
set xlabel "MPL"

set xzeroaxis lt 1 lc "black"

set key left top
 
set output ("diskpageperf16.ps")
plot "diskpageperf16.data" using ($2*100) title column(2) ps 1.5, '' using ($3*100):xticlabels(1) title column(3) ps 1.5

set output ("diskpageperf32.ps")
plot "diskpageperf32.data" using ($2*100) title column(2) ps 1.5, '' using ($3*100):xticlabels(1) title column(3) ps 1.5
