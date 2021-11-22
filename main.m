
sec = input('1 for data; 2 for ana; 3 for vis\n');
if sec == 1         % data
    data = In(data);
    save('data.dat','-append');
    fprintf('input data finished\n');

elseif sec == 2     % ana
    data = Analyze(data);
    fprintf('analyze data finished\n');

elseif sec == 3     % vis

    data(1).ls = '--xr';
    data(2).ls = '--xr';

    fig.xlb = "U";
    fig.xut = "V";
    fig.ylb = "T";
    fig.yut = "K";
    fig.poz = [0.2 0.7 0.25 0.15];

    visual(data,fig);



else
    fprintf('out\n');

end

function [S] = In(S)
% In - Input data
%
% Syntax: [data] = In(n)
%
% Long description
    % line(1).x = "U";
    % line(1).y = "T";
    % line(1).ls = "xr";
    % line(2).x = "U";
    % line(2).y = "y1";
    % line(2).ls = "--b";
    % nx = input('name for x\n','s');
    % ny = input('name for y\n','s');

    num = input('which set?\n');
    N = input('How many data?\n');

    x = zeros(1,N);
    y = zeros(1,N);

    for ii = 1:N
        fprintf('input the %d value in set %d of x,y\n',ii,num);
        x(ii) = input('for x\n');
        y(ii) = input('for y\n');
    end

    S(num).x = x;
    S(num).y = y;
    % S(1).fit = y1;
    % S(1).para = [b1,b0,R_2];

end

function [S] = Analyze(S)
%myFun - Description
%
% Syntax: [S] = Analyze(S)
%
% Long description

    num = input('which set?\n');
    meth = input('which method?\n','s');
    if meth == 'l'
        [b1,b0,R_2,y1] = linear(S(num).x,S(num).y);
        S(num).method = meth;
        S(num).fit = y1;
        S(num).para = [b1,b0,R_2];
    else
        fprintf('no such method\n');
    end
end


function [] = visual(S,fig)
%myFun - Description
%
% Syntax: [] = visual(S)
%
% Long description

    grid on
    hold on
    num = input('which data?\n');

    for ii = num
        plot(S(num).x,S(num).y,S(num).ls,...
            'LineWidth',1);
        if S(num).method == 'l'
            plot(S(num).x,S(num).y,...
                '--b',...
                'LineWidth',0.5);
        end
    end

    XL = "$" + fig.xlb + "\; / \mathrm{" + fig.xut + "}$";
    xlabel(XL,'Interpreter','LaTex');
    YL = "$" + fig.ylb + "\; / \mathrm{" + fig.yut + "}$" ;
    ylabel(YL,'Interpreter','LaTex');
    legend('data','fit','Interpreter','tex',...
        'FontSize',10,...
        'Position',fig.poz);

end


function [b1,b0,R_2,y1] = linear(x,y)
    % 最小二乘拟合

    Lxx=sum((x-mean(x)).^2);
    Lxy=sum((x-mean(x)).*(y-mean(y)));
    b1=Lxy/Lxx;
    b0=mean(y)-b1*mean(x);
    y1=b1*x+b0;
    R_2 = 1-sum((y1-y).^2./y1);

    fprintf('linear RGS for x,y:\n b1 = %.4f; b0 = %.4f ;R^2 = %.6f \n',b1,b0,R_2);

end