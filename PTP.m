%---------------------------Punkte PTP-----------------------------
S=[-0.4;0.3];
P=[0.4;-0.3];
Z=zeros(1,1001);
global time
%------------------------------Berechnung Winkel--------------------
K1=Winkel([-0.4,0.3]);
K2=Winkel([0.4,-0.3]);
dOme=K1(2)-K2(2);
dPhi=K1(1)-K2(1);
%--------------------------------Phi--------------------------------
Phiv0=0.7;
Phia=0.5;
Phib=0.3;
Phis3=abs(dPhi);
T3Phi=(Phis3/Phiv0)+abs((Phiv0/2)*(1/Phia+1/Phib));
%--------------------------------Omega-------------------------------
Omev0=0.3;
Omea=0.3;
Omeb=0.4;
Omes3=abs(dOme);
T3Ome=(Omes3/Omev0)+abs((Omev0/2)*(1/Omea+1/Omeb));
%---------------------------PTP asynchron--------------------------
if (T3Phi>T3Ome)
    time=[0:T3Phi/1000:T3Phi];
    
    
else
    time=[0:T3Ome/1000:T3Ome];
   
end
[TPhi,SPhi,VPhi]=rampe(Phis3,Phia,Phib,Phiv0);
[TOme,SOme,VOme]=rampe(Omes3,Omea,Omeb,Omev0);
%---------------------------PTP Synchron---------------------------
if (T3Phi>T3Ome)
    time=[0:T3Phi/1000:T3Phi];
    e=1/0.3+1/0.4;
    Q=[1,2];
    Q(1,1)=(-tsyn+sqrt(tsyn^2-(4*e*Omes3)/2))/(-2*e/2);
    Q(1,2)=(-tsyn-sqrt(tsyn^2-(4*e*Omes3)/2))/(-2*e/2);
    if(Q(1,1)<=Phiv0 && Q(1,1)>0)
        Omev0=Q(1,1);
    elseif (Q(1,2)<=Phiv0 && Q(1,2)>0)
        Omev0=Q(1,2);
    end   
    [sTOme,sVOme,sSOme]=rampe(Omes3,Omea,Omeb,Omev0);
    [sTPhi,sVPhi,sSPhi]=rampe(Phis3,Phia,Phib,Phiv0);
  
else
    time=[0:T3Ome/1000:T3Ome];
    e=(1/0.5)+(1/0.3); 
    Q=[1,2];
    Q(1,1)=(-tsyn+sqrt(tsyn^2-(4*e*Phis3)/2))/(-2*e/2);
    Q(1,2)=(-tsyn-sqrt(tsyn^2-(4*e*Phis3)/2))/(-2*e/2);
    if(Q(1,1)<=Omev0 && Q(1,1)>0)
        Phiv0=Q(1,1);
    elseif(Q(1,2)<=Omev0 && Q(1,2)>0)
        Phiv0=Q(1,2);
    end   
    [sTPhi,sSPhi,sVPhi]=rampe(Phis3,Phia,Phib,Phiv0);
    [sTOme,sSOme,sVOme]=rampe(Omes3,Omea,Omeb,Omev0);
end

%--------------------------------Plotten--------------------------------
ArbeitsbereichWinkel=linspace(0,2*pi,100);
ArbeitsbereichX =0.7*sin(ArbeitsbereichWinkel);
ArbeitsbereichY =0.7*cos(ArbeitsbereichWinkel);


