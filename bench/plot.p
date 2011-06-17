
set terminal png
set output "out.png"

set grid

set title  "ab -n 1000 -c 100"
set yrange[0:1500]
set label "blog.hemca.com" at graph 0.01, 0.95

set xlabel "request"
set ylabel "response time (ms)"

set size 1.0, 0.7
plot \
    "out-node.dat" using 9 smooth sbezier with lines title "node 89", \
    "out-django.dat" using 9 smooth sbezier with lines title "django 82/polls", \
    "out-ruby.dat" using 9 smooth sbezier with lines title "ruby 81", \
    "out-express.dat" using 9 smooth sbezier with lines title "express 88"
