function [t,s,v]=rampe(s3,a,b,v0)
       global time
       t3=(s3/v0)+((v0/2)*(1/a+1/b));
       t1=v0/a;
       t2=t3-v0/b;
       t=time;
       M=zeros(3,1001);
       M(1,:)=t(:);
   if((s3-v0^2/(2*b)-v0^2/(2*a))>0)
      
    for i=1:1001
        if(t(i)<=t1)
            M(2,i)=t(i)*a;
            M(3,i)=0.5*a*t(i)^2;
        elseif(t(i)<=t2 && t(i)>t1)
            M(2,i)=v0;
            M(3,i)=0.5*a*t1^2+v0*(t(i)-t1);
        elseif(t(i)>t2 && t(i)<=t3)
            M(2,i)=v0-(t(i)-t2)*b;
            M(3,i)=0.5*a*t1^2+v0*(t2-t1)+(v0*(t(i)-t2))-b*0.5*(t(i)-t2)^2;     %((v0-0.5*b)*(t(i)-t2)^2);
        else
            M(2,i)=0;
            M(3,i)=s3;
        end
    end

   else
    tb=sqrt(s3/(a/2+a^2/(2*b)));
    for i=1:1001
        if(t(i)<=tb)
            M(2,i)=t(i)*a;
            M(3,i)=0.5*a*t(i)^2;
        elseif (t(i)>tb && t(i)<=t3)
            M(2,i)=a*tb-(t(i)-tb)*b;
            M(3,i)=0.5*a*tb^2+(a*tb*(t(i)-tb)-b*0.5*(t(i)-tb)^2);
          else
            M(2,i)=0;
            M(3,i)=s3;
        end
    end
   end
v=M(2,:);
s=M(3,:);
end