subplot(2,3,2)
title("Winkel φ (t) sowie v(t)")
hold all
P1=plot(time(:),K1(1)-SPhi(:),'r'); M1="φ (t) [rad]";
P2=plot(time(:),VPhi(:),'b'); M2="v(t) [rad/s]";
legend([P1 P2],[M1 M2],'Location','southwest');
subplot(2,3,3)
title("Winkel \omega(t) sowie v(t)")
hold all
O1=plot(time(:),K1(2)+SOme(:),'r'); M3="\omega(t) [rad]";
O2=plot(time(:),VOme(:),'b'); M4="v(t) [rad/s]";
legend([O1 O2],[M3 M4],'Location','southeast');
subplot(2,3,5)
hold all
title("Winkel φ(t) sowie v(t)")
P3=plot(time(:),K1(1)-sSPhi(:),'r'); M5="φ(t) [rad]";
P4=plot(time(:),sVPhi(:),'b'); M6="v(t) [rad/s]";
legend([P3 P4],[M5 M6],'Location','southwest');
subplot(2,3,6)
hold all
title("Winkel \omega (t) sowie v(t)")
O3=plot(sTOme(:),K1(2)+sSOme(:),'r'); M7="\omega (t) [rad]";
O4=plot(sTOme(:),sVOme(:),'b'); M8="v(t) [rad/s]";
legend([O3 O4],[M7 M8],'Location','southeast');
subplot(2,3,4)
title("Achsenbewegung synchron")
set(gca,'position',[.1 .12 .25 .33])
axis([-0.7 0.7 -0.7 0.7])
hold all
B = plot(cos(K1(1)-sSPhi(:))*0.4+cos(K1(2)-sSOme(:))*0.3,sin(K1(1)-sSPhi(:))*0.4+sin(K1(2)-sSOme(:))*0.3,'g');
plot(ArbeitsbereichX,ArbeitsbereichY,'--','color',[.5 .5 .5]);
subplot(2,3,1)
title("Achsenbewegung asynchron")
set(gca,'position',[.1 .595 .25 .33])
axis([-0.7 0.7 -0.7 0.7])
hold all
A = plot(cos(K1(1)-SPhi(:))*0.4+cos(K1(2)-SOme(:))*0.3,sin(K1(1)-SPhi(:))*0.4+sin(K1(2)-SOme(:))*0.3,'g');
A1=plot(ArbeitsbereichX,ArbeitsbereichY,'--','color',[.5 .5 .5]); L1='Arbeitsbereich';
for i=1:1001
   
    hold all
   drawnow
if exist('Pl1') && exist('Pl2') && exist('Pl3') && exist('Pl4')
        delete(Pl1)
        delete(Pl2)
end
    
Pl1=plot([Z(i) cos(K1(1)-SPhi(i))*0.4],[Z(i) sin(K1(1)-SPhi(i))*0.4],'k');
Pl2=plot([cos(K1(1)-SPhi(i))*0.4,cos(K1(1)-SPhi(i))*0.4+cos(K1(2)-SOme(i))*0.3],[sin(K1(1)-SPhi(i))*0.4,sin(K1(1)-SPhi(i))*0.4+sin(K1(2)-SOme(i))*0.3],'k');

end
subplot(2,3,4)
title("Achsenbewegung synchron")
set(gca,'units','normalized','position',[.1 .12 .25 .33])
axis([-0.7 0.7 -0.7 0.7])
hold all
B = plot(cos(K1(1)-sSPhi(:))*0.4+cos(K1(2)-sSOme(:))*0.3,sin(K1(1)-sSPhi(:))*0.4+sin(K1(2)-sSOme(:))*0.3,'g');
plot(ArbeitsbereichX,ArbeitsbereichY,'--','color',[.5 .5 .5]);

for i=1:1001
    hold all
    drawnow
if exist('Pl3') && exist('Pl4')
        delete(Pl3)
        delete(Pl4)
end
    
Pl3=plot([Z(i) cos(K1(1)-sSPhi(i))*0.4],[Z(i) sin(K1(1)-sSPhi(i))*0.4],'k');
Pl4=plot([cos(K1(1)-sSPhi(i))*0.4,cos(K1(1)-sSPhi(i))*0.4+cos(K1(2)-sSOme(i))*0.3],[sin(K1(1)-sSPhi(i))*0.4,sin(K1(1)-sSPhi(i))*0.4+sin(K1(2)-sSOme(i))*0.3],'k');
end