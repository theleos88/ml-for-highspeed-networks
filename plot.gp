# Exp 3500_256
# Exp 8000_64
# Exp 6000_imix
set terminal pdf size 7,2 font "Times, 12"
set output "cosine.pdf"

set grid 

set xlabel "Input rate [Gbps]"
set ylabel "Cosine similarity"

set key outside

set multi layout 1,4
unset key
#set key above box
set yrange [-1.01:1.01]


set title "Rate: 3.5Gbps, Pktsize: 256B"
plot 'examples.tlv' i 0 u ($1/1000):2 w lp lw 2 t "Pktsize: 64B", \
'' i 1 u ($1/1000):2 w lp lw 2 t "Pktsize: 256B", \
'' i 2 u ($1/1000):2 w lp lw 2 t "Pktsize: IMIX" \

unset ylabel

set title "Rate: 7.5Gbps, Pktsize: 64B"
plot 'examples.tlv' i 3 u ($1/1000):2 w lp lw 2 t "Pktsize: 64B", \
'' i 4 u ($1/1000):2 w lp lw 2 t "Pktsize: 256B", \
'' i 5 u ($1/1000):2 w lp lw 2 t "Pktsize: IMIX" \

set title "Rate: 5Gbps, Pktsize: IMIX"

plot 'examples.tlv' i 6 u ($1/1000):2 w lp lw 2 t "Pktsize: 64B", \
'' i 7 u ($1/1000):2 w lp lw 2 t "Pktsize: 256B", \
'' i 8 u ($1/1000):2 w lp lw 2 t "Pktsize: IMIX"

set key above box
unset grid
replot


pause(-1)
