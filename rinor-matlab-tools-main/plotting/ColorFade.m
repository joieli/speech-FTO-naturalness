function colors = ColorFade(col1,col2,n)

colors = zeros(3,n);

for i = 1:3
colors(i,:) = linspace(col1(i),col2(i),n);
end