function RGBcodes = DTUColors(type,colors)

  arguments 
    type (1, 1) string  = "qualitative"
    colors cell = {'corporate red','blue','green','orange','purple','navy blue','yellow','bright green','pink','grey','red'}
  end


dict = containers.Map;
dict('corporate red') = hex2rgb('990000');
dict('blue') = hex2rgb('225896');           % Desaturated, check website for correct blue
dict('bright green') = hex2rgb('1FD082');
dict('navy blue') = hex2rgb('030F4F');
dict('yellow') = hex2rgb('EEBE0C'); % Edited to suit powerpoint
dict('orange') = hex2rgb('FC7634');
dict('pink') = hex2rgb('F7BBB1');
dict('grey') = hex2rgb('DADADA');
dict('red') = hex2rgb('E83F48');
dict('green') = hex2rgb('56861C'); % Edited to suit powerpoint
dict('purple') = hex2rgb('79238E');

switch type
    case 'qualitative'
        for i = 1:numel(colors)
            RGBcodes(:,i) = dict(char(colors{i}));
        end

    otherwise   % First input can be a single color
        RGBcodes = dict(char(type));
end
