set terminal postscript eps size 3.5,2.62 enhanced colour solid \
font 'Helvetica,16' linewidth 2

set style data histogram
set style histogram cluster gap 2 errorbars linewidth 2
set style fill solid 1.00 border -1
set boxwidth 0.9
set bars front
set key outside
set key center top
set key horizontal

set style line 1 lt 1 lc rgb "green"

set grid 
set auto x
set yrange[0:220]
set ytics 0,20,220

set title v_title
set xlabel v_xlabel
set ylabel v_ylabel

set output(v_output)
plot    v_input using ($2/1000.):($3/1000.) title column(2), \
        '' using ($4/1000.):($5/1000.):xticlabels(1) title column(4)
