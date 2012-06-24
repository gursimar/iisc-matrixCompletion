figure
grid on
h = line ([0.5 0.5],[0 1])
set (h,'Color','k')
h = line ([0 1],[0.5 0.5])
set (h,'Color','k')
xlabel ('seriousness')
ylabel ('funny')
hold all

plot (0.9,0.9,'*')

plot (0.8,0.6,'*')
plot (0.7,0.9,'*')

