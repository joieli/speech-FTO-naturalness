function RGBcodes = get_RGBColorCodes(colors)

if ~exist('colors','var')
    colors = ["red","blue","yellow","olive","teal","pink","grey","lilla","orange","lavender"];
end
dict = containers.Map;

dict('red') = hex2rgb('B2000B');
dict('blue') = hex2rgb('225896');
dict('yellow') = hex2rgb('EDCB63');
dict('olive') = hex2rgb('71BC40');
dict('teal') = hex2rgb('5CC4C2');
dict('pink') = hex2rgb('E072A0');
dict('grey') = hex2rgb('6F6F6F');
dict('lilla') = hex2rgb('B29ACC');
dict('orange') = hex2rgb('ED831A');
dict('lavender') = hex2rgb('714996');

for i = 1:length(colors)
    RGBcodes(:,i) = dict(char(colors{i}));
end

end