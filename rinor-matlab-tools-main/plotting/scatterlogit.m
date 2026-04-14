function [mdl,mdlEval,marksx] = scatterlogit(X,Y,bIntercept,dispName,offset,yax,bPlot,nAFC,marksy,markalpha)
arguments
    X cell
    Y cell
    bIntercept logical = true
    dispName cell = repmat({''},20)
    offset logical = true
    yax char = 'percent'
    bPlot logical = true
    nAFC double = nan
    marksy double = [];
    markalpha double = 0.1;
end

if isempty(bIntercept); bIntercept = true; end
if isempty(dispName); dispName = repmat({''},20); end
if isempty(offset); offset = true; end
if numel(X) == 1; offset = false; end
if isempty(yax); yax = 'percent'; end
if isempty(bPlot); bPlot = true; end
if isempty(nAFC); nAFC = nan; end


n = length(X);
N = size(X,2);
maxoff = 0.02;
off = offset*linspace(-maxoff,maxoff,n);
colors = gca().ColorOrder;

for i = 1:N
    if N == 1
        linCol = 'k';
    else
        linCol = colors(i,:);
    end
    xp = linspace(min(X{i}),max(X{i}),1000)';

    if isnan(nAFC)
        mdl{i} = fitglm(X{i}, Y{i},'distribution', 'binomial','intercept',bIntercept,'Options',statset('MaxIter',1000));
    else
        S.Link = @(mu) psylink(mu,nAFC);%real(log((mu-1/nAFC)./(1-mu)));
        S.Inverse = @(resp) psylinkinv(resp,nAFC);%real((1+nAFC*exp(resp))./(nAFC*(exp(resp)+1)));
        S.Derivative = @(mu) psylinkd(mu,nAFC);%real((nAFC-1)./((1-nAFC*mu).*(mu-1)));

        mdl{i} = fitglm(X{i}, Y{i},'distribution', 'binomial','link',S,'Options',statset('MaxIter',1000));
    end


    b1(i) = mdl{i}.Coefficients.Estimate('x1');
    if bIntercept
        b0(i) = mdl{i}.Coefficients.Estimate('(Intercept)');
    else
        b0(i) =0;
    end
    legLabel = [dispName{i} ': $\beta_0 = ' num2str(round(b0(i),2,'significant')) '$, $\beta_1 = ' num2str(round(b1(i),2,'significant')) '$'];

    [yp,ci] = predict(mdl{i},xp,'Alpha',0.1);
    if bPlot
        switch yax
            case 'percent'
                scatter(X{i},jitter(Y{i},0)+off(i),22,'MarkerEdgeColor','none',...
                    'MarkerFaceColor',gca().ColorOrder(i,:),...
                    'MarkerFaceAlpha',markalpha,'MarkerEdgeAlpha',markalpha,'HandleVisibility','off')
                hold on

                

                patx = [xp; flipud(xp)];
                paty = [ci(:,1); flipud(ci(:,2))];
                if ~all(isnan(ci(:)))
                    patch(patx(~isnan(patx)),paty(~isnan(paty)),'k-','LineWidth',2,'FaceColor',linCol,...
                        'FaceAlpha',0.4,'EdgeAlpha',0,'HandleVisibility','on','DisplayName','90% pointwise CI');
                end
                
                p = plot(xp,yp,'color',linCol,'DisplayName',legLabel);
                ylim([-.1 1.1])
                set(gca,'YTick',[0 1])

            case 'logodds'
                

                [yp,ci] = predict(mdl{i},xp,'Alpha',0.1);
                ciLogit = logit(ci);
                ypLogit = logit(yp);
                p = plot(xp,ypLogit,'color',linCol,'DisplayName',legLabel);
                hold on
                patx = [xp; flipud(xp)];
                paty = [ciLogit(:,1); flipud(ciLogit(:,2))];
                if ~all(isnan(ci(:)))
                    patch(patx(~isnan(patx)),paty(~isnan(paty)),'k-','LineWidth',2,'FaceColor',linCol,...
                        'FaceAlpha',0.4,'EdgeAlpha',0,'HandleVisibility','on');
                end
        end
        if strcmp(dispName{i},'')
            set(p,'HandleVisibility','off')
        end
    end

% [~,~,~,mdlEval.AUC(i)] = perfcurve(Y{i},mdl{i}.Fitted.Probability,1);

f = predict(mdl{i},X{i});
mdlEval.BS(i) = sum((f-Y{i}).^2)/numel(X{i});

mdlEval.xp = xp;
mdlEval.ci = ci;
mdlEval.yp = yp;

% title(['AUC: ' num2str(round(mdlEval.AUC,3)) '   BS: ' num2str(round(mdlEval.BS,3)) '   R2: ' num2str(round(mdl{1}.Rsquared.Ordinary,3))])
marksx = nan;

for m = 1:numel(marksy)
    
[~,minidx] = min(abs(predict(mdl{i},xp)-marksy(m)));
xm = xp(minidx);
ym = predict(mdl{i},xm);
marksx(m) = xm;
if bPlot
plot(xm,ym,'*','Color',linCol,'HandleVisibility','off')
text(xm+diff(gca().XLim)*0.04,ym,['(' num2str(round(xm,2)) ',' num2str(round(ym,2)) ')'])
end

end

if bPlot
% pat = patch(nan,nan,'k-','LineWidth',2,'FaceColor','k',...
%             'FaceAlpha',0.4,'EdgeAlpha',0,'DisplayName','90% pointwise CI','HandleVisibility','off');
% if i == N
%     set(pat,'HandleVisibility','on')
% end

switch yax
    case 'logodds'
        
        ymin = round(min(yticks),1);
        ymax = round(max(yticks),1);
        set(gca,'YTick',linspace(ymin,ymax,5))
        yyaxis right
        step = round((sigmoid(ymax)-sigmoid(ymin))/6,2);
        yticksright = logit(round(sigmoid(ymin),2):step:round(sigmoid(ymax),2));
        set(gca,'YTick',yticksright)

        ax = gca();
        r1=ax.YAxis(1);
        r2=ax.YAxis(2);
        linkprop([r1 r2],'Limits')
        % axTickLabs = strsplit(num2str(100*round(linspace(sigmoid(ymin),sigmoid(ymax),10),2)));

        axTickLabs = strsplit(num2str(100*sigmoid(yticksright)));

        set(gca,'YTickLabels',cellfun(@(x) [x '%'],axTickLabs,'UniformOutput',false))
        set(gca,'YColor',[0.5 0.5 0.5])

    case 'percent'
        colOrder = gca().ColorOrder;
        yyaxis right
        set(gca,'ColorOrder',colOrder);
        step = 0.5;
        yticksright = 0:step:1;
        set(gca,'YTick',yticksright)
        axTickLabs = strsplit(num2str(100*yticksright));
        set(gca,'YTickLabels',cellfun(@(x) [x '%'],axTickLabs,'UniformOutput',false))
        set(gca,'YColor',[0.5 0.5 0.5])

        ax = gca();
        r1=ax.YAxis(1);
        r2=ax.YAxis(2);
        linkprop([r1 r2],'Limits');
        yyaxis left
        set(gca,'ColorOrder',colOrder);
end
end


end


