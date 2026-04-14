function [TitFS, AxeFS, LabFS, LegFS] = plotFontSizes(type,scale)
arguments
    type char = 'article'
    scale double = 1;
end

switch type
    case 'article'
        TitFS = 24;
        AxeFS = 15;
        LabFS = 22;
        LegFS = 15;

    case 'poster'
        TitFS = 32;
        AxeFS = 21;
        LabFS = 28;
        LegFS = 16;

    case 'presentation'
        TitFS = 18;
        AxeFS = 13;
        LabFS = 15;
        LegFS = 12;
end

TitFS = TitFS*scale;
AxeFS = AxeFS*scale;
LabFS = LabFS*scale;
LegFS = LegFS*scale;
