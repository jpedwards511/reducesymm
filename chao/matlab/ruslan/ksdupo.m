%% Locate close returns in real space
  N = 31;  d = 2*pi/sqrt(0.015);  h = 0.2;  randn('seed',12340014);
  u = 0.1*randn(N,1);
  [tt, uu] = ksedtodd(d, u, h, 1000, 5);
  figure(1); clf;  colormap(jet);
  pcolor(d.*(1:N)'./(2*N+2), tt, uu');  shading flat;
   
  if 1, cr = zeros(size(uu,2));
    for ii = 1:size(uu,2),  cr(ii,:) = sqrt(sum((uu-repmat(uu(:,ii),1,size(uu,2))).^2));  end,
    figure(2); clf; %pcolor(cr); shading flat; hold on; 
    contour(1:201, 1:201, cr,1:3);
  end,


%% Locate close returns in Fourier modes
  N = 63;  nu = (2*pi/54.0)^2;  nu = 0.015;
  h = 0.002;  randn('seed',12340000);
  a0 = randn(N,1).*exp(-0.3*(1:N)'); % a0 = zeros(N,1); a0(1) = -1.0;
  [tt, aa, a0p, ap] = kscvfm(nu, 5.0, a0, h, 5);  na = size(aa,2);
  uu = real(ifft(1i*(2*N+2)*[zeros(1,na); aa; zeros(1,na); -flipud(aa)]));
  uu = uu(2:N+1,:);  xx = pi*(1:N)'/(N+1);
  figure(1); clf; pcolor(xx,tt,uu'); shading flat;
  
  global C;  C = eye(N);

  switch 1,
  case 1,
    cr = zeros(na);
    for ii = 1:size(aa,2),  cr(ii,:) = sqrt(sum((aa-repmat(aa(:,ii),1,na)).^2));
%      cr(ii,:) = cr(ii,[ii:end 1:ii-1]);
      cr(ii,:) = [cr(ii,ii:end) zeros(1,ii-1)];
    end,
    figure(2); clf;
    contourf(tt, tt, cr', 0:1:4);  grid on;  xlabel('t_0');  ylabel('T','rotat',0);
    if 1,  [nb, ne] = ginput(1);  ne = ne + nb;
      nb = round(nb./(tt(2)-tt(1)));  ne = round(ne./(tt(2)-tt(1)));
    else
%  12340000
%      nb = 215;  ne = 287; % 3: 0 - 0.7294, 1 - 0.660 (almost)
%      nb = 191;  ne = 252; % 3: 0,1 - 0.6826, 2 - 0.6819
%      nb = 123;  ne = 262; % 3: 0 - 1.3936
%      nb = 123;  ne = 203; % 3: 2 - 0.7294
%      nb = 123;  ne = 168; % 3: 0 - 0.5057
%      nb = 275;  ne = 395; % 2: 0 - 1.2646, 3 - 1.2678
%      nb = 158;  ne = 224; % 3: 0,1 - 0.6826
%  12340050
%      nb = 121;  ne = 217; % 3: 0,1 - 0.9205, 7 - 0.9968
%  -1.01
%       nb = 234;  ne = 351; % 3: 0,2 - 1.1845, 1,3 - 1.2677,
%nu = 0.025534
%  12340000
%       nb = 157;  ne = 430;  % 1: 0 - 2.7383,
%  12340001
%       nb =  86;  ne = 176;  % 3: 0 - 0.9961,
%N = 31;  nu = (2*pi/38.5)^2;  h = 0.002;  randn('seed',12340000);
%     nb = 146;  ne = 278; % 3: 0 - 1.4017, 1,2,3 - 1.3821, 8 - 2x0.6826
%N = 63;  nu = (2*pi/54.0)^2;  h = 0.002;  randn('seed',12340000);
%     nb = 54;  ne = 104; % 5: 0 - 0.4939, 
%     nb = 136; ne = 187; % 3: 0,10 - 0.4838, 
%     nb = 256; ne = 272; % 3: 0 - 0.3500,
    end,
    if ne < nb;  ii = nb;  nb = ne;  ne = ii; end,
    a0 = aa(:,nb);  tend = tt(ne)-tt(nb);  disp([nb ne]);% return;
    if 1,  %  Determine stretching directions at the seed
      nud = 3;  nst = 2;
      [ts, as, da] = kscvfmj(nu, tt(nb), aa(:,1), h, 0); 
      [uu, dd, vv] = svd(da);
      disp([find(diag(dd)>1)' nst]);  disp(duposp(nud,nst));
      C = eye(N) + uu(:,1:nud)*(duposp(nud,nst)-eye(nud))*uu(:,1:nud)';
    else
      [tt, aa, da] = kscvfmj(nu, tend, a0, h, 0);
      [uu,dd,vv] = svd(da-eye(N));  C = -vv*uu';
    end,
  case 2,
%    nb = 85;   ne = 124;%  stationary point  
%    nb = 157;  ne = 226;  
%    nb = 180;  ne = 322;
%    nb = 61;   ne = 398;%  tend = 3.363770;
%    nb = 358;   ne = 475;%  tend = 1.184548;
    a0 = aa(:,nb);  tend = tt(ne)-tt(nb);
  case 3,
    load ksfm064upo;  N = 31;  a0 = a0(1:N);
    [tt, aa, da] = kscvfmj(nu, tend, a0, 0.002, 0);
%    [vv,dd] = eig(da);  dd(1,1) = -dd(1,1);  da = real(vv*dd*inv(vv));
    [uu,dd,vv] = svd(da-eye(N));  C = -vv*uu';
  case 4,
%    nb = 83;   ne = 262;
    nb = 308;  ne = 347;
    a0 = aa(:,nb);  tend = tt(ne)-tt(nb);
    [tt, aa, da] = kscvfmj(nu, tend, a0, 0.002, 0);
    [uu,dd,vv] = svd(da-eye(N));  C = -vv*uu';
  case 5,
    load ksfm278seed2;
    [tt, aa, da] = kscvfmj(nu, tend, a0, 0.002, 0);
    [uu,dd,vv] = svd(da-eye(N));  C = -vv*uu';
  case 6,
    load ksfm0920upo;  ip = 1;  a0 = as(:,ip);  tend = ts(end);  tend = 1.5;
    [tt, aa, da] = kscvfmj(nu, tend, a0, h, 0);
    [uu,dd] = eig(da);
    dd(1,1) = -dd(1,1);
%    dd(2,2) = -dd(2,2);
%    a0 = a0 - 1e-3.*uu(:,2);
    das = real(uu*dd*inv(uu));  [uu,dd,vv] = svd(das-eye(N));  C = -vv*uu';
  end
%  return;
  reltol = 1e-7;  abstol = reltol; %[10.*reltol.*exp(-0.3*(1:N)'); 1];
  options = odeset('abstol',abstol,'reltol',reltol,'outputfcn',@ksdupoplot);
  [s,y] = ode15s(@ksfmc5, [0 40], [a0; tend],options);

%% Plot real-space KS-odd solution
  clear; load ksfm064upo;  t = (0:0.005:1)'*tend;
  tic; b = ksfmflowmapj(nu, t, a0, 2e-4); toc;
  d = 2*pi/sqrt(nu);
  y = (0:N)'*pi/N; w = zeros(length(y),length(t));
  for i=1:length(t), w(:,i) = -2*sum(repmat(b(:,i),1,length(y)).*sin(y*(1:N))')'; end,
  u = -4*pi.*w./d;  x = y*d/(2*pi);
  figure(1); clf; pcolor(x,t/nu,u'); shading flat;
  
  u0 = u(2:end-1,1);
  
  tic; [tt, uu] = ksedtodd(d, u0, 0.2, 212, 1); toc;
  figure(2); clf; pcolor(x(2:end-1),tt,uu'); shading flat;


%% test FFT calculation of ksfm coupled term
  d = 7;  a = (1:d)';  k = (1:d);  f = zeros(d,1);  N = 2*(d+1);
  for ik = k,
    f(ik) = sum(a(1:ik-1).*a(ik-1:-1:1)) - 2.*sum(a(1:d-ik).*a(ik+1:d));
  end,
  
  uk = 1i*[0; a; 0; -flipud(a)].*N;
  uu = real(ifft(uk));
  v = -ifft(uu.^2);
  
  aa = [-flipud(a); 0; a];  bb = [0; flipud(aa(2:end))]';
  for ik = k(2:end),
    bb = [bb; [-aa(end-ik+2:end)' 0 flipud(aa(ik+1:end))']];
  end
  
  af = [0; a; 0; -flipud(a)];

%% Test different fft/ifft conventions in ksfmstp
  clear;  load ks22uqo125a;  L = 50; h = 0.1;
  a0 = [a0; zeros(32,1)];  tend = 3*tend;
  [tt,aa] = ksfmstp(a0, L, h, tend/h, 1);
  [tt,aa2] = ksfmstp2(a0, L, h, tend/h, 1);
  figure(1); clf; plot(tt,aa,'.-',tt,aa2,'o-');
  figure(2); clf; 
  for ii = 1:size(aa,1); plot(tt',[aa(ii,:); aa2(ii,:)]','.-'); title(num2str(ii)); pause;  end
  
%% solve ksfmfj flow with ode15s; identify local minima of norm(f)
  clear all;  L = 50;  d = 62;
  nu = (2*pi/L).^2;  a0 = zeros(d,1);
  randn('seed',12340003);  a0(1:7) = 0.5*randn(7,1);
  [t, a] = ode15s(@ksfmfj, [0 10], a0, [], nu);
  nt = length(t);
  x = (0:d+1)./(d+2)*L;
  u = real(ifft([zeros(1,nt); a(:,1:2:d-1)'+1i*a(:,2:2:d)'; zeros(1,nt); a(:,d-1:-2:1)'-1i*a(:,d:-2:2)'])).*(d+2);
  figure(1);  set(gcf,'pos',[40  80  300  850]);  
  pcolor(x,t,u'); shading flat;  set(gca,'pos',[.13 .04  .82 .92]);
  ng = zeros(nt,1); 
  for ii = 1:nt,
    f = ksfmfj(0, a(ii,:)', nu);  ng(ii) = norm(f);
  end,
  figure(2); clf; set(gcf,'pos',[350 640  1000  300]);
  plot(t, ng,'.-');  set(gca,'pos',[.04 .13 .92 .82]); grid on; hold on;
  im = find(ng(2:end-1)<2 & ng(2:end-1)-ng(1:end-2)<0 & ng(3:end)-ng(2:end-1)>0)+1;
  plot(t(im),ng(im),'ro');  ie = 0; return;
  for jm = 1:1,
    if 1,  % NA approach
      ae = kseqna(nu, a(im(jm),:)');
      ge = ksfmfj(0, ae, nu);
      disp(sprintf('%3d  %10.3e', jm, norm(ge)));
      if norm(ge) < 1e-4,
        ie = ie + 1;
        ue = real(ifft([0; ae(1:2:d-1)+1i*ae(2:2:d); 0; ae(d-1:-2:1)-1i*ae(d:-2:2)]));
        figure(3), plot(x,ue([i0:end 1:i0-1]),'.-'); hold on;
%        [ma,i0] = max(ue);  ve = fft(ue([i0:end 1:i0-1]));
%        figure(4); plot(abs(ve(3)),abs(ve(5)),'.'); hold on;
        figure(2), plot(t(im(jm)),0,'k*');
      end,
    else  % Polar decomposition approach
      ae = a(im(jm),:)';  ti = [0.35 2.25 100];
      for ii = 1:3,
        [fm,dfm] = ksfmfj(0, ae, nu);
        [u,s,v] = svd(dfm);  C = -v*u';
        [t, a] = ode15s(@ksfmfj, [0 ti(ii)], ae, [], nu, C);
        ae = a(end,:)';
      end,
    end,
  end,

%% Check correspondense between Fortran and Matlab output for ksfmedt
  d = 22;  N = 32;  x = (1:N)'./N*d;  q = 2*pi/d;  u = cos(0.5*q*x);
  v = ifft(u);  a0 = [real(v(2:N/2)) imag(v(2:N/2))]'; a0 = a0(:);
  a0 = zeros(N-2,1); a0(1:6) = 0.2*randn(6,1);
  [tt,aa,a0p,ap] = ksfmedt(d, 500, a0, 0.25, 4);
  figure(1); clf; plot(tt,aa(1:4,:),'.-'); 
  v = aa(1:2:end,:) + 1i*aa(2:2:end,:);
  v = [zeros(1,size(aa,2)); v; zeros(1,size(aa,2)); flipud(conj(v))];
  u = real(fft(v)); figure(2); clf; pcolor(x,tt,u'); shading flat;


%% Locating steady states of ksfm using fsolve
  clear;  load ks22uss3a;  a0 = [a0; zeros(32,1)];
  
  d = 22;  N = 32;  x = (1:N)'./N*d;  h = 0.25;  tpre = 10;  t0 = 50;
%  a0 = zeros(N-2,1);  a0(2) = 1; %randn('seed',12340019);  a0(1:8) = 0.3*randn(8,1);
  load ks22seed001a;
  [tt,aa] = ksfmedt(d, tpre, a0, h, 1);
  nap = zeros(size(aa,2),1);
  for ii = 1:size(aa,2), nap(ii) = norm(ksfm(t0,aa(:,ii),d)); end,
  [map,iap] = min(nap); tpre = tt(iap);
  figure(1); clf; plot(tt,nap,'.-',tpre,map,'ro'); pause;
  [tt,aa] = ksfmedt(d, tpre, a0, h); % aa = a0;
  options = optimset('Display','iter','Jacobian','on','TolFun',1e-9);
  tic; a0 = fsolve(@(a)ksfm(t0,a,d),aa,options); toc;
  [tt,aa] = ksfmedt(d, t0, a0, h, 1);
  nap = zeros(size(aa,2),1);
  for ii = 1:size(aa,2), nap(ii) = norm(ksfm(t0,aa(:,ii),d)); end,
  hold on; plot(tt,nap,'k.-');
  v = aa(1:2:end,:) + 1i*aa(2:2:end,:);
  v = [zeros(1,size(aa,2)); v; zeros(1,size(aa,2)); flipud(conj(v))];
  u = real(fft(v)); figure(2); clf; pcolor(x,tt,u'); shading flat;

%% Locating traveling wave with ksfmtr using fsolve
    clear;  d = 38.5;  N = 64;  h = 0.25;
    x = d.*(1:N)'./N;  np = 1;  tend = 200;
    a0 = zeros(N-2,1); randn('seed',12340000);  a0(1:8) = 0.2*randn(8,1);
    [tt, aa] = ksfmstp2(a0, d, h, tend/h, np);  na = size(aa,2);
    v = aa(1:2:end,:) + 1i*aa(2:2:end,:);
    v = [zeros(1,size(aa,2)); v; zeros(1,size(aa,2)); flipud(conj(v))];
    u = real(fft( v));  
    figure(1); clf; subplot(1,2,1); pcolor(x,tt,u'); shading flat; 
    k = (2*pi/d).*[0:N/2-1 0 -N/2+1:-1]';
    fa = repmat(k.^2.*(1-k.^2),1,na).*v + ...
         0.5i*repmat(k,1,na).*ifft(u.^2);
    c = (-.5:0.01:.5)';  nc = length(c); ha = zeros(nc,na);
    for ii = 1:nc,
      hc = fa(2:N/2,:) - 1i*c(ii)*repmat(k(2:N/2),1,na).*v(2:N/2,:);
      ha(ii,:) = sqrt(sum(hc.*conj(hc)));
    end,
    subplot(1,2,2);
%    contourf(c,tt,ha',[0:.01:.1]); shading flat; wide(1.1);  grid on;
    [mha,mc] = min(ha);  plot(c(mc),tt,'r.');  grid on; 
%    ic = 650; 
%    ic = 500;
%    ic = 48;
%    ic = 10;
    [ii,ic] = ginput(1);  ic = round(ic);
    options = optimset('Display','iter','Jacobian','off','TolFun',1e-9);
%    a0 = fsolve(@(a)ksfmtr(a,d),[aa(:,ic); c(mc(ic))],options); pause;
    a0 = fsolve(@(a)ksfmtr(a,d),[aa(:,ic); 0],options); pause;  % Find equilibria
%    for d = 18.5:.5:22,  disp(['L = ' num2str(d)]);
%      a0 = fsolve(@(a)ksfmtr(a,d),a0,options);  end,
    [xx,uu] = ksfm2real(a0(1:end-1), d);  figure(2); clf; plot(xx,uu,'.-');
    title(['c = ' num2str(a0(end))]);grid on;

%% Locating TW2
  clear; load ks22seed000a;  c = ph/tend;
  options = optimset('Display','iter','Jacobian','off','MaxFunEvals',20000,'TolFun',1e-9);
  a0 = fsolve(@(a)ksfmtr(a,d),[a0; c],options);
    
%%  Stability of the steady states and traveling wave
  clear; 
%  load ks22uss2b; c = 0;
%   load ks22uss3a; c = 0;
  load ks22utw2a;
  c = -c;  a0(1:2:end) = -a0(1:2:end);
%  a0 = [a0; zeros(32,1)];
  [f, df] = ksfm(0, a0, d);  na = length(a0);
  ik = 2*pi*c/d*(1:na/2)';  h = f;  
  h(1:2:end) = h(1:2:end) + ik.*a0(2:2:end);
  h(2:2:end) = h(2:2:end) - ik.*a0(1:2:end);
  
  dh = df;  
  dh(2:2*na+2:end) = dh(2:2*na+2:end) - ik';
  dh(na+1:2*na+2:end) = dh(na+1:2*na+2:end) + ik';
  [vdh, edh] = eig(dh);  edh = diag(edh);
  [sedh, ie] = sort(real(edh),1,'descend');
  edh = edh(ie);  vdh = vdh(:,ie);  disp(edh(1:10));

  
%% Locate steady states of ksfm using stabilising transformations.
  clear;
  d = 22;  N = 32;  x = (1:N)'./N*d;  h = 0.25;  tpre = 50;  t0 = 50;
  a0 = zeros(N-2,1);  randn('seed',12340021);  a0(1:8) = 0.3*randn(8,1);
  [tt,aa] = ksfmedt(d, tpre, a0, h, 1);
  nap = zeros(size(aa,2),1);
  for ii = 1:size(aa,2), nap(ii) = norm(ksfm(t0,aa(:,ii),d)); end,
  [map,iap] = min(nap); tpre = tt(iap);
  figure(3); clf; plot(tt,nap,'.-',tpre,map,'ro'); pause;
  [tt,aa] = ksfmedt(d, tpre, a0, h);
  [f,df] = ksfm(t0,aa,d); [u,s,v] = svd(df);  C = -v*u';
  options = odeset('Stats','on');
  tic; [tt, a0] = ode15s(@(t,a)ksfm(t,a,d,C),[0 500],aa,options); toc;
  a0 = a0(end,:)';  [tt,aa] = ksfmedt(d, t0, a0, h, 1);
  nap = zeros(size(aa,2),1);
  for ii = 1:size(aa,2), nap(ii) = norm(ksfm(t0,aa(:,ii),d)); end,
  disp(nap(1)); hold on; plot(tt,nap,'k.-');
  v = aa(1:2:end,:) + 1i*aa(2:2:end,:);
  v = [zeros(1,size(aa,2)); v; zeros(1,size(aa,2)); flipud(conj(v))];
  u = real(fft(v)); figure(4); clf; pcolor(x,tt,u'); shading flat;
  

%% Locate UPOs in ksfmedt flow
  clear;
  d = 22;  N = 32;  x = d.*(1:N)'./N;  h = 0.25;  tpre = 300;  t0 = 50;
  a0 = zeros(N-2,1);  randn('seed',12340005);  a0(1:8) = 0.2*randn(8,1);
  [tt, aa, a0p, ap] = ksfmedt(d, tpre, a0, h, 1);  na = size(aa,2);
  v = aa(1:2:end,:) + 1i*aa(2:2:end,:);
  v = [zeros(1,size(aa,2)); v; zeros(1,size(aa,2)); flipud(conj(v))]; u = real(fft(v));
  figure(1);  set(gcf,'pos',[5 35 250 910]); clf; 
  pcolor(x,tt,u'); shading flat;
  switch 1,
  case 1,  %%% Choose close return interactively
    cr = zeros(na);
    for ii = 1:size(aa,2),  cr(ii,:) = sqrt(sum((aa-repmat(aa(:,ii),1,na)).^2));
      cr(ii,:) = [cr(ii,ii:end) zeros(1,ii-1)]; end
    figure(2); set(gcf,'pos',[685 300 710 650]); clf;
    contourf(tt, tt, cr', 0:.4:2);  grid on;  xlabel('t_0');  ylabel('T','rotat',0);
    if 1,  [nb, ne] = ginput(1);  ne = ne + nb;
      nb = round(nb./(tt(2)-tt(1)));  ne = round(ne./(tt(2)-tt(1))); end
    a0 = aa(:,nb);  tend = tt(ne)-tt(nb);  disp([nb ne norm(aa(:,ne)-aa(:,nb))]);% return;
    figure(1); hold on; plot(x([1 end end 1]),tt([nb nb ne ne]),'k-');
  case 2,  %%% Close return after tpre within t0
    tpre = 50;  nb = min(find(tt>tpre));
    na = sqrt(sum((aa(:,nb:end)-repmat(aa(:,nb),1,size(aa(:,nb:end),2))).^2));  dna = diff(na);
    ie = find(dna(1:end-1) < 0 & dna(2:end) > 0);  ne = ie(4)+nb;
    figure(2); clf; plot(tt(nb:end)-tt(nb),na','g.-',tt(ie+nb),na(ie),'ro');  grid on;
    a0 = aa(:,nb);  tend = tt(ne)-tt(nb);  disp([tend na(ne)]);
    figure(1); hold on; plot(x([1 end end 1]),tt([nb nb ne ne]),'k-');
  case 3,  %%% Load seed from a file
    load ks22seed65a;
  end
%  N = 64; x = d.*(1:N)'./N; a0 = [a0; zeros(32,1)];
  switch 2,
  case 1,  %%% associated flow ksfmf1
    C = eye(N-2);  alpha = 10000;  ph = 0;
    options = odeset('reltol',1e-7,'outputfcn',@ksdupoplot);
    [s,y] = ode15s(@(t,a)ksfmf1(t,a,d,h,C,alpha), [0 100], [a0; tend], options);
    sv = input('Save final orbit? (y/n): ','s');
    if sv == 'y', fname = input('File name: ','s'); 
      a0 = y(end,1:end-1)';  tend = y(end,end);
      save(fname,'d','a0','tend'); end
%    a0 = y(end,1:end-2)';  tend = y(end,end-1);  ph = y(end,end);
%    save(fname,'d','a0','tend','ph'); end
  case 2,  %%% associated flow ksfmfm (with T from min |g| )
    global TT A F FT NFEVAL DD
    TT = tend;  C = eye(N-2);  DD = d;
    if 0,  [tt,aa,da] = ksfmjedt(d,tend,a0,h);  e = eig(da);  disp(e(1:5))
      switch 2,
      case 1, [u,C,v] = svd(da);  C = eye(N-2) - 2*u(:,1)*u(:,1)';
      case 2, [u,C,v] = svd(da-eye(N-2));  C = -v*u';
      end
    end
    options = odeset('abstol',1e-9,'reltol',1e-10,'outputfcn',@ksdupoplot3);
    [s,y] = ode15s(@(t,a)ksfmfl(t,a,d,h,C), [0 100], a0, options);
    sv = input('Save final orbit? (y/n): ','s');
    if sv == 'y', fname = input('File name: ','s');
      a0 = y(end,:)'; tend = TT(end); save(fname,'d','h','a0','tend'); end
  end

%% Locate UPOs of ksfmedt with constraint a(1) = 0 - doesn't work
  clear;
  d = 22; N = 32;  x = d.*(1:N)'./N;  h = 0.25;  tpre = 200;  t0 = 100;
  a0 = zeros(N-2,1);  randn('seed',12340000);  a0(2:9) = 0.1*randn(8,1);
  [tt, aa] = ksfmedt(d, tpre, a0, h, 1);
  figure(1); clf; plot(tt,aa(1:2,:),'.-');  grid on;
  i0 = find(aa(1,1:end-1) < 0 & aa(1,2:end) > 0);  ii0 = 3;
  a0 = aa(:,i0(ii0));  a0(1) = 0; 
  [tt, aa] = ksfmedt(d, t0, a0, h, 1);
  na = sqrt(sum((aa-repmat(aa(:,1),1,size(aa,2))).^2));  dna = diff(na);
  ie = find(dna(1:end-1) < 0 & dna(2:end) > 0);  iie = 2;
  figure(2); clf; plot(tt,na','g.-',tt(ie+1),na(ie+1),'ro');  grid on;
  tend = tt(ie(iie)+1); disp([tend na(ie(iie)+1)]);
  
  C = eye(N-3);  alpha = 5;
  options = odeset('reltol',1e-7,'outputfcn',@ksdupoplot);
  [s,y] = ode15s(@(t,a)ksfmf2(t,a,d,h,C,alpha), [0 1000], [a0(2:end); tend], options);


%% Locate UPOs of ksfmedt with fsolve (from close return seed)
  clear; load ks22seed66c;  h = 0.25;
  global NFEVAL hp1 hp2;  NFEVAL = 0;
  [tt, aa] = ksfmedt(d, tend, a0, h, 2);
  figure(3); clf; hp1 = plot(aa(1,:),aa(2,:),'.-'); grid on; hold on;
  plot(aa(1,1),aa(2,1),'ro',aa(1,end),aa(2,end),'ko');
  figure(5); clf;  N = size(aa,1)+2;  x = d.*(1:N)'./N;  
  v = aa(1:2:end,:) + 1i*aa(2:2:end,:);
  v = [zeros(1,size(aa,2)); v; zeros(1,size(aa,2)); flipud(conj(v))];
  u = real(fft(v)); hp2 = pcolor(x,tt,u'); shading flat; axis tight;
  options = optimset('Display','iter','MaxFunEvals',15000); %,'Jacobian','on','TolFun',1e-9);
  upo = fsolve(@(a)ksfmf3(a,d,h),[a0;tend],options);

%% Use UQOs as seeds
  clear;  d = 22;  N = 32;  x = d.*(1:N)'./N;  h = 0.25;
  load ks22uqo042a;  te = 200;
  [tt, aa, da] = ksfmjedt(d, tend, a0, h, 2);
  k = (-2i*pi/d).*(1:N/2-1)';  ek = exp(k.*ph);
  cda = repmat(ek,1,N-2).*(da(1:2:end,:)+1i*da(2:2:end,:));
  da(1:2:end,:) = real(cda);  da(2:2:end,:) = imag(cda); 
  [u,C,v] = svd(da-eye(N-2));  C = -v*u';
  eda = eig(C*(da-eye(N-2)));  
  [tt2, aa2, da2] = ksfmjedt(d, 2*tend, a0, h, 4);
  ek2 = exp(2.*k.*ph);
  cda = repmat(ek2,1,N-2).*(da2(1:2:end,:)+1i*da2(2:2:end,:));
  da2(1:2:end,:) = real(cda);  da2(2:2:end,:) = imag(cda);
  [v,e] = eig(da);  s = eye(N-2);  s(1,1) = -1;
  [u,C,v] = svd(v*s*e*inv(v)-eye(N-2));  C = -v*u';
  eda2 = eig(C*(da2-eye(N-2)));

%%
  v = ek.*(aa(1:2:end,end)+1i*aa(2:2:end,end));
  ap = a0;  ap(1:2:end) = real(v);  ap(2:2:end) = imag(v);
  figure(3); clf; 
  plot([aa(1,:) ap(1)],[aa(2,:) ap(2)],'.-',aa(1,1),aa(2,1),'ko');  grid on;
  [tt, aa] = ksfmedt(d, te, a0, h, 2);  
  figure(2);  clf;  phase = (-0.5:0.01:0.49)'*d;
  v = aa(1:2:end,:)+1i*aa(2:2:end,:);
  fac = exp(k*phase');  cr = zeros(size(fac,2),size(v,2));
  for ii = 1:size(fac,2),
    cr(ii,:) = sqrt(sum(abs(v.*repmat(fac(:,ii),1,size(v,2)) - ...
                    repmat(v(:,1),1,size(v,2))).^2)); end
  contourf(tt,phase,cr,[0:.2:1]); shading flat;
  [tend, ph] = ginput(1);  ek = exp(k.*ph);
  cda = repmat(ek,1,N-2).*(da(1:2:end,:)+1i*da(2:2:end,:));
  da(1:2:end,:) = real(cda); da(2:2:end,:) = imag(cda); 
  eda = eig(da); [me,ie] = sort(abs(eda),'descend'); disp(eda(ie(1:5))');
  [u,C,v] = svd(da-eye(N-2));  C = -v*u';

%% Convert real-space initial condition to fourier modes
% function a0 = rs2fm(u0)
  clear; d = 13;  N = 32;  sig = 0.2;  np = 4;  h = 0.25;
  x = d.*(1:N)'./N;  u0 = (x-d/2).*exp(-(x-d/2).^2/(2*(2*pi*sig).^2));  u0(end) = 0;
  v0 = ifft(u0);  a0 = zeros(N-2,1);  
  a0(1:2:end) = real(v0(2:N/2));  a0(2:2:end) = imag(v0(2:N/2));
  a0 = zeros(N-2,1); a0(1:8) = 0.1*randn(8,1);
  [tt, aa] = ksfmedt(d, 100, a0, h, np);  na = size(aa,2);
  v = aa(1:2:end,:) + 1i*aa(2:2:end,:);
  v = [zeros(1,size(aa,2)); v; zeros(1,size(aa,2)); flipud(conj(v))];
  u = real(fft(v)); 
  figure(1); clf; pcolor(x,tt,u'); shading flat; tall(1.1); hold on;
  if 0,  figure(2); clf; 
    for ii = 1:size(u,2),  plot(x,u(:,ii),'.-'); 
      title(['Time: ' num2str(h*np*(ii-1))]); grid on; pause; end, end

%% ===Locate UQOs of ksfmedt===
  clear;  load kse22orbits; 
  L = 22; N = 32; h = 0.25; d = L; global PFLG
  switch 1,  %%% Switch for seed selection
  case 1,  %%% Find close returns with a shift
    x = L.*(1:N)'./N; np = 4; tpre = 600; tb = 45; te = 200;  
    iav = 0; msflag = 1; PFLG = -1;
    if 1,
      a0 = zeros(N-2,1); randn('seed',22010017); a0(1:8) = 0.2*randn(8,1);
%      a0(1:4) = [-.7 .5 .2 .3];
    else
%      a0 = 0.1*ones(N-2,1); end,
%      load ks22utw1a; %a0(1:2:end) = -a0(1:2:end);
%      load ks22uss1a; %a0(3) = a0(3)+1e-2;
%       a0 = eq(1).a(1:N-2) + 1e-4.*imag(eq(1).evec(1:N-2,1));     
%      load ks22seed062b;
      load ks22upo070a;  msflag = 0;  PFLG = -1;
%      a0(1:2:end) = -a0(1:2:end);
%      load ks50rpo070a;
%      load ks22uss2a;  msflag = 1;
%      load ks22seed2w3w; a0 = a1; clear a1;
    end
    [tt, aa] = ksfmetd2(a0, L, h, tpre, np);  na = size(aa,2);
    v = aa(1:2:end,:) + 1i*aa(2:2:end,:);
    v = [zeros(1,size(aa,2)); v; zeros(1,size(aa,2)); flipud(conj(v))];
    u = real(fft(v));
    figure(1); set(gcf,'pos',[5 35 250 910]); clf; 
    pcolor(x,tt,u'); shading flat; tall(1.1); hold on;
    hp1 = plot(x([1 end]),tt([1 1]),'k-'); pause;
    figure(2); set(gcf,'pos',[263 344 1135 600]); clf; ib = 0;
    while 1,
      nb = min(round(tb/(h*np))+ib, length(tt));
      ne = min(round(te/(h*np))+nb+1, length(tt));
      set(hp1,'xdata',[x([1 end]);NaN;x([end 1])],'ydata',[tt([nb nb]) NaN tt([ne ne])]);
      a0 = aa(:,nb);  phase = (-0.51:0.01:0.51)'*L;
      v = aa(1:2:end,nb-iav:ne+iav)+1i*aa(2:2:end,nb-iav:ne+iav);  k = (1:N/2-1)';
      fac = exp((-2i*pi./L).*k*phase');  cr = zeros(size(fac,2),size(v,2)-2*iav);
      if PFLG == -1,
        for ii = 1:size(fac,2), for iia = -iav:2:iav,
          cr(ii,:) = cr(ii,:) + ...
            sqrt(sum(abs(-conj(v(:,iia+iav+1:end+iia-iav)).*repmat(fac(:,ii),1,size(v,2)-2*iav) - ...
            repmat(v(:,iia+iav+1),1,size(v,2)-2*iav)).^2)) ...
          ./(iav+1); end, end
%          ./sqrt(sum(abs(repmat(v(:,iia+iav+1),1,size(v,2)-2*iav)).^2))...
      else
        for ii = 1:size(fac,2), for iia = -iav:2:iav,
          cr(ii,:) = cr(ii,:) + ...
            sqrt(sum(abs(v(:,iia+iav+1:end+iia-iav).*repmat(fac(:,ii),1,size(v,2)-2*iav) - ...
            repmat(v(:,iia+iav+1),1,size(v,2)-2*iav)).^2))...
          ./(iav+1); end, end
%          ./sqrt(sum(abs(repmat(v(:,iia+iav+1),1,size(v,2)-2*iav)).^2))...
      end
      contourf(tt(nb:ne)-tt(nb),phase,cr,[0:.1:1]*.8); caxis([0 .8]); shading flat;
%      contourf(phase,tt(nb:ne)-tt(nb),cr',[0:.1:1]); shading flat;
      hold on; plot([1;1]*[rpo.T],[1;-1]*[rpo.d],'w.','markersize',10);
      [mcr,rcr] = min(cr); [mmcr, ccr] = min(mcr(9:end)); ccr = ccr + 8;
      plot(tt(nb-1+ccr)-tt(nb),phase(rcr(ccr)),'r.','markersize',16);
      set(gca,'pos',[0.06 0.08 0.90 0.86]); hold off;
      title(sprintf('%4d  %6.2f  %6.2f  %6.3f  %6.4f',ib,tt(nb),tt(nb-1+ccr)-tt(nb),phase(rcr(ccr)),mmcr)); 
      [tend, ph, but] = ginput(1); 
      disp(sprintf('%4d %2d %6.2f  %6.2f %6.3f %6.4f',ib,but,tt(nb),tt(nb-1+ccr)-tt(nb),phase(rcr(ccr)),mmcr)); 
      if but == 46, ib = ib + 1; elseif but == 44, ib = ib - 1;
      elseif but == 109, tend = tt(nb-1+ccr)-tt(nb); ph = phase(rcr(ccr));
        hold on; plot(tend,ph,'k.','markersize',8); hold off; break;
      elseif but == 32, hold on; 
        plot(tend,ph,'k.','markersize',8); hold off; break; end, end
  case 2,  %%% Load seed from a file
%    load ks50rpo009c;  msflag = 0; PFLG = 1;
    load ks22uqo169a;  msflag = 0; PFLG = 1;
%    load ks22upo146a;  msflag = 0; PFLG = -1; tend = tend/2;
%    load ks22uqo125a;  tend = 44.75; ph = 1; msflag = 0;  PFLG = 1;
%    load ks22uss2a; msflag = 0;
%    load ks22seed151a; %tend = 125.2;  ph = 5.26;
  end;
  for sw = 5, %[2,1,3],
  switch sw, %%% Switch for method selection
  case 1,   %%% Find UQOs by associated flow
    alpha = [1e0 1e0];
    for ic = 1:20,
      switch 2,
      case 0,  C = eye(N-2);
      case 1, format short g;
        [g, jac] = ksfmf5(0,[a0;tend;ph],L,h,eye(N),alpha);
        disp(['|g|=' num2str(norm(g(1:end-2)))]);  de = eig(jac(1:end-2,1:end-2)+eye(N-2)); 
        [se,ie]=sort(abs(de),'descend');  disp(de(ie(1:10)));
        [u,C,v] = svd(jac(1:end-2,1:end-2)); C = blkdiag(-v*u',eye(2)); format short;
      case 2, format short g;
        [g, jac] = ksfmf5(0,[a0;tend;ph],d,h,eye(N),alpha);
        disp(['|g|=' num2str(norm(g(1:end-2)))]);  de = eig(jac(1:end-2,1:end-2)+eye(N-2)); 
        [se,ie]=sort(abs(de),'descend'); disp(de(ie(1:10))); [u,C,v] = svd(jac);
        if 1, atol = 1e-5./max(diag(C)); rtol = 10*atol;
          disp(['atol = ' num2str(atol) '  rtol = ' num2str(rtol)]);
        else atol = 1e-13;  rtol = 1e-12; end
        C = -v*u'; format short; end,
      options = odeset('abstol',atol,'reltol',rtol,'outputfcn',@ksdupoplot4);
      [s,y] = ode15s(@(t,a)ksfmf5(t,a,d,h,C,alpha), [0 100000], [a0; tend; ph], options);
      a0 = y(end-1,1:end-2)'; tend = y(end-1,end-1), ph = y(end-1,end),
      but = input('Stop? ','s');  if but == 'y', break; end, end
    figure(2); hold on;  plot(tend,ph,'ko','markersize',7); hold off;
  case 2,   %%% Find UQOs using fsolve
    C = eye(N-2);  alpha = [1e0 1e0];  te = 0;
    options = optimset('Display','iter','outputfcn',@ksoutfun2,'MaxIter',5000, ...
      'MaxFunEvals',100000,'Jacobian','on','NonlEqnAlgorithm','lm','TolX',1e-12,'TolFun',1e-12);
    [upo,fval,eflag] = fsolve(@(a)ksfmf5new(te,a,d,h,C,alpha),[a0;tend;ph],options);
    a0 = upo(1:end-2); tend = upo(end-1), ph = upo(end),
    figure(2); hold on; plot(tend,ph,'ko','markersize',6); hold off;
  case 3,   %%% Use multiple shooting (ksfmfns)
    ni = [round(tend/12) 0];  ni(2) = ceil(tend./(h.*(ni(1)+1)));
    disp(['Using multiple shooting: ' num2str(ni)]);
    [tt, aa] = ksfmedt(L, tend, a0, h, ni(2)); ni(1) = ni(1)-1;
    ai = aa(:,1:end-2);  ai = [ai(:); tend-ni(1)*ni(2)*h; ph];
    gi = ksfmfns(ai, L, h, ni);  disp(['|gms| = ' num2str(norm(gi))]);
    options = optimset('Display','iter', 'outputfcn',@ksoutfun2,'MaxIter',2000, ...
      'MaxFunEvals',500000,'Jacobian','off','NonlEqnAlgorithm','lm','TolX',1e-12,'TolFun',1e-12);
    upo = fsolve(@(ai)ksfmfns(ai,L,h,ni),ai,options);
    a0 = upo(1:(length(upo)-2)/(ni(1)+1));  
    tend = upo(end-1)+ni(1)*ni(2)*h;  ph = upo(end);
    figure(2); hold on; plot(tend,ph,'ko','markersize',6); hold off;
  case 4,   %%% Use multiple shooting with variable stepsize (ksfmmult2)
    if msflag == 1, np = round(tend/6.0);  else  np = 1;  end
    nstp = round(tend./h);  mstp = round(nstp/np);
    if 0, hh = tend./nstp; else hh = h; tend = h.*nstp, end
    disp(['Using multiple shooting: ' num2str([np (hh-h)./h])]);
    if np > 1, [tt, aa] = ksfmstp(a0, L, hh, mstp*(np-1), mstp); ai = [aa(:); hh*nstp; ph];
    else ai = [a0; hh*nstp; ph]; end
    gi = ksfmmult2(ai, L, nstp, np);  disp(['|gms| = ' num2str(norm(gi))]);
    options = optimset('Display','on','DerivativeCheck','off','outputfcn',@ksoutfun2,'MaxIter',2000, ...
      'MaxFunEvals',500000,'Jacobian','on','NonlEqnAlgorithm','lm','TolX',1e-12,'TolFun',1e-12);
    upo = fsolve(@(ai)ksfmmult2(ai,L,nstp,np),ai,options);
    a0 = upo(1:N-2);  tend = upo(end-1);  ph = upo(end);  h = tend./nstp;
    figure(2); hold on; plot(tend,ph,'ko','markersize',6); hold off;
  case 5,   %%% Use multiple shooting (ksfmms)
    if msflag == 1, np = round(tend/6.0);  else  np = 1; end
    nstp = floor(tend./h);  mstp = floor(nstp./np);
    disp(['Using multiple shooting: ' num2str([np mstp]) '  ' num2str(tend-h*mstp*(np-1))]);
    if np > 1, [tt, aa] = ksfmstp(a0, L, h, mstp*(np-1), mstp); ai = [aa(:); tend; ph];
    else ai = [a0; tend; ph]; end
    global AM  %'outputfcn',@ksoutfun2,
    for ic = 1:20, gi = ksfmms3(ai, L, h, mstp, np); disp(['|gms| = ' num2str(norm(gi))]);
      options = optimset('Display','on','outputfcn',@ksoutfun2,'DerivativeCheck','off','MaxIter',10000, ...
        'MaxFunEvals',500000,'Jacobian','on','NonlEqnAlgorithm','lm','TolX',1e-12,'TolFun',1e-12);
      upo = fsolve(@(ai)ksfmms3(ai,L,h,mstp,np),ai,options); ai = AM; 
      but = input('Stop? ','s');  if but == 'y', break; end, end
    a0 = upo(1:N-2);  tend = upo(end-1);  ph = upo(end);  
    if PFLG == -1, tend = 2.*tend,  ph = 0, end
    figure(2); hold on; plot(tend,ph,'ko','markersize',6); hold off;
  case 6,   %%% Use Kelley's solver with ksfmms
    if msflag == 1, np = round(tend/6.0);  else  np = 1; end
    nstp = floor(tend./h);  mstp = floor(nstp./np);
    disp(['Using multiple shooting: ' num2str([np mstp]) '  ' num2str(tend-h*mstp*(np-1))]);
    if np > 1, [tt, aa] = ksfmstp(a0, L, h, mstp*(np-1), mstp); ai = [aa(:); tend; ph];
    else ai = [a0; tend; ph]; end
    for ic = 1:1,
      gi = ksfmms(ai, L, h, mstp, np);  disp(['|gms| = ' num2str(norm(gi))]);
      parms = [1000, -1, 0.5, 0];
      [upo, it_hist, ierr, x_hist] = nsold0(ai,@(a)ksfmms(a,L,h,mstp,np),[1e-12 1e-12],parms);
      if ierr == 3, ai = upo; end, end 
    a0 = upo(1:N-2);  tend = upo(end-1);  ph = upo(end);
    figure(2); hold on; plot(tend,ph,'ko','markersize',6); hold off;
  case 7,   %%% Find UQOs using lsqnonlin
    C = eye(N-2);  alpha = [1 1];
    options = optimset('Display','on','outputfcn',@ksoutfun,'MaxIter',2000,'Jacobian','on');
    lb = [repmat(-5,N-2,1);0;-d];  ub = [repmat(5,N-2,1);300;d];
    upo = lsqnonlin(@(a)ksfmf5new(te,a,d,h,C,alpha),[a0;tend;ph],lb,ub,options);
  end, end


%% List all located UPOs and UQOs
  clear;  
  lst = dir('ks22uqo169*.mat');  nst = length(lst);
%  lst = dir('ks50rpo009*.mat');  nst = length(lst);
  for ist = 1:nst,  load(lst(ist).name);  N = length(a0)+2;
    g = ksfmf5new(tend, [a0; tend; ph], d, h, eye(N-2), [1 1]);
    disp(sprintf('    ''%15s'';%% %10.6f %10.6f %12.3e',lst(ist).name, tend, ph, norm(g(1:end-2))));  end

%% Plot all located UPOs and UQOs
  switch 22,
  case 22,  
    clear;  name = [
%    'ks22uqo008a.mat';%   7.889874   5.812044   9.647e-016  <-- RE1

    'ks22uqo016a.mat';%  16.316170   2.863787   1.726e-014
    'ks22uqo020a.mat';%  20.506740   0.000000   1.844e-007
    'ks22uqo033b.mat';%  32.806180  10.956763   9.982e-014
    'ks22uqo034a.mat';%  33.501034   4.045869   2.419e-013
    'ks22uqo035a.mat';%  34.639120   9.599483   1.825e-014
    'ks22uqo036a.mat';%  36.016825   3.911040   3.362e-011

    'ks22uqo036d.mat';%  36.205721   3.813489   1.018e-013
    'ks22uqo040b.mat';%  39.770736  -1.610607   1.812e-008
    'ks22uqo040d.mat';%  40.145637  -3.699441   8.866e-013
    'ks22uqo042a.mat';%  41.507477   6.479327   2.200e-008
    'ks22uqo045a.mat';%  44.709656 -10.605822   1.086e-013
    'ks22uqo046b.mat';%  46.052353   7.624041   2.406e-013

    'ks22uqo047c.mat';%  46.502291  -7.758333   1.318e-013
    'ks22uqo047a.mat';%  47.323866   0.339464   8.331e-012
    'ks22uqo048a.mat';%  47.639322   5.675918   5.407e-010
    'ks22uqo054a.mat';%  53.866635  -2.328494   2.062e-013
    'ks22uqo055a.mat';%  54.843160  -3.130555   1.757e-012
    'ks22uqo056a.mat';%  55.599640  -5.247831   4.996e-014

    'ks22uqo058a.mat';%  57.662172  -0.847445   1.767e-013
    'ks22uqo060b.mat';%  59.669128   3.979569   4.129e-013
    'ks22uqo060a.mat';%  59.892457  -5.442530   2.973e-012
    'ks22upo065a.mat';%  64.722989   0.000000   1.394e-013
    'ks22uqo065b.mat';%  64.999343   4.719593   5.821e-014
    'ks22uqo065a.mat';%  65.193986  -6.373938   1.777e-012
    
    'ks22uqo066b.mat';%  65.540700  -0.582016   3.726e-009
%    'ks22uqo066a.mat';%  65.612385   0.086473   1.671e-014  (33b x 2)
    'ks22uqo066c.mat';%  65.780140   0.663064   1.123e-013
    'ks22uqo067c.mat';%  66.779339   0.000003   3.074e-014
%    'ks22uqo067d.mat';%  67.002067   8.091738   4.233e-014  (34a x 2)

    'ks22uqo068a.mat';%  67.939003   5.566339   6.073e-014
    'ks22uqo068e.mat';%  68.223923   1.706300   2.994e-008
    'ks22uqo069a.mat';%  68.537305   4.925039   4.496e-014
    'ks22uqo069b.mat';%  69.065162  -9.700812   3.349e-013
    'ks22uqo070c.mat';%  69.855654   1.770866   6.012e-014
    'ks22uqo070a.mat';%  70.190722   0.721829   8.305e-012

    'ks22uqo070b.mat';%  70.267324  -7.241052   8.882e-015
    'ks22upo070a.mat';%  70.339625  -0.000002   2.805e-014
    'ks22uqo071a.mat';%  70.900766   9.014213   1.653e-013
    'ks22uqo072a.mat';%  71.678083   5.502827   1.717e-014
    
%    'ks22uqo072b.mat';%  72.411828  -7.626821   2.400e-012  (36d x 2)
    'ks22uqo073c.mat';%  72.547491  -8.189052   4.197e-013
    'ks22uqo073b.mat';%  72.866872  -9.917343   1.795e-012
    'ks22uqo073a.mat';%  73.373919   7.207963   7.750e-014
    'ks22uqo074a.mat';%  73.980562   0.678530   8.188e-013  
    'ks22uqo074c.mat';%  74.380749   4.434083   6.562e-009
    
    'ks22uqo075b.mat';%  75.327068  -3.583450   3.522e-013
    'ks22uqo075a.mat';%  75.483577  -6.235556   2.078e-009  
    'ks22uqo076a.mat';%  76.300749  -7.140903   1.608e-013
    'ks22uqo077a.mat';%  76.556365  -3.383947   3.993e-009
    'ks22uqo077c.mat';%  76.604718  -1.677121   1.458e-014
    'ks22upo077a.mat';%  77.320016  -0.000001   4.258e-013
    
    'ks22uqo078c.mat';%  77.831846 -10.791235   4.383e-014
    'ks22uqo078a.mat';%  78.194219   4.842480   3.825e-008
    'ks22uqo079b.mat';%  78.814091   6.710732   5.464e-014
    'ks22uqo079c.mat';%  79.424098  -5.196330   3.916e-014
    'ks22uqo079a.mat';%  79.508303   8.872265   4.198e-009
    'ks22uqo080c.mat';%  79.563025   2.815518   4.673e-013

    'ks22uqo080b.mat';%  80.000539   1.802967   4.775e-013
    'ks22uqo080a.mat';%  80.253902  -8.305024   1.442e-013
    'ks22uqo081b.mat';%  80.568032   3.753738   1.477e-013
    'ks22uqo081a.mat';%  80.868624   1.049921   8.927e-009
    'ks22upo082a.mat';%  82.153137  -0.000001   4.115e-013
    'ks22uqo082a.mat';%  82.182936   3.031967   2.138e-013

    'ks22upo083a.mat';%  83.100163  -0.000000   3.016e-013
    
    'ks22uqo084a.mat';%  84.086527 -10.061069   2.248e-013
    'ks22uqo084b.mat';%  84.439682  -5.512903   3.416e-013
    'ks22uqo085c.mat';%  84.574582   8.768221   7.311e-014
    'ks22uqo085a.mat';%  84.989461   4.275548   3.647e-010
    'ks22uqo086a.mat';%  85.744395   4.680305   4.288e-013
    'ks22uqo086c.mat';%  85.840717  -5.502822   9.167e-015
    
    'ks22uqo086d.mat';%  86.068044  -5.126499   2.367e-014
    'ks22uqo086b.mat';%  86.230820 -10.642809   6.009e-014
    'ks22uqo087b.mat';%  86.880781   5.530195   1.565e-012
    'ks22uqo087a.mat';%  87.236323   0.000001   5.367e-014
    'ks22uqo088b.mat';%  87.867269   4.968102   3.607e-014
    'ks22uqo088a.mat';%  88.475386 -10.078385   1.277e-013
    
    'ks22uqo089c.mat';%  88.616419  -6.209569   9.673e-014
    'ks22uqo089d.mat';%  88.928442  -7.493811   8.633e-010
    'ks22uqo089b.mat';%  89.397624  -0.472671   1.560e-012
    'ks22uqo089a.mat';%  89.419325  -0.788367   3.061e-014
    'ks22uqo091a.mat';%  91.354619   0.083919   1.993e-008
    'ks22uqo093a.mat';%  92.543339  -4.620769   1.243e-013

    'ks22upo093a.mat';%  93.021612   0.000000   1.966e-012
    'ks22uqo094b.mat';%  93.626071  -8.249659   6.477e-012
    'ks22upo094a.mat';%  93.811125  -0.000003   4.176e-013
    'ks22uqo094a.mat';%  94.045042  -6.395471   1.020e-010    
    'ks22upo095a.mat';%  94.923312  -0.000000   1.821e-014
    'ks22uqo095a.mat';%  95.252982  -0.000001   1.432e-013

    'ks22uqo096b.mat';%  96.053538  -3.774012   5.968e-013
    'ks22uqo096d.mat';%  96.243585  -4.605318   3.901e-014
    'ks22uqo096c.mat';%  96.398132   0.000021   1.365e-013
    'ks22uqo096a.mat';%  96.421035 -10.911410   9.371e-009 <- deleted
    'ks22uqo097a.mat';%  97.325533 -10.732688   1.886e-013
    'ks22uqo098d.mat';%  97.738506   4.791193   7.300e-012

    'ks22uqo098a.mat';%  98.254857  10.847250   4.403e-012
    'ks22uqo098b.mat';%  98.446990  -1.814935   6.338e-012
    'ks22uqo100a.mat';%  99.612756 -10.969248   8.981e-014
    'ks22uqo100b.mat';%  99.877490  -0.519880   3.599e-012
    'ks22uqo100d.mat';%  99.985049   5.972741   2.096e-012
    'ks22uqo100c.mat';% 100.447577  -5.435634   1.412e-013
    
    'ks22uqo101a.mat';% 101.181669  -2.794991   8.380e-014
    'ks22uqo103f.mat';% 102.692621  -1.511350   3.129e-013
    'ks22uqo102a.mat';% 102.789293  -9.206443   1.953e-012
    'ks22uqo103g.mat';% 102.845398  -4.622431   1.218e-013
    'ks22uqo103e.mat';% 102.858543  -8.966683   6.154e-014
    'ks22uqo103d.mat';% 102.984696   6.039250   7.677e-013
    
    'ks22uqo103a.mat';% 103.013668   1.006582   3.270e-013
    'ks22uqo103b.mat';% 103.066535   6.743595   2.427e-013
    'ks22uqo103h.mat';% 103.067700   0.664722   6.818e-013
    'ks22uqo103c.mat';% 103.160875   3.911896   1.539e-012
    'ks22uqo104a.mat';% 103.712763   4.907911   7.736e-014
    'ks22uqo104c.mat';% 104.090768  -4.568356   6.976e-013
    
    'ks22uqo104b.mat';% 104.456725   6.132433   3.093e-014
    'ks22uqo105c.mat';% 104.537756   4.837363   1.495e-012
    'ks22uqo105a.mat';% 105.426220   0.212326   3.732e-012
    'ks22uqo105b.mat';% 105.489600   7.224473   3.984e-013
    'ks22uqo106a.mat';% 105.755691  -9.329084   1.425e-012
    'ks22uqo106b.mat';% 105.935059  -4.194456   4.307e-011

    'ks22uqo107a.mat';% 107.269635  10.336297   3.588e-010
    'ks22uqo107b.mat';% 107.330174   4.489813   1.577e-012
    'ks22uqo108b.mat';% 107.681157  -4.491332   1.956e-012
    'ks22uqo108a.mat';% 108.078928 -10.270938   1.988e-011
    'ks22uqo108c.mat';% 108.281056  -7.611592   1.294e-013
    'ks22uqo109f.mat';% 108.603532  -7.656845   2.132e-012
    
    'ks22uqo109e.mat';% 108.907021   4.187748   4.076e-012
    'ks22uqo109b.mat';% 109.115133  -6.089034   4.053e-008
    'ks22uqo109d.mat';% 109.288714   0.184272   3.416e-010
    'ks22uqo110a.mat';% 109.961306  -5.711897   1.547e-007 
    'ks22uqo110b.mat';% 110.253208   0.790874   1.053e-009
    'ks22uqo111c.mat';% 110.613216 -10.269099   4.265e-013
    
    'ks22uqo111b.mat';% 110.881760  -3.069197   2.070e-013
    'ks22uqo111e.mat';% 111.115452  -4.657268   3.407e-012
    'ks22uqo111d.mat';% 111.199218   9.433053   2.602e-013
    'ks22uqo111a.mat';% 111.256292   7.788527   7.935e-013
    'ks22uqo112a.mat';% 111.535813  -0.219776   1.327e-013
    'ks22uqo112e.mat';% 111.576697   1.268022   2.261e-011

    'ks22uqo112d.mat';% 111.628790   8.302648   2.114e-013
    'ks22uqo112b.mat';% 112.031992   5.448170   1.488e-013
    'ks22uqo112f.mat';% 112.044745   5.493891   2.968e-013
    'ks22uqo112c.mat';% 112.180089  -0.074704   8.244e-013
    
    'ks22uqo112g.mat';% 112.237027  -1.871074   1.580e-013
    'ks22uqo113b.mat';% 112.684863  -2.182842   1.782e-013
    'ks22uqo113c.mat';% 112.870371   7.661806   5.416e-013
    'ks22uqo113a.mat';% 113.664192  -9.847374   8.846e-014
    'ks22uqo114a.mat';% 114.428065   3.586259   6.805e-013
    'ks22uqo114b.mat';% 114.482143  -4.271118   7.135e-013
    
    'ks22uqo115a.mat';% 114.769360   4.912638   4.734e-013
    'ks22uqo115b.mat';% 115.149392  -0.453798   1.362e-013
    'ks22uqo116a.mat';% 115.982689  -7.711219   6.229e-012
    'ks22uqo117c.mat';% 116.767957   0.407063   1.904e-011
    'ks22uqo117d.mat';% 116.901553   4.805835   3.805e-011
    'ks22uqo117a.mat';% 116.905525   6.640941   4.431e-010
    
    'ks22uqo117b.mat';% 117.437473   9.914628   7.289e-013
    'ks22uqo117e.mat';% 117.496067  -6.553523   8.606e-013
    'ks22uqo118a.mat';% 117.895473  -7.474551   1.618e-013
    'ks22uqo118c.mat';% 118.071348   5.312605   1.086e-012
    'ks22uqo118b.mat';% 118.250408   0.747751   5.148e-013
    'ks22uqo119a.mat';% 118.761396   4.707699   1.076e-013

    'ks22upo119a.mat';% 118.876441  -0.000010   3.983e-006
    'ks22uqo120a.mat';% 119.556928   8.312556   4.791e-010
    'ks22uqo120b.mat';% 119.947182   6.921632   9.420e-012
    'ks22uqo120c.mat';% 120.064292   7.352324   2.663e-013
    
    'ks22uqo120d.mat';% 120.279488   6.445854   1.266e-013
    'ks22uqo121a.mat';% 120.695148  -5.550172   8.231e-012
    'ks22uqo122c.mat';% 121.682139   5.899395   9.069e-013
    'ks22uqo122a.mat';% 121.716005  10.740138   4.017e-010
    'ks22uqo122b.mat';% 122.493342  -4.008438   2.012e-012
    'ks22uqo123a.mat';% 122.823942  10.416812   4.744e-013

    'ks22uqo123b.mat';% 123.136374   1.651543   1.480e-012
    'ks22uqo124a.mat';% 123.990847   1.434550   1.671e-013
    'ks22uqo125c.mat';% 124.664266  10.534138   4.067e-012
    'ks22uqo125a.mat';% 125.021554   9.062346   1.971e-012
    'ks22uqo125b.mat';% 125.492496  -4.934292   2.910e-013
    'ks22uqo126b.mat';% 125.905296   7.153932   1.102e-013
    
    'ks22uqo126a.mat';% 126.193329  -3.992781   2.909e-009
    'ks22uqo127c.mat';% 126.756021  11.536072   1.929e-012
    'ks22uqo127d.mat';% 126.888703  -6.452584   4.869e-014
    'ks22uqo127a.mat';% 127.126195   7.157910   9.227e-013
    'ks22upo127a.mat';% 127.195176  -0.000020   6.574e-011
    'ks22uqo127b.mat';% 127.290946   2.031982   7.409e-012
    
    'ks22uqo128b.mat';% 127.526866   0.826251   1.674e-012
    'ks22uqo128a.mat';% 127.626882   0.662288   2.362e-012
    'ks22uqo128d.mat';% 127.984507   2.907110   2.889e-012
    'ks22uqo128c.mat';% 128.371655   6.586471   1.420e-011
    'ks22uqo129b.mat';% 128.979698   2.579730   1.328e-011
    'ks22uqo129a.mat';% 129.485734  -2.139248   1.103e-011

    'ks22upo130a.mat';% 130.325961   0.000002   5.218e-011
    'ks22uqo130a.mat';% 130.438430  -5.047473   3.046e-013
    'ks22uqo131a.mat';% 131.077250  -5.940997   5.444e-013
    'ks22uqo132b.mat';% 131.981245   1.342006   1.397e-012    
    'ks22uqo132c.mat';% 132.012670 -10.918138   6.385e-010
    'ks22upo133a.mat';% 132.638412  -0.000001   3.223e-014
    
    'ks22uqo133a.mat';% 132.696432  -0.015114   7.568e-013
    'ks22uqo133b.mat';% 133.030048   5.310700   3.773e-012
    'ks22uqo134a.mat';% 133.554049  -4.960788   4.720e-010 <- not converged
    'ks22uqo135c.mat';% 134.680782  -8.978079   1.013e-012
    'ks22uqo135d.mat';% 134.953097   5.499864   5.577e-009 <- ???
    'ks22uqo135b.mat';% 135.059012  -7.581623   6.654e-012
    
    'ks22uqo135a.mat';% 135.065036  -4.898096   2.916e-012
    'ks22uqo136a.mat';% 135.614655 -10.092283   1.998e-012
    'ks22uqo136c.mat';% 135.715849   2.047110   4.442e-013
    'ks22uqo136f.mat';% 135.820287  -1.918698   3.116e-012
    'ks22uqo136g.mat';% 135.834684   2.167807   4.868e-012
    'ks22uqo136e.mat';% 135.883772   6.246869   1.154e-012
    
    'ks22uqo136d.mat';% 135.909982   8.382122   1.950e-011
    'ks22uqo136b.mat';% 136.065427   3.834442   2.098e-013
    'ks22uqo137b.mat';% 137.035391   7.596682   5.901e-013

    'ks22uqo137a.mat';% 137.141386   6.659719   9.093e-013
    'ks22uqo138c.mat';% 137.711393  -9.577647   2.806e-012
    'ks22uqo138a.mat';% 137.834092  -9.251266   1.654e-011
    'ks22upo138a.mat';% 138.163981  -0.000005   2.113e-013
    'ks22uqo138b.mat';% 138.490137   1.571869   6.548e-013
    'ks22upo139a.mat';% 138.564844   0.000002   4.748e-013

    'ks22uqo139e.mat';% 138.690521  -3.048239   1.492e-011
    'ks22uqo139b.mat';% 138.903098  -1.530682   4.172e-012
    'ks22uqo139a.mat';% 139.219781   5.790933   4.777e-012
    'ks22uqo139c.mat';% 139.256549   5.389937   9.505e-014
    'ks22uqo140c.mat';% 139.511352   5.733547   9.944e-014
    'ks22upo140a.mat';% 139.560447   0.000001   3.182e-012
    
    'ks22uqo140b.mat';% 139.676829   7.020855   2.335e-011
    'ks22uqo140e.mat';% 140.020477  -5.390183   6.217e-013
    'ks22uqo140a.mat';% 140.031772   5.136071   5.650e-009
    'ks22uqo140d.mat';% 140.327931   6.244545   9.960e-013
    'ks22upo141a.mat';% 140.645074  -0.000001   2.509e-010
    'ks22uqo142b.mat';% 141.609373  -4.853878   9.659e-013

    'ks22upo142a.mat';% 141.829095  -0.000000   3.562e-011
    'ks22uqo142a.mat';% 142.178064  -3.341685   1.220e-009
    'ks22uqo143a.mat';% 143.382773   3.754234   1.894e-013
    'ks22upo144a.mat';% 143.816002  -0.000001   5.615e-012
    'ks22uqo144b.mat';% 143.869603  -4.447408   1.558e-013
    
    'ks22uqo144e.mat';% 143.911251  -2.812715   2.726e-012
    'ks22uqo144c.mat';% 144.038979  -5.515201   3.655e-012
    'ks22uqo144d.mat';% 144.196079 -10.587710   2.027e-011
    'ks22uqo144a.mat';% 144.306458  -4.708727   2.288e-013
    'ks22uqo145c.mat';% 144.775103   9.423231   1.523e-009
    'ks22uqo145b.mat';% 144.889795  -8.803784   1.146e-013

    'ks22uqo145a.mat';% 144.941435 -10.925782   5.470e-013
    'ks22uqo145d.mat';% 145.426885  -8.868935   2.773e-013
    'ks22uqo146d.mat';% 145.542728   5.470052   2.223e-011
    'ks22uqo146a.mat';% 145.647372 -10.635471   6.209e-012

    'ks22upo146a.mat';% 145.978857  -0.000000   1.067e-012
    'ks22uqo146c.mat';% 146.227355  -4.845983   1.421e-011
    'ks22uqo146b.mat';% 146.340000  -5.893415   3.383e-013
    'ks22uqo147b.mat';% 147.098449  -3.522798   7.412e-013
    'ks22uqo147a.mat';% 147.429564   2.864155   6.686e-011
    'ks22uqo148f.mat';% 147.824483  -0.536107   5.446e-012

    'ks22uqo148a.mat';% 147.874385  -4.327200   1.776e-009
    'ks22uqo148b.mat';% 147.966154   3.827530   9.711e-011
    'ks22uqo148e.mat';% 147.980731  -8.672384   6.610e-013
    'ks22uqo148c.mat';% 148.200710   3.710038   8.997e-013
    'ks22uqo148g.mat';% 148.387831  -4.925476   7.018e-013
    'ks22uqo148d.mat';% 148.490595  -3.522411   4.533e-013

    'ks22upo149b.mat';% 148.712462  -0.000002   5.145e-012
    
    'ks22uqo149c.mat';% 148.824296   6.526638   4.276e-012
    'ks22uqo149a.mat';% 149.084398   8.408786   3.700e-012
    'ks22uqo149b.mat';% 149.253282  -4.280117   2.058e-012
    'ks22upo149a.mat';% 149.339604   0.000000   5.598e-011
    'ks22uqo150a.mat';% 150.141052   5.674093   8.729e-012
    'ks22uqo150b.mat';% 150.378762   9.089127   2.132e-012
    
    'ks22upo151b.mat';% 151.082445  -0.000009   8.645e-011
    'ks22upo151a.mat';% 151.399671  -0.000000   1.803e-011
    'ks22uqo151a.mat';% 151.446067   5.480539   2.275e-012
    'ks22uqo151b.mat';% 151.499898  -0.000000   1.464e-011
    'ks22uqo152a.mat';% 152.257156   0.419885   2.179e-012
    'ks22uqo152b.mat';% 152.492994   5.464937   3.778e-012

    'ks22uqo153a.mat';% 153.212997 -10.132600   1.926e-012
    'ks22uqo154c.mat';% 153.739702 -10.140171   1.270e-010
    'ks22uqo154a.mat';% 154.062637   8.408730   5.507e-012
    'ks22uqo155a.mat';% 154.692972   5.734826   3.681e-013
    'ks22uqo155c.mat';% 155.352587   6.191177   1.639e-012
    
    'ks22uqo155b.mat';% 155.431130   2.880216   3.284e-012
    'ks22uqo156b.mat';% 156.091924  -6.543825   9.195e-013
    'ks22uqo156a.mat';% 156.257970   2.925257   5.687e-012
    'ks22uqo157a.mat';% 157.042870   2.961886   8.743e-012
    'ks22uqo157b.mat';% 157.213530   7.468081   2.540e-011
    'ks22uqo158b.mat';% 157.777111  -2.981041   9.771e-013

    'ks22uqo158c.mat';% 157.780508  -5.531998   5.687e-012
    'ks22upo158a.mat';% 157.829972  -0.000007   4.091e-012
    'ks22uqo158a.mat';% 158.062421   0.596793   2.928e-010
    'ks22uqo159a.mat';% 158.732736  -5.175850   6.590e-012
    'ks22uqo160b.mat';% 159.893616 -10.686723   3.445e-012
    'ks22upo160b.mat';% 160.182579   0.000009   3.870e-013

    'ks22upo160a.mat';% 160.328760  -0.000005   3.003e-013
    'ks22uqo160a.mat';% 160.476820  -7.444423   1.149e-011
    'ks22uqo161b.mat';% 160.866876   4.745280   9.992e-014
    'ks22uqo161a.mat';% 161.135051  -4.871592   4.751e-014    
    'ks22uqo162a.mat';% 162.448652  -1.058212   4.360e-012
    'ks22uqo163b.mat';% 163.229756  -3.229459   1.343e-012
    
    'ks22upo163a.mat';% 163.271839   0.000000   1.707e-011
    'ks22uqo163a.mat';% 163.423996  -5.979334   2.080e-011
    'ks22uqo163d.mat';% 163.476283  -1.285034   5.865e-013
    'ks22uqo164a.mat';% 164.117594 -10.872756   5.843e-012
    'ks22uqo164b.mat';% 164.371170   9.989830   3.924e-012
    'ks22uqo165b.mat';% 164.639828  -4.779875   2.096e-012
    
    'ks22uqo165a.mat';% 165.179172   5.976510   6.969e-011
    'ks22upo165a.mat';% 165.347530  -0.000001   7.510e-013
    'ks22upo166a.mat';% 166.363483   0.000006   6.920e-013
    'ks22uqo167a.mat';% 166.689318 -10.090257   2.105e-012
    'ks22uqo168a.mat';% 167.549441  -0.746615   4.408e-012
    'ks22uqo168b.mat';% 168.223221   1.563786   5.332e-011
    
    'ks22upo169b.mat';% 168.824011  -0.000031   1.839e-010
    'ks22uqo169a.mat';% 169.354014  -8.351304   3.340e-011
    'ks22upo169c.mat';% 169.419180  -0.000018   2.951e-011
    'ks22uqo170b.mat';% 169.518906   5.916267   1.308e-010
    'ks22uqo170e.mat';% 169.760672   8.930859   6.357e-012
    'ks22uqo170c.mat';% 170.008790   0.510044   7.809e-012

    'ks22uqo170a.mat';% 170.177047  -8.338197   5.753e-011
    'ks22upo171b.mat';% 170.697395  -0.000003   6.192e-011
    'ks22upo171a.mat';% 170.755590   0.000013   1.328e-005
    'ks22uqo171b.mat';% 170.824336  -4.515187   5.133e-012
    'ks22uqo171a.mat';% 170.936876   6.562272   1.063e-009
    'ks22uqo171c.mat';% 171.024818   1.443162   4.599e-013
    
    'ks22upo171c.mat';% 171.120612  -0.000064   2.471e-012
    'ks22uqo172a.mat';% 172.205618  -9.322603   5.442e-012

    'ks22uqo173a.mat';% 172.771060   1.875806   3.539e-012
    'ks22uqo174a.mat';% 173.888171  -6.655034   2.042e-009
    'ks22uqo175b.mat';% 175.108774   9.455093   5.347e-012
    'ks22uqo175c.mat';% 175.158062  -4.786639   7.514e-012
    'ks22uqo175a.mat';% 175.381385   5.432786   5.464e-013
    'ks22uqo176b.mat';% 176.029380   5.976978   3.213e-013
    
    'ks22uqo176c.mat';% 176.394267   3.896031   1.470e-011
    'ks22uqo176a.mat';% 176.410711   1.860644   1.747e-010
    'ks22uqo176d.mat';% 176.455893   6.151105   1.828e-011 <- not converged
    'ks22uqo177a.mat';% 177.020006  -6.857858   2.416e-013
    'ks22upo177a.mat';% 177.290723   0.000009   1.884e-011
    'ks22uqo178a.mat';% 177.771829  -8.659162   7.135e-012
    
    'ks22uqo178c.mat';% 177.924469  -0.567232   1.686e-014
    'ks22uqo178b.mat';% 178.077672  10.224434   1.428e-012
    'ks22uqo178d.mat';% 178.180921   6.779544   5.436e-012
    'ks22uqo179a.mat';% 178.836578  -8.673101   2.748e-008
    'ks22uqo179d.mat';% 179.214840  -9.703141   4.367e-012
    'ks22uqo179c.mat';% 179.219124   5.277785   1.498e-012

    'ks22uqo179b.mat';% 179.450200  -7.626701   1.672e-013
    'ks22upo180b.mat';% 180.172143   0.000000   1.003e-012
    
    'ks22upo180a.mat';% 180.425745  -0.000002   3.508e-011
    'ks22uqo181b.mat';% 180.534548  -9.921382   1.375e-009
    'ks22uqo181c.mat';% 180.863421   2.373611   4.368e-013
    'ks22uqo181a.mat';% 181.401640  -5.800474   2.933e-012
    'ks22uqo182a.mat';% 182.256501   2.952701   2.434e-011
    'ks22uqo183b.mat';% 182.511632   0.021412   6.808e-013

    'ks22uqo183a.mat';% 182.590494   3.145397   2.067e-011
    'ks22uqo183d.mat';% 182.689438   6.793373   1.945e-013
    'ks22uqo183e.mat';% 182.885708  -9.342984   3.691e-010
    'ks22uqo183c.mat';% 183.053153  -1.777032   6.843e-011
    'ks22uqo184a.mat';% 184.444306   9.457250   5.639e-012
    'ks22uqo185a.mat';% 184.608089  -9.979336   1.247e-011

    'ks22uqo185b.mat';% 184.988709  -8.832022   5.940e-012
    'ks22upo185a.mat';% 185.247492   0.000001   3.116e-008

    'ks22upo186a.mat';% 185.620522   0.000000   3.331e-012
    'ks22uqo186a.mat';% 185.716244   6.906840   2.598e-012
    'ks22upo188a.mat';% 187.538826   0.000001   5.671e-007
    'ks22uqo188b.mat';% 188.278826   3.904530   8.874e-011
    'ks22uqo188a.mat';% 188.498020   4.526301   6.670e-013
    'ks22upo189b.mat';% 188.510723  -0.000000   5.860e-010
    
    'ks22upo189a.mat';% 189.275487   0.000002   2.087e-012
    'ks22uqo191a.mat';% 191.109584  10.444313   8.281e-012
    'ks22upo192a.mat';% 191.457080  -0.000000   1.166e-009
    'ks22uqo193c.mat';% 192.920906  -4.767956   1.446e-012
    'ks22uqo193a.mat';% 193.124990   1.715112   7.954e-013 <- not converged
    'ks22uqo193b.mat';% 193.149928  -4.833093   1.918e-009

    'ks22upo194a.mat';% 194.274476   0.000003   1.634e-010
    'ks22uqo194a.mat';% 194.480030  10.421027   6.531e-012    
    'ks22upo195a.mat';% 194.837222  -0.000000   6.946e-007
    'ks22upo195b.mat';% 195.084546  -0.000007   1.258e-009
    'ks22uqo195a.mat';% 195.134870  -1.301546   4.018e-012
    'ks22upo195c.mat';% 195.174147   0.000006   1.674e-011
    
    'ks22uqo196a.mat';% 195.830366   6.488804   4.627e-011
    'ks22uqo197b.mat';% 196.713247   6.254122   4.046e-012

    'ks22uqo197a.mat';% 197.027147  10.443248   6.616e-011
    'ks22upo197a.mat';% 197.340179  -0.000007   4.891e-006
    'ks22uqo198a.mat';% 197.746219  -6.505396   9.282e-012
    'ks22uqo198b.mat';% 198.396838   1.957356   3.476e-010
    'ks22upo199a.mat';% 198.556240  -0.000001   2.121e-012
    'ks22uqo200a.mat';% 199.713609  -2.659040   2.702e-010

    'ks22upo200a.mat';% 200.411897  -0.000008   8.800e-006
    'ks22uqo201a.mat';% 200.957832   0.029580   8.176e-013
    'ks22uqo202a.mat';% 201.653143   1.902984   2.352e-011
    'ks22uqo204a.mat';% 203.701352  10.264942   2.979e-012
    'ks22uqo204b.mat';% 203.712379   7.716432   5.036e-011
    'ks22upo204a.mat';% 203.726644   0.000001   1.015e-011
    'ks22upo204b.mat';% 203.888367  -0.000002   3.664e-012
    'ks22upo205b.mat';% 204.890803  -0.000002   5.930e-012
    'ks22upo205a.mat';% 204.905561  -0.000002   8.648e-011
    'ks22upo207a.mat';% 206.541701   0.0 00001   1.642e-010
    'ks22upo207b.mat';% 206.932867   0.000010   4.195e-011
    'ks22uqo207a.mat';% 207.303703   4.836730   6.309e-011
    'ks22upo209a.mat';% 208.747017   0.000000   2.696e-011
    'ks22uqo214a.mat';% 213.791285   3.497022   4.641e-009
    'ks22upo220a.mat';% 219.630506   0.000000   8.812e-011
    'ks22upo227a.mat';% 226.834143   0.000004   6.452e-005
   ];  save ks22names name;  nax = 6;
  case 50,
    clear;  name = [
    'ks50rpo009b.mat';%   8.502416  10.601422   9.517e-013
    'ks50rpo009c.mat';%   8.750152 -10.669003   2.307e-013
    'ks50rpo009a.mat';%   8.998497  19.623471   1.700e-015
    'ks50rpo011a.mat';%  11.092722  24.024793   3.651e-015
    'ks50rpo013b.mat';%  12.660796  17.543293   2.959e-013
    'ks50rpo013a.mat';%  13.218836  -4.807292   4.609e-014
    'ks50rpo014a.mat';%  13.732597  -3.268565   6.823e-014
    'ks50rpo016b.mat';%  15.557797  20.957970   6.501e-015
    'ks50rpo016a.mat';%  15.669563   9.486030   2.502e-014
    'ks50rpo018a.mat';%  18.182769 -19.657325   1.512e-014
    'ks50rpo020a.mat';%  20.065607 -20.198905   1.677e-014
    'ks50rpo020b.mat';%  20.255101 -20.609250   2.056e-015
    'ks50rpo021a.mat';%  20.819836  -1.735221   2.666e-014
    'ks50rpo024b.mat';%  23.705723  -6.662196   1.388e-014
    'ks50rpo024a.mat';%  24.104919 -10.811604   6.901e-015
    'ks50rpo026b.mat';%  26.236886 -13.718069   1.676e-014
    'ks50rpo026a.mat';%  26.464834 -19.193295   1.335e-014
    'ks50rpo027a.mat';%  27.388358  10.786236   1.206e-009
    'ks50rpo034b.mat';%  33.594548  -3.156112   1.016e-012
    'ks50rpo034c.mat';%  33.953261  -2.957128   4.903e-014
    'ks50rpo034a.mat';%  34.449770   6.355855   4.935e-014
    'ks50rpo039a.mat';%  39.076672   6.512421   1.800e-013
    'ks50rpo041a.mat';%  41.067064   0.323054   5.223e-014
    'ks50rpo047a.mat';%  47.059378 -18.613127   5.588e-014
    'ks50rpo051a.mat';%  51.464493 -15.635015   7.588e-013
    'ks50rpo070a.mat';%  70.288203 -12.358193   6.576e-012
    'ks50upo073a.mat';%  73.056550  -0.000015   1.746e-011
    'ks50rpo076a.mat';%  76.081092  23.559236   9.578e-012
    'ks50rpo087a.mat';%  86.537804   8.738266   2.963e-011
    ];  save ks50names name;  nax = 3;
  end
  nst = size(name,1);  np = 2;  te = 200;%  nst = 24;
%  for ist = 1:nst,  ost = 1:nst;
%  nax = 5;  for ist = 1:nax, ost = 2:6, % ost = [3 22 50 57 95];
  for ist = 1:nax,  ost = [73:78];
    switch 1,
    case 1,
      ifig = floor(ist/nax)+1;  iorb = mod(ist-1,nax)+1;
      if iorb == 1,  figure(ifig); clf; orient landscape; 
%        set(gcf,'pos',[35 200 1100 740]);
        set(gcf,'pos',[35 200 1000 640]);
        hax = subplots(1,nax,[0.03 0.03 0.07 0.1],[0.015 0 0 0]); end
      load(name(ost(ist),:));  N = length(a0)+2;  x = d.*(-N:N)'./(2*N);
      ne = ceil(te./tend);
      [tti, aai] = ksfmedt(d, tend, a0, h, np);
      ek = exp((2i*pi/d).*ph.*(1:N/2-1)');
      tt = tti(1:end-1);  aa = aai(:,1:end-1);
      for ie = 1:ne-1,
        vi = (aai(1:2:end,:)+1i*aai(2:2:end,:)).*repmat(ek,1,size(aai,2));
        aai(1:2:end,:) = real(vi);  aai(2:2:end,:) = imag(vi);
        aa = [aa aai(:,1:end-1)];  tt = [tt tti(1:end-1)+ie*tend]; end
      v = aa(1:2:end,:) + 1i*aa(2:2:end,:);
      v = [zeros(1,size(aa,2)); v; zeros(N+1,size(aa,2)); flipud(conj(v))];
      u = real(fft(v));  u = [u; u(1,:)];
      axes(hax(iorb)); pcolor(x,tt,u'); shading flat; caxis([-3 3]);  hold on;
      plot(x([1 end])*ones(1,ne),[tend;tend]*(1:ne),'w-');
      plot(mod([ph;ph]*(1:ne-1),d)-d/2,[(1:ne-1);(2:ne)]*tend,'w-');
      title([sprintf('%3d: T=%6.2f ',ost(ist),tend) '\Delta=' sprintf('%7.3f',ph)]);
  %    title(sprintf('d/T = %8.4f',ph./tend));
      set(gca,'ticklength',0.7*get(gca,'ticklength'),'tickdir','out',...
        'ylim',[0 te],'ytick',20:20:te,'box','off');  xlabel('x');
      if iorb > 1, set(gca,'yticklabel',[]); end
      if iorb == nax,
        hax(nax+1) = axes('pos',[.06 .9 .9 .07]);
        tit1 = 'Kuramoto-Sivashinsky: u_t = -uu_x - u_{xx} - u_{xxxx};  ';
        tit2 = ['x \in [-L/2, L/2];    BC: u(x+L,t) = u(x,t);' sprintf('   L = %4.1f;    ',d)];
        tit3 = 'Solutions of the form: u(x+\Delta,T) = u(x,0)';
        text(0.1,.9,[tit1 tit2 tit3]);  set(hax(nax+1),'visi','off');
        axes(hax(1)); ylabel('t','rotat',0); end
    case 2,  % Plot FMs of RPOs
      load(name(ost(ist),:));  N = length(a0)+2;  x = d.*(-N:N)'./(2*N);
      [tt, aa] = ksfmedt(d, tend, a0, h, 1);  
      v = aa(1:2:end,:) + 1i*aa(2:2:end,:);
      ek = exp((-2i*pi/d).*ph./tend*(1:N/2-1)'*tt);  vr = ek.*v;
      vv = [zeros(1,size(aa,2)); v; zeros(N+1,size(aa,2)); flipud(conj(v))];
      u = real(fft(vv));  u = [u; u(1,:)];
      fig1 = figure('PaperPosition',[0.6345 6.345 20.3 15.23],...
        'PaperSize',[20.98 29.68],'Position',[5 200 900 740]);
      ax(1) = axes('Position',[0.04 0.08 0.13 0.86],'Parent',fig1);
      ax(2) = axes('Position',[0.24 0.54 0.33 0.39],'Parent',fig1);
      ax(3) = axes('Position',[0.64 0.54 0.33 0.39],'Parent',fig1);
      ax(4) = axes('Position',[0.24 0.08 0.33 0.39],'Parent',fig1);
      ax(5) = axes('Position',[0.64 0.08 0.33 0.39],'Parent',fig1);
      axes(ax(1));
      pcolor(x,tt,u'); shading flat; hold on;
      title(sprintf('T = %6.2f  d = %9.6f',tend,ph));  
      xlabel('x'); ylabel('Time');
      for iax = 1:4,
        axes(ax(iax+1));
        plot(real(vr(iax,:)),imag(vr(iax,:)),'.-');  hold on;
        plot(real(vr(iax,1)),imag(vr(iax,1)),'k.','markersize',15);  hold on;      
        plot(real(vr(iax,3)),imag(vr(iax,3)),'r.','markersize',15);  hold on;      
        plot(real(vr(iax,20:20:end)),imag(vr(iax,20:20:end)),'ro');  hold on;      
        grid on;  axis equal;
        xlabel(['Re a_' num2str(iax)]); ylabel(['Im a_' num2str(iax)]);
        axis([-1 1 -1 1]);
      end
    case 3,  %  RPO stability properties
      load(name(ost(ist),:));
      [g, jac] = ksfmf5new(0, [a0; tend; ph], d, h, eye(N-2), [1 1]);
      disp(['T = ' num2str(tend) '  d = ' num2str(ph) ' |g| = ' num2str(norm(g))]);
      df = jac(1:N-2,1:N-2)+eye(N-2);
      [vdf, edf] = eig(df);  edf = diag(edf);
      [sedf, ie] = sort(abs(edf),1,'descend');
      edf = edf(ie);  vdf = vdf(:,ie);
      disp(sprintf('(%15.10f,%9.5f)\n',[abs(edf(1:10)) angle(edf(1:10))]'));
    end
  end

%% Plot FMs of RPOs in co-rotating frame
  clear;  d = 22;  N = 32;  x = d.*(-N:N)'./(2*N);  h = 0.25;
  load ks22uqo060a;
  [tt, aa] = ksfmedt(d, tend, a0, h, 1);  v = aa(1:2:end,:) + 1i*aa(2:2:end,:);
  vv = [zeros(1,size(aa,2)); v; zeros(N+1,size(aa,2)); flipud(conj(v))];
  u = real(fft(vv)); u = [u; u(1,:)];
fig1 = figure('PaperPosition',[0.6345 6.345 20.3 15.23],...
    'PaperSize',[20.98 29.68],'Position',[5 400 1390 540]);
 ax1 = axes('Position',[0.04 0.09 0.13 0.85],'Parent',fig1);
  pcolor(x,tt,u'); shading flat;  caxis([-3 3]);  hold on; 
  title(sprintf('T = %6.2f  d = %9.6f',tend,ph));  
  xlabel('x'); ylabel('Time');

  ek = exp((-2i*pi/d).*ph./tend*(1:N/2-1)'*tt);  vr = ek.*v;
  e1 = exp(-2i*pi./tend*(1:N/2-1)'*tt);
  load ks22uss0a;  v2 = repmat(a0(1:2:end)+1i*a0(2:2:end),1,length(tt));
  load ks22uss3a;  v3 = repmat(a0(1:2:end)+1i*a0(2:2:end),1,length(tt));
  load ks22utw1a;  v4 = repmat(a0(1:2:end)+1i*a0(2:2:end),1,length(tt));
  v2r = e1.*v2;  v3r = e1.*v3;  v4r = e1.*v4;  v5r = -e1.*conj(v4);
 ax2 = axes('Position',[0.20 0.09 0.38 0.85],'Parent',fig1);
%  plot3(real(v(2,:)), imag(v(2,:)), real(v(3,:)), '.-');  hold on;
  plot3(real(vr(2,:)), imag(vr(2,:)), imag(vr(3,:)), '.-');
  grid on; hold on; 
  xlabel('Re u_2');  ylabel('Im u_2');  zlabel('Re u_3');
  plot3(real(v2r(2,:)), imag(v2r(2,:)), imag(v2r(3,:)), 'k.-');
  plot3(real(v3r(2,:)), imag(v3r(2,:)), real(v3r(3,:)), 'r.-'); 
%  plot3(real(v4r(2,:)), imag(v4r(2,:)), real(v4r(1,:)), 'g.-'); 
%  plot3(real(v5r(2,:)), imag(v5r(2,:)), real(v5r(1,:)), 'c.-'); 
  axis image;  view(-160,30);
 ax3 = axes('Position',[0.60 0.09 0.38 0.85],'Parent',fig1);
%  plot3(real(v(3,:)), imag(v(3,:)), real(v(2,:)), '.-');  hold on;
  plot3(real(vr(3,:)), imag(vr(3,:)), real(vr(2,:)), '.-');
  grid on; hold on;
  xlabel('Re u_3');  ylabel('Im u_3');  zlabel('Re u_2');
  plot3(real(v2r(3,:)), imag(v2r(3,:)), real(v2r(2,:)), 'k.-');
  plot3(real(v3r(3,:)), imag(v3r(3,:)), real(v3r(2,:)), 'r.-');
%  plot3(real(v4r(1,:)), imag(v4r(1,:)), real(v4r(2,:)), 'g.-');
%  plot3(real(v5r(1,:)), imag(v5r(1,:)), real(v5r(2,:)), 'c.-');
  axis image;  view(-160,30);
  

%% Bring RPOs to common reference point
%  Time point t_0 is determined by the maximum of the 1st mode magnitude
%  Phase point is determined by a_1(t_0) = 0
%  Together, the two conditions are a_1 = 0 and da_2/dt = 0
  clear;  % load ks22uqo158a;  na = length(a0);
  d = 22;  h = 0.25;  f90 = load('ks22dupo07s.rpo');  ipo = 1;
  tend = f90(ipo,3);  ph = f90(ipo,4);  a0 = f90(ipo,5:end)'; na = length(a0);
  nt = round(tend/h);  [tt, aa] = ksfmstp2(a0, d, h, nt, 1);
  r1 = sqrt(sum(aa(1:2,:).^2))';
  figure(3); clf; plot(tt',[aa(1:2,:)' r1],'.-');
  [mr,ir] = max(r1); hold on; plot(tt(ir),r1(ir),'ko'); disp([mr^2 ir]); pause;
  if 0, ek = exp(1i.*(1:na/2)'.*angle(aa(2,ir)+1i*aa(1,ir)));
    v0 = ek.*(a0(1:2:end)+1i*a0(2:2:end));
    a0(1:2:end) = real(v0);  a0(2:2:end) = imag(v0);
    [tt, aa] = ksfmetd2(a0, d, h, tend, 1);
    r1 = sqrt(sum(aa(1:2,:).^2))';
    figure(3); clf; plot(tt',[aa(1:2,:)' r1],'.-'); hold on; pause; end
  np = fix(tend/30.0-.5)+1;  mstp = floor(nt/np); % mstp = 1;
  ii = [ir:nt 1:ir-1]';  ii = ii(1:mstp:end-mstp+1);
  i1 = ii(find(ii >= ir));  i2 = ii(find(ii < ir));  v1 = [];  v2 = [];
  if ~isempty(i1),
    ek = exp(1i.*(1:na/2)'.*angle(aa(2,ir)+1i*aa(1,ir)));
    v1 = repmat(ek,1,length(i1)).*(aa(1:2:end,i1) + 1i*aa(2:2:end,i1)); end
  if ~isempty(i2),
    ek = exp(1i.*(1:na/2)'.*(angle(aa(2,ir)+1i*aa(1,ir))+2*pi*ph/d));    
    v2 = repmat(ek,1,length(i2)).*(aa(1:2:end,i2) + 1i*aa(2:2:end,i2)); end
  np = length(ii);  ai = zeros(na,np);
  ai(1:2:end,:) = real([v1 v2]);  ai(2:2:end,:) = imag([v1 v2]);
  ai = [ai(:); tend; ph];  global PFLG;  PFLG = 1;
  gi = ksfmms5(ai, d, h, mstp, np); disp(['|gms| = ' num2str(norm(gi))]);
  options = optimset('Display','on','outputfcn',@ksoutfun2,'DerivativeCheck','off','MaxIter',10000, ...
        'MaxFunEvals',50000,'Jacobian','on','NonlEqnAlgorithm','lm','TolX',1e-12,'TolFun',1e-12);
  upo = fsolve(@(ai)ksfmms5(ai,d,h,mstp,np),ai,options);

%% Bring POs (RPOs with reflection) to common reference point
%  Time point t_0 is determined by the maximum of the 1st mode magnitude
%  Phase is set to 0: u(x,T/2) = -u(-x,0)
  clear;  
  switch 2,
  case 1, load ks22upo220a;  tend = tend/2;  
  case 2, f90 = load('ks22dupo06r.rpo'); ipo = 2001;  d = 22; h = 0.25;
    tend = f90(ipo,3);  ph = f90(ipo,4);  a0 = f90(ipo,5:end)';
  end, 
  phase = .005:.005:1;  np = length(phase);  na = length(a0);
  gi = ksfmms3([a0;tend;ph] ,d,h);  disp(norm(gi)); pause;
  [tt, aa] = ksfmetd2(a0, d, h, tend, 1);  nt = length(tt);
  r1 = sqrt(sum(aa(1:2,:).^2))';
  figure(3); clf; plot(tt',[aa(1:2,:)' r1],'.-');
  [mr,ir] = max(r1); hold on; plot(tt(ir),r1(ir),'ko'); pause;
  ek = exp((2i*pi).*(1:na/2)'*phase);
  va = ek.*repmat(-aa(1:2:end,end)+1i*aa(2:2:end,end),1,np);
  p1 = sqrt(sum((real(va)-aa(1:2:end,ones(1,np))).^2+(imag(va)-aa(2:2:end,ones(1,np))).^2));
  [mp,ip] = min(p1);  shift = phase(ip)/2;
  figure(2);  plot(phase,p1,'.-',phase(ip),p1(ip),'ro');
if 0,  
  v0 = exp(-(2i*pi).*(1:na/2)'.*shift).*(aa(1:2:end,ir)+1i*aa(2:2:end,ir));
  a0(1:2:end) = real(v0);  a0(2:2:end) = imag(v0);
  [tt, aa] = ksfmetd2(a0, d, h, tend, 1);
  figure(4); clf;  
  plot(1:2:na,[a0(1:2:na) -aa(1:2:na,end)],'o',2:2:na,[a0(2:2:na) aa(2:2:na,end)],'o');
  [tt, aa] = ksfmetd2(a0, d, h, tend, 1);  nt = length(tt);
  if 1, r1 = sqrt(sum(aa(1:2,:).^2))';
  figure(3); hold on; plot(tt',[aa(1:2,:)' r1],'.-');
  [mr,ir] = max(r1); hold on; plot(tt(ir),r1(ir),'ko'); end
  np = fix(tend/20.0-.5)+1;  mstp = floor(nt/np);
  ai = aa(:,1:mstp:end-mstp+1);  ai = [ai(:); tend; 0];  pause;
else
  np = fix(tend/20.0-.5)+1;  mstp = floor(nt/np); % mstp = 1;
  ii = [ir:nt 1:ir-1]';  ii = ii(1:mstp:end-mstp);  np = length(ii);
  i1 = length(find(ii < ir));
  ek = exp(-(2i*pi).*(1:na/2)'.*shift);
  va = repmat(ek,1,np).*(aa(1:2:end,ii)+1i*aa(2:2:end,ii));
  ai = zeros(na,np);  ai(1:2:end,:) = real(va);  ai(2:2:end,:) = imag(va);
  ai(1:2:end,end-i1+1:end) = -ai(1:2:end,end-i1+1:end);
  ai = [ai(:); tend; 0];
end
  global PFLG;  PFLG = -1;
  gi = ksfmms5(ai, d, h, mstp, np); disp(['|gms| = ' num2str(norm(gi))]);
  figure(3); clf; plot(gi,'.');  pause;
  options = optimset('Display','on','outputfcn',@ksoutfun2,'DerivativeCheck','off','MaxIter',10000, ...
        'MaxFunEvals',50000,'Jacobian','on','NonlEqnAlgorithm','lm','TolX',1e-12,'TolFun',1e-12);
  upo = fsolve(@(ai)ksfmms5(ai,d,h,mstp,np),ai,options);

%% Load f90 results files
  clear;  ff = dir('ks22dupo41*.rpo');
  for ii = 1:length(ff); f90 = load(ff(ii).name);
    if size(f90,1) < 3000, 
      disp(sprintf('%s : %s : %4d',ff(ii).name,ff(ii).date,size(f90,1))); 
    end
  end
%% Process f90 results (save in ks22f90h25 for L=22, h=0.25)
  clear;  load ks22f90h25;
  f90name = 'ks22dupo42rc185-201'; f90 = load([f90name '.rpo']);
%  diary ks22f90h25.diary;  %diary off;
  diary([f90name(1:10) '.diary']);
%  diary ks22f90h25.diary;
  disp(sprintf('File: %s;  No. of orbits: %d',f90name,size(f90,1)));
  diary off;
  global PFLG;  L = 22;  h = 0.25;  maxitr = 3000; outfcn = @ksoutfun2; outfcn = [];
  for jpo = 1:size(f90,1),
    PFLG = f90(jpo,1);  if abs(PFLG) ~= 2, continue, else PFLG = PFLG/2; end
    tend = f90(jpo,3);  ph = f90(jpo,4);  
    if ph > L/2, ph = ph-L; elseif ph <= -L/2, ph = ph+L; end
    a0 = f90(jpo,5:end)';  na = length(a0);
    if PFLG == 1 & ph < 0, ph = -ph;  a0(1:2:end) = -a0(1:2:end); end
    fa = ksfm(0,a0,L);  nfa = norm(fa);
    gm = ksfmms3([a0; tend; ph], L, h);  ngm = norm(gm);
    str1 = sprintf('PO:%5d %3d %10.2e %12.8f %12.8f %10.2e',jpo,PFLG,ngm,tend,ph,nfa); disp(str1);
    if ngm < 3e-5 & nfa > 1e-6, % Good orbit
      if PFLG == 1,
        nt = round(tend/h);  [tt, aa] = ksfmstp2(a0, L, h, nt, 1);
        r1 = sqrt(sum(aa(1:2,:).^2))';  [mr,ir] = max(r1);
        ek = exp(1i.*(1:na/2)'.*angle(aa(2,ir)+1i*aa(1,ir)));
        np = fix(tend/16.0-.5)+1;  mstp = floor(nt/np); % mstp = 1;
        ii = mod(ir-1+(0:np-1)*mstp,nt)+1;
        i1 = ii(find(ii >= ir));  i2 = ii(find(ii < ir));  v1 = [];  v2 = [];
        if ~isempty(i1),  ek = exp(1i.*(1:na/2)'.*angle(aa(2,ir)+1i*aa(1,ir)));
          v1 = repmat(ek,1,length(i1)).*(aa(1:2:end,i1) + 1i*aa(2:2:end,i1)); end
        if ~isempty(i2),  ek = exp(1i.*(1:na/2)'.*(angle(aa(2,ir)+1i*aa(1,ir))+2*pi*ph/L));    
          v2 = repmat(ek,1,length(i2)).*(aa(1:2:end,i2) + 1i*aa(2:2:end,i2)); end
        np = length(ii);  ai = zeros(na,np);
        ai(1:2:end,:) = real([v1 v2]);  ai(2:2:end,:) = imag([v1 v2]);
        ai = [ai(:); tend; ph];  %np = 1;  ai = [ai(1:na); tend; ph];
        options = optimset('Display','off','MaxIter',maxitr,'Jacobian','on','outputfcn',outfcn,...
                  'NonlEqnAlgorithm','lm','TolX',1e-11,'TolFun',1e-11);
        [ao,go,eflag,output] = fsolve(@(ai)ksfmms5(ai,L,h,mstp,np),ai,options);  ngo = norm(go); 
        fa = ksfm(0,ao(1:na),L);  nfa = norm(fa);
        str2 = sprintf('  MS: %2d %3d %10.2e %12.8f %12.8f %10.2e',eflag, output.iterations, ngo, ao(end-1:end), nfa); disp(str2);
        if ngo < 3e-8 & nfa > 1e-7,
          np = 1;  mstp = 1;  ai = [ao(1:na); ao(end-1:end)];
          options = optimset('Display','off','MaxIter',50,'Jacobian','on',...'outputfcn',@ksoutfun2,...
                    'NonlEqnAlgorithm','lm','TolX',1e-11,'TolFun',1e-11);
          [ao,go,eflag,output] = fsolve(@(ai)ksfmms5(ai,L,h,mstp,np),ai,options);  ngo = norm(go); 
          fa = ksfm(0,ao(1:na),L);  nfa = norm(fa);
          str3 = sprintf('  SS: %2d %3d %10.2e %12.8f %12.8f %10.2e',eflag, output.iterations, ngo, ao(end-1:end), nfa);  disp(str3);
          if ngo < 2e-7 & nfa > 1e-7,
            a0 = ao(1:na);  tend = ao(end-1);  ph = ao(end);
            ipo = max(find([rpo.T] < tend+1e-6)); add = 1; repl = 0;
            str4 = sprintf('  Proximity: %10.2e %10.2e %10.2e',abs(rpo(ipo).T-tend), abs(rpo(ipo).s-ph), abs(rpo(ipo).a(2)-a0(2))); disp(str4);
            if isempty(ipo), ipo = 0; add = 1;
            elseif abs(rpo(ipo).T-tend) <= 1e-6,  % exists
              rpo(ipo).nhit = rpo(ipo).nhit+1;
              disp(sprintf('  Old orbit: %3d %3d',ipo,rpo(ipo).nhit));
              if ngo < rpo(ipo).r, add = 1; repl = 1;
              else add = 0; end, end
            if add == 1, if repl == 0, ipo = ipo+1;
                bgrfor iit = size(rpo,2):-1:ipo,  rpo(iit+1) = rpo(iit); end, end
              rpo(ipo).a = a0;  rpo(ipo).T = tend;  rpo(ipo).s = ph;  
              rpo(ipo).r = ngo;  if repl == 0, rpo(ipo).nhit = 1;  rpo(ipo).a1 = []; end
              [f,df] = ksfmms3([rpo(ipo).a;rpo(ipo).T;rpo(ipo).s],L,h); 
              edf = eig(df(1:na,1:na)+eye(na));
              [sedf, ie] = sort(abs(edf),1,'descend'); rpo(ipo).e = edf(ie);
              if repl == 0, 
                diary([f90name(1:10) '.diary']);  disp(str1); disp(str2); disp(str3); disp(str4);
                %diary ks22f90h25.diary; disp(str1); disp(str2); disp(str3); disp(str4);
                disp(sprintf('  Add orbit %d of %d',ipo,size(rpo,2)));  diary off;
              else disp(sprintf('  Replace orbit %d of %d',ipo,size(rpo,2))); end
            end, end, end
      elseif PFLG == -1,  
        shift = -ph/(2*L);  nt = round(tend/h);
        [tt, aa] = ksfmstp2(a0, L, h, nt, 1);
        r1 = sqrt(sum(aa(1:2,:).^2))';  [mr,ir] = max(r1);
        np = fix(tend/24.0-.5)+1;  mstp = floor(nt/np); % mstp = 1;
        if 0, v0 = exp(-(2i*pi).*(1:na/2)'.*shift).*(aa(1:2:end,ir)+1i*aa(2:2:end,ir));
          a0(1:2:end) = real(v0);  a0(2:2:end) = imag(v0);
          [tt, aa] = ksfmetd2(a0, L, h, tend, 1);  nt = length(tt);
          ai = aa(:,1:mstp:end-mstp+1);  ai = [ai(:); tend; 0];
        else
          ii = mod(ir-1+(0:np-1)*mstp,nt)+1;
          i1 = length(find(ii < ir));  ek = exp(-(2i*pi).*(1:na/2)'.*shift);
          va = repmat(ek,1,np).*(aa(1:2:end,ii)+1i*aa(2:2:end,ii));
          ai = zeros(na,np);  ai(1:2:end,:) = real(va);  ai(2:2:end,:) = imag(va);
          ai(1:2:end,end-i1+1:end) = -ai(1:2:end,end-i1+1:end);
          ai = [ai(:); tend; 0];  end
        options = optimset('Display','off','MaxIter',maxitr,'Jacobian','on','outputfcn',outfcn,...
                  'NonlEqnAlgorithm','lm','TolX',1e-11,'TolFun',1e-11);
        [ao,go,eflag,output] = fsolve(@(ai)ksfmms5(ai,L,h,mstp,np),ai,options);  ngo = norm(go); 
        fa = ksfm(0,ao(1:na),L);  nfa = norm(fa);
        str2 = sprintf('  MS: %2d %3d %10.2e %12.8f %12.8f %10.2e',eflag, output.iterations, ngo, ao(end-1:end), nfa); disp(str2);
        if ngo < 3e-8 & nfa > 1e-7,
          np = 1;  mstp = 1;  ai = [ao(1:na); ao(end-1); 0];
          options = optimset('Display','off','MaxIter',50,'Jacobian','on',... 'outputfcn',@ksoutfun2,...
                    'NonlEqnAlgorithm','lm','TolX',1e-11,'TolFun',1e-11);
          [ao,go,eflag,output] = fsolve(@(ai)ksfmms5(ai,L,h,mstp,np),ai,options);  ngo = norm(go); 
          fa = ksfm(0,ao(1:na),L);  nfa = norm(fa);
          str3 = sprintf('  SS: %2d %3d %10.2e %12.8f %12.8f %10.2e',eflag, output.iterations, ngo, ao(end-1:end), nfa); disp(str3);
          if ngo < 2e-7 & nfa > 1e-7,
            a0 = ao(1:na);  tend = ao(end-1);
            if exist('ppo'),
              ipo = max(find([ppo.T] < tend+1e-6)); add = 1; repl = 0;
%              [mpo,ipo] = min(abs(tend-[ppo.T])); add = 1; repl = 0;
              str4 = sprintf('  Proximity: %10.2e %10.2e',abs(ppo(ipo).T-tend), norm(abs(ppo(ipo).a(1:2))-abs(a0(1:2)))); disp(str4);
%              disp(sprintf('  Proximity: %10.2e %10.2e',mpo, norm(abs(ppo(ipo).a(1:2))-abs(a0(1:2)))));
              if isempty(ipo), ipo = 0; add = 1;
              elseif abs(ppo(ipo).T-tend) <= 1e-6,  % exists
                ppo(ipo).nhit = ppo(ipo).nhit+1;
                disp(sprintf('  Old orbit: %3d %3d',ipo,ppo(ipo).nhit));
                if ngo < ppo(ipo).r, add = 1; repl = 1;
                else add = 0; end, end
            else ipo = 1; add = 1; repl = 1; ppo = []; end
            if add == 1, if repl == 0, ipo = ipo+1;
                for iit = size(ppo,2):-1:ipo,  ppo(iit+1) = ppo(iit); end, end
              ppo(ipo).a = a0;  ppo(ipo).T = tend;
              ppo(ipo).r = ngo;  if repl == 0, ppo(ipo).nhit = 1; ppo(ipo).a1 = []; end
              [f,df] = ksfmms3([ppo(ipo).a;ppo(ipo).T;0],L,h); 
              edf = eig(df(1:na,1:na)+eye(na));
              [sedf, ie] = sort(abs(edf),1,'descend'); ppo(ipo).e = edf(ie);
              if repl == 0, 
                diary([f90name(1:10) '.diary']); disp(str1); disp(str2); disp(str3); disp(str4);
                %diary ks22f90h25.diary; disp(str1); disp(str2); disp(str3); disp(str4);
                disp(sprintf('  Add orbit %d of %d',ipo,size(ppo,2))); diary off;
              else disp(sprintf('  Replace orbit %d of %d',ipo,size(ppo,2))); end
            end, end, end
      end, end
  if PFLG == 1, save ks22f90h25 rpo -append
  elseif PFLG == -1, save ks22f90h25 ppo -append, end

%% Eliminate repetitions in ks22f90h25
  clear; load ks22f90h25; ipo = length(rpo);  ir = [];
  for ii = 1:ipo,  te = rpo(ii).T;  sh = rpo(ii).s;
    ip = [max(ii-9,1):ii-1 ii+1:min(ii+9,ipo)];
    im = find(abs([rpo(ip).T]-te) < 1e-3); lm = length(im);
    if lm > 0, for imm = 1:lm,
        dt = rpo(ip(im(imm))).T - rpo(ii).T;  ds = rpo(ip(im(imm))).s - rpo(ii).s;
        de = (abs(rpo(ip(im(imm))).e(1))-abs(rpo(ii).e(1)))./abs(rpo(ii).e(1));
        if max(abs([dt ds de])) < 1e-3, ir = [ir ii];
          disp(num2str([ii ip(im(imm)) dt ds de])); pause; end, end
    end, end
  ipo = length(ppo); ir = [];
  for ii = 1:ipo,  te = ppo(ii).T;
    ip = [max(ii-9,1):ii-1 ii+1:min(ii+9,ipo)];
    im = find(abs([ppo(ip).T]-te) < 1e-3); lm = length(im);
    if lm > 0, for imm = 1:lm,
        dt = ppo(ip(im(imm))).T - ppo(ii).T;
        de = (abs(ppo(ip(im(imm))).e(1))-abs(ppo(ii).e(1)))./abs(ppo(ii).e(1));
        if max(abs([dt de])) < 1e-3, ir = [ir ii];
          disp(num2str([ii ip(im(imm)) dt de])); pause; end, end
    end, end

%% Eliminate repetitions in rpo in ks22f90h25
  clear; load('ks22f90h25','rpo'); ipo = length(rpo);  ir = []; irm = [];
  for ii = 1:ipo-1,  te = rpo(ii).T;  sh = rpo(ii).s;
    if ~isempty(ir) && ii == ir(2), continue, end
    ip =  ii+1:min(ii+9,ipo);
    im = find(abs([rpo(ip).T]-te) < 1e-3); lm = length(im);
    if lm > 0, for imm = 1:lm,
        dt = rpo(ip(im(imm))).T - rpo(ii).T;  ds = rpo(ip(im(imm))).s - rpo(ii).s;
        de = (abs(rpo(ip(im(imm))).e(1))-abs(rpo(ii).e(1)))./abs(rpo(ii).e(1));
        if max(abs([dt ds de])) < 1e-3, ir = [ii ip(im(imm))];
          disp(sprintf('%5d %5d %12.7f %12.3e %11.3e %11.3e',ii,ip(im(imm)),rpo(ii).T,dt,ds,de));
          if rpo(ir(2)).nhit > rpo(ir(1)).nhit, irm = [irm ir(1)]; 
            rpo(ir(2)).nhit = rpo(ir(2)).nhit + rpo(ir(1)).nhit;
          else irm = [irm ir(2)];
            rpo(ir(1)).nhit = rpo(ir(1)).nhit + rpo(ir(2)).nhit; end
          pause; end, end
    end, end
  %rpo(irm) = []; save ks22f90h25 rpo -append
  
%%  Eliminate repetitions in ppo in ks22f90h25
  clear; load('ks22f90h25','ppo'); ipo = length(ppo);  ir = []; irm = [];
  for ii = 1:ipo,  te = ppo(ii).T;
    if ~isempty(ir) && ii == ir(2), continue, end
    ip = ii+1:min(ii+9,ipo);
    im = find(abs([ppo(ip).T]-te) < 1e-3); lm = length(im);
    if lm > 0, for imm = 1:lm,
        dt = ppo(ip(im(imm))).T - ppo(ii).T;
        de = (abs(ppo(ip(im(imm))).e(1))-abs(ppo(ii).e(1)))./abs(ppo(ii).e(1));
        if max(abs([dt de])) < 1e-3, ir = [ii ip(im(imm))];
          disp(sprintf('%5d %5d %12.7f %12.3e %11.3e',ii,ip(im(imm)),ppo(ii).T,dt,de));
          if ppo(ir(2)).nhit > ppo(ir(1)).nhit, irm = [irm ir(1)]; 
            ppo(ir(2)).nhit = ppo(ir(2)).nhit + ppo(ir(1)).nhit;
          else irm = [irm ir(2)];
            ppo(ir(1)).nhit = ppo(ir(1)).nhit + ppo(ir(2)).nhit; end
          pause; end, end
    end, end
  %ppo(irm) = []; save ks22f90h25 ppo -append

%% Eliminate non-prime POs from ks22f90h25
  clear;  load ks22f90h25;  ipo = length(rpo);  mrpo = [];
  for ii = 1:ipo,  te = rpo(ii).T;  sh = rpo(ii).s;
    if abs(sh) < 1e-3,
      for ip = 2:2:10, if te/ip > 10,
      [mp,mi] = min(abs(te/ip - [ppo(1:300).T]));
      if mp < 1e-4,
        diary('ks22f90h25rep.diary');
        disp(sprintf('RPO %5d: %9.5f %10.2e | %2d %10.2e | PPO %3d: %9.5f',...
                     ii,te,sh, ip,mp, mi,ppo(mi).T)); diary off;
        mrpo = [mrpo; ii]; end, end, end
    else
      for ip = 2:20,  if te/ip > 10,
        [mp,mi] = min(abs([rpo.T]-te/ip));
        if mp < 1e-4,  ad = norm(abs(rpo(ii).a) - abs(rpo(mi).a));
          if ad < 1e-3,
            diary('ks22f90h25rep.diary');
            disp(sprintf('RPO %5d: %9.5f %9.5f  | %2d %10.2e %10.2e | RPO %3d: %9.5f %9.5f',...
                         ii,te,sh,ip,mp,ad,mi,rpo(mi).T,rpo(mi).s)); diary off;
            mrpo = [mrpo; ii]; end, end
      end, end, end, end
  ipo = length(ppo); mppo = [];
  for ii = 1:ipo, te = ppo(ii).T;
    for ip = 3:2:21,  if te/ip > 10,
      [mp,mi] = min(abs([ppo.T]-te/ip));
      if mp < 1e-4, ad = norm(abs(ppo(ii).a) - abs(ppo(mi).a));
        if ad < 1e-3,
          diary('ks22f90h25rep.diary');
          disp(sprintf('PPO %5d: %9.5f | %2d %10.2e %10.2e | PPO %3d: %9.5f',...
                       ii,te,ip,mp,ad,mi,ppo(mi).T)); diary off;
          mppo = [mppo; ii]; end, end
      end, end, end
  mrpo = unique(mrpo);  mppo = unique(mppo);
  save ks22f90h25 mppo mrpo -append
  
%% Convert ks22f90h25 from N = 32, h = 0.25 to N = 64, h = 0.1 (saved in rpo.*1 and ppo.*1)
  clear; load ks22f90h25;
  global PFLG;  PFLG = -1;  maxitr = 2000;  outfcn = @ksoutfun2; outfcn = [];
  diary ks22f90h10.diary;  %diary off;
  for ipo = 1:500,  dflg = 'off';
    if PFLG == 1, if ~isempty(rpo(ipo).a1) & rpo(ipo).r1 < 1e-5, continue; end
      a0 = rpo(ipo).a;  tend = rpo(ipo).T;  ph = rpo(ipo).s;
    else  if ~isempty(ppo(ipo).a1) & ppo(ipo).r1 < 1e-5, continue; end
      a0 = ppo(ipo).a;  tend = ppo(ipo).T;  ph = 0;  end
    [tt, aa] = ksfmetd2(a0, L, 0.25, tend, 2);
    np = fix(tend/12.0-.5)+1;  mstp = floor(length(tt)/np);
    ii = 1:mstp:length(tt)-mstp+1;  mstp = mstp*5;  na = 62;
    ai = [aa(:,ii); zeros(32,length(ii))];  ai = [ai(:); tend; ph];
    gm = ksfmms5(ai, L, 0.1, mstp, np);  ngm = norm(gm);
    disp(sprintf('PO: %5d %3d %10.2e %12.8f %12.8f  %04d-%02d-%02d %02d:%02d:%02d',ipo,PFLG,ngm,tend,ph,fix(clock)));
    options = optimset('Display',dflg,'MaxIter',maxitr,'Jacobian','on','outputfcn',outfcn,...
              'NonlEqnAlgorithm','lm','TolX',1e-11,'TolFun',1e-11);
    [ao,go,eflag,output] = fsolve(@(ai)ksfmms5(ai,L,0.1,mstp,np),ai,options);  ngo = norm(go); 
    disp(sprintf('  MS: %2d %4d %10.2e %12.8f %12.8f',eflag, output.iterations, ngo, ao(end-1:end)));
    np = 1;  mstp = 1;  ai = [ao(1:na); ao(end-1:end)];
    options = optimset('Display',dflg,'MaxIter',100,'Jacobian','on',... 'outputfcn',@ksoutfun2,...
              'NonlEqnAlgorithm','lm','TolX',1e-10,'TolFun',1e-10);
    [ao,go,eflag,output] = fsolve(@(ai)ksfmms5(ai,L,0.1,mstp,np),ai,options);  ngo = norm(go); 
    disp(sprintf('  SS: %2d %4d %10.2e %12.8f %12.8f',eflag, output.iterations, ngo, ao(end-1:end)));
    if ngo > 1e-5, disp('    DID NOT CONVERGE'); end 
    if PFLG == 1, rpo(ipo).a1 = ao(1:na);  rpo(ipo).T1 = ao(end-1);  rpo(ipo).s1 = ao(end);
      [f,df] = ksfmms3([rpo(ipo).a1; rpo(ipo).T1; rpo(ipo).s1],L,0.1);
      rpo(ipo).r1 = norm(f);  edf = eig(df(1:na,1:na)+eye(na));
      [sedf, ie] = sort(abs(edf),1,'descend'); rpo(ipo).e1 = edf(ie);
    else  ppo(ipo).a1 = ao(1:na);  ppo(ipo).T1 = ao(end-1);
      [f,df] = ksfmms3([ppo(ipo).a1; ppo(ipo).T1; 0],L,0.1);
      ppo(ipo).r1 = norm(f);  edf = eig(df(1:na,1:na)+eye(na));
      [sedf, ie] = sort(abs(edf),1,'descend'); ppo(ipo).e1 = edf(ie); end      
  end
  if PFLG == 1, save ks22f90h25 rpo -append
  elseif PFLG == -1, save ks22f90h25 ppo -append, end, diary off

  
%% Use time-and-space FT (after Lopez et al.)
  clear; load ks22seed140a;  d = 22;  N = 32;  x = d.*(1:N)'./N;  Nt = 64;  np = 4;
  h = tend/(Nt*np);  [tt, aa] = ksfmedt(d, tend, a0, h, np);
  figure(2); clf; plot(aa(1,:),aa(2,:),'.-');
  ek = exp((-2i*pi*ph/(d*Nt)).*((1:N/2-1)'*(0:Nt)));
  ap = ek.*(aa(1:2:end,:)+1i*aa(2:2:end,:));
  hold on; plot(real(ap(1,:)),imag(ap(1,:)),'r.-'); grid on;
  norm(ap(:,1)-ap(:,end)),
%  aa = zeros(N-2,Nt);  aa(1:2:end,:) = real(ap(:,1:end-1));  aa(2:2:end,:) = imag(ap(:,1:end-1));
%  for ii = 1:N/2,  figure(3); clf; plot(aa(2*ii-1,:),aa(2*ii,:),'.-'); grid on; pause; end,
  v = [zeros(1,Nt); ap(:,1:end-1); zeros(1,Nt); flipud(conj(ap(:,1:end-1)))];
  v = ifft(v,[],2);  u = real(fft2(v));  Nv = ifft2(u.^2);
  k = (2.*pi./d).*[0:N/2-1 0 -N/2+1:-1]';  L = k.^2 - k.^4;
  w = (2.*pi./tend).*[0:Nt/2-1 0 -Nt/2+1:-1];
  f = (repmat(L-1i*k*(ph/tend),1,Nt)+repmat(1i*w,N,1)).*v + 0.5i*repmat(k,1,Nt).*Nv;

%% Introduce intermediate points (ksfmms0 - multiple shooting)
  clear; load ks22uqo107a;  ni = [4 0];  d = 22;  N = 32;  h = 0.25;
  ni(2) = ceil(tend./(h.*(ni(1)+1)));
  [tt, aa] = ksfmedt(d, tend, a0, h, ni(2));
  ai = aa(:,1:end-1);  ai = [ai(:); tend-ni(1)*ni(2)*h; ph];
  hnew = 0.1;  ni(2) = round(ni(2)*h/hnew);  h = hnew;
  gi = ksfmfns(ai, d, h, ni);
%  load ks22seed123ai;
  options = optimset('Display','on', 'outputfcn',@ksoutfun,'MaxIter',2000, ...
      'MaxFunEvals',100000,'Jacobian','off','NonlEqnAlgorithm','lm','TolX',1e-12,'TolFun',1e-12);
  upo = fsolve(@(ai)ksfmfns(ai,d,h,ni),ai,options);

%% Evaluation of ksfmmint
  clear;  d = 22;  h = 0.25;  load ks22uqo040b;  tend = 50;
  [tt, aa] = ksfmmint(d, tend, a0, h, 1);
  g = aa-repmat(a0,1,size(aa,2));  gg = sum(g.^2)'.*h;  fa = aa;
  for ii = 1:size(aa,2),
    fa(:,ii) = ksfm(0, aa(:,ii), d); end
  fg = sum(fa.*g)';
  figure(1); clf; plot(tt,[gg fg],'.-'); grid on;

%% Analytic formula for minimum distance PSS
  clear;  syms a0 y0 y1 y0p y1p h dy dya s ys ysp a2 a3;
%  dy = (y1 - y0)./h;  dya = (y0 - a0)./h;
%  a2 = 3.*dy-y1p-2.*y0p;  a3 = y1p+y0p-2.*dy;
  ys = y0 + h*(y0p*s + a2*s^2 + a3*s^3);
  ysp = diff(ys,s);  cs = ysp*(ys-a0)/h^2;  collect(cs,s)

%% Explore various stabilising transformations for ksfmedt
  clear;  d = 22;  h = 0.25;  na = 30;  load ks22uqo042a;
  [tt, a, da] = ksfmjedt(d, tend, a0, h);
  k = (-2i*pi/d).*(1:na/2)';  ek = exp(k.*ph);
  c = ek.*(a(1:2:end,end)+1i*a(2:2:end,end));
  ap = a;  ap(1:2:end) = real(c);  ap(2:2:end) = imag(c);
  dc = repmat(ek,1,na).*(da(1:2:end,:)+1i*da(2:2:end,:));
  da(1:2:end,:) = real(dc);  da(2:2:end,:) = imag(dc);
  [U,T] = schur(da);  
  disp(sprintf(' %10.3f %10.3f %10.5f %10.5f %10.5f %10.5f\n',diag(T(1:6,1:6)),diag(T(2:7,1:6)))); 
  nr = 4;  r = U(:,nr);  la = T(1,1);
  figure(2); clf;
  for ir = (-4:0.1:4)./la,  ar = a0 + ir.*r;
    [tt, a] = ksfmjedt(d, tend, ar, h);
    c = ek.*(a(1:2:end,end)+1i*a(2:2:end,end));
    ap(1:2:end) = real(c);  ap(2:2:end) = imag(c);
    plot(ir,norm(ap-ar),'.'); hold on; end
  grid on;
%%  
  e = eig(da);  [ae, ie] = sort(abs(e),1,'descend');  disp(e(ie(1:6)));
  switch 2,
  case 1,  [R,T] = schur(da);  C = eye(na) - 2*R(:,2)*R(:,2)';
  case 2,  [U,S,V] = svd(da-eye(na));  C = -V*U';
  case 3,  [U,S,V] = svd(da-eye(na));  C = eye(na) - 2*U(:,1)*U(:,1)';
  end,
  es = eig(C*(da - eye(na)));  disp(es(1:6));
  
%% Stability of equilibria
  load ks22uss1a;  [h, dh] = ksfm(0, ksfmshift(a0), d);  [vdh, edh] = eig(dh);  edh = diag(edh);
  [sedh, ie] = sort(real(edh),1,'descend');  e1eig = edh(ie);  e1vec = vdh(:,ie);
  load ks22uss2a;  [h, dh] = ksfm(0, ksfmshift(a0), d);  [vdh, edh] = eig(dh);  edh = diag(edh);
  [sedh, ie] = sort(real(edh),1,'descend');  e2eig = edh(ie);  e2vec = vdh(:,ie);
  load ks22uss3b;  [h, dh] = ksfm(0, ksfmshift(a0), d);  [vdh, edh] = eig(dh);  edh = diag(edh);
  [sedh, ie] = sort(real(edh),1,'descend');  e3eig = edh(ie);  e3vec = vdh(:,ie);
  disp(' 1-wave equilibrium  2-wave equilibrium  3-wave equilibrium');
  disp([e1eig(1:10) e2eig(1:10) e3eig(1:10)]);
%   disp('1-wave equilibrium');
%   disp(sprintf(' (%9.5f,%9.5f)  (%7.3f,%7.3f,%7.3f,%7.3f,%7.3f,%7.3f, ... )',...
%     [real(e1eig(1)); imag(e1eig(1)); real(e1vec(1:6,1))]));
%   disp(sprintf(' (%9.5f,%9.5f)  (%7.3f,%7.3f,%7.3f,%7.3f,%7.3f,%7.3f, ... )',...
%     [real(e1eig(2)); imag(e1eig(2)); imag(e1vec(1:6,1))]));
%   disp(sprintf(' (%9.5f,%9.5f)  (%7.3f,%7.3f,%7.3f,%7.3f,%7.3f,%7.3f, ... )',...
%     [real(e1eig(3)); imag(e1eig(3)); real(e1vec(1:6,3))]));
%   disp(sprintf(' (%9.5f,%9.5f)  (%7.3f,%7.3f,%7.3f,%7.3f,%7.3f,%7.3f, ... )',...
%     [real(e1eig(4)); imag(e1eig(4)); imag(e1vec(1:6,3))]));
%   disp(sprintf(' (%9.5f,%9.5f)  (%7.3f,%7.3f,%7.3f,%7.3f,%7.3f,%7.3f, ... )',...
%     [real(e1eig(5)); imag(e1eig(5)); real(e1vec(1:6,5))]));
%   disp(sprintf(' (%9.5f,%9.5f)  (%7.3f,%7.3f,%7.3f,%7.3f,%7.3f,%7.3f, ... )',...
%     [real(e1eig(6)); imag(e1eig(6)); real(e1vec(1:6,6))]));
%   disp(sprintf(' (%9.5f,%9.5f)  (%7.3f,%7.3f,%7.3f,%7.3f,%7.3f,%7.3f, ... )',...
%     [real(e1eig(7)); imag(e1eig(7)); imag(e1vec(1:6,6))]));
%   disp(sprintf(' (%9.5f,%9.5f)  (%7.3f,%7.3f,%7.3f,%7.3f,%7.3f,%7.3f, ... )\n',...
%     [real(e1eig(8:10)'); imag(e1eig(8:10)'); real(e1vec(1:6,8:10))]));
  
%% Stability of equilibria
  load ks22uss1a;  [h, dh] = ksfm(0, a0, d);  [vdh, edh] = eig(dh);  edh = diag(edh);
  [sedh, ie] = sort(real(edh),1,'descend');  e1eig = edh(ie);  e1vec = vdh(:,ie);
  load ks22uss2a;  [h, dh] = ksfm(0, a0, d);  [vdh, edh] = eig(dh);  edh = diag(edh);
  [sedh, ie] = sort(real(edh),1,'descend');  e2eig = edh(ie);  e2vec = vdh(:,ie);
  load ks22uss3b;  [h, dh] = ksfm(0, a0, d);  [vdh, edh] = eig(dh);  edh = diag(edh);
  [sedh, ie] = sort(real(edh),1,'descend');  e3eig = edh(ie);  e3vec = vdh(:,ie);
  disp(' 1-wave equilibrium  2-wave equilibrium  3-wave equilibrium');
  disp([e1eig(1:10) e2eig(1:10) e3eig(1:10)]);

%% Evolution of orbits starting in the unstable manifolds of the equilibria
  load ks22uss1a;  tend = 150;  np = 3;
  a1 = a0 + 1e-3.*real(e1vec(:,1)); 
  [tt, aa] = ksfmedt(d, tend, a1, h, np);  [x, uu] = ksfm2real(aa, d, 64);
  figure(1); set(gcf,'pos',[100 500 800 400]); clf;
  ax1 = axes('pos',[0.06 0.10 0.20 0.80]); pcolor(x,tt,uu'); caxis([-3 3]);
    shading flat; title('1-wave, plane 1');

  for angl = (0:.05:2)*pi,
    a1 = a0 + 1e-3.*(cos(angl).*real(e1vec(:,1))+sin(angl).*imag(e1vec(:,1)));
    [tt, aa] = ksfmedt(d, tend, a1, h, np);  [x, uu] = ksfm2real(aa, d, 64);
    pcolor(x,tt,uu'); caxis([-3 3]); shading flat; title(['\alpha = ' num2str(angl)]);
    pause; end,

  a1 = a0 + 1e-3.*real(e1vec(:,3));
  [tt, aa] = ksfmedt(d, tend, a1, h, np);  [x, uu] = ksfm2real(aa, d, 64);
  ax2 = axes('pos',[0.30 0.10 0.20 0.80]); pcolor(x,tt,uu'); caxis([-3 3]);
    shading flat; title('1-wave, plane 2');

  for angl = (0:.05:2)*pi,
    a1 = a0 + 1e-3.*(cos(angl).*real(e1vec(:,3))+sin(angl).*imag(e1vec(:,3)));
    [tt, aa] = ksfmedt(d, tend, a1, h, np);  [x, uu] = ksfm2real(aa, d, 64);
    pcolor(x,tt,uu'); caxis([-3 3]); shading flat; title(['\alpha = ' num2str(angl)]);
    pause; end,

  load ks22uss2a;  tend = 150;  np = 2;
  a1 = a0 + 1e-3.*imag(e2vec(:,1)); 
  [tt, aa] = ksfmedt(d, tend, a1, h, np);  [x, uu] = ksfm2real(aa, d, 64);
  ax3 = axes('pos',[0.54 0.10 0.20 0.80]); pcolor(x,tt,uu'); caxis([-3 3]);
    shading flat; title('2-wave equilibrium');

  for angl = (0:.05:2)*pi,
    a1 = a0 + 1e-3.*(cos(angl).*real(e2vec(:,1))+sin(angl).*imag(e2vec(:,1)));
    [tt, aa] = ksfmedt(d, tend, a1, h, np);  [x, uu] = ksfm2real(aa, d, 64);
    pcolor(x,tt,uu'); caxis([-3 3]); shading flat; title(['\alpha = ' num2str(angl)]);
    pause; end,

  load ks22uss3b;  tend = 150;  np = 2;
  a1 = a0 + 1e-3.*e3vec(:,1);
  [tt, aa] = ksfmedt(d, tend, a1, h, np);  [x, uu] = ksfm2real(aa, d, 64);
  ax4 = axes('pos',[0.78 0.10 0.20 0.80]); pcolor(x,tt,uu'); caxis([-3 3]);
    shading flat; title('3-wave equilibrium');
    
  for angl = (0:.05:2)*pi,
    a1 = a0 + 1e-3.*(cos(angl).*e3vec(:,1)+sin(angl).*e3vec(:,2));
    [tt, aa] = ksfmedt(d, tend, a1, h, np);  [x, uu] = ksfm2real(aa, d, 64);
    pcolor(x,tt,uu'); caxis([-3 3]); shading flat; title(['\alpha = ' num2str(angl)]);
    pause; end,

%% Improve accuracy of equilibria and save results in kse22orbits
% eq(k).a; eq(k).eig; eq(k).evec;
% save kse22orbits eq tw rpo L h
  clear;  load kse22orbits;
  L = 2*pi*3.5;  N = 32;  % number of modes (number of ODEs = 2*N-2)
  names = {'ks22uss1a'; 'ks22uss2a'; 'ks22uss3a'};
  for k = 1:length(names),
    load(names{k});
    if length(a0) < 2*N-2, n = 2*N-2-length(a0); end
    ae = [ksfmshift(a0); zeros(n,1)];
    options = optimset('Display','iter','Jacobian','on','TolX',1e-12,'TolFun',1e-15);
    ae = fsolve(@(a)ksfm(0,a,L),ae,options);  ae = ksfmshift(ae);
    fae = ksfm(0,ae,L);  disp(['|f(ae)| = ' num2str(norm(fae))]);
%    [tt,aa] = ksfmedt(L, 500, ae, 0.1, 10); [x, uu] = ksfm2real(aa, L);
%    figure(1); clf; pcolor(x,tt,uu'); tall(1.1); shading flat; caxis([-3 3]); pause; 
    [hh, dh] = ksfm(0, ae, L);  [vdh, edh] = eig(dh);  edh = diag(edh);
    [sedh, ie] = sort(real(edh),1,'descend');
    eq(k).a = ae;  eq(k).eig = edh(ie);  eq(k).evec = vdh(:,ie);
  end
  save kse35orbits eq L

%% Improve accuracy of relative equilibria and save results in kse22orbits
% re(k).a;  re(k).c;  re(k).eig;  re(k).evec;
  clear;  L = 22;  N = 32;  % number of modes (number of ODEs = 2*N-2)
  names = {'ks22utw1a'; 'ks22utw2a'};
  for k = 1:length(names),
    load(names{k});
    if length(a0) < 2*N-2, n = 2*N-2-length(a0);  
      are = [ksfmshift(a0); zeros(n,1)];  
    else are = ksfmshift(a0); end
    if c < 0; are(1:2:end) = -are(1:2:end); c = -c; end
    options = optimset('Display','iter','Jacobian','on','TolX',1e-14,'TolFun',1e-15,'DerivativeCheck','on');
    aa = fsolve(@(a)ksfmtr(a,L),[are; c],options);
    re(k).a = ksfmshift(aa(1:end-1));  re(k).c = aa(end);
    [f,df] = ksfmtr([re(k).a;re(k).c],L); disp(['|f(re)| = ' num2str(norm(f))]);
%   [tt,aa] = ksfmedt(L, 100, re(1).a, 0.1, 2); [x, uu] = ksfm2real(aa, L);
%   figure(1); clf; pcolor(x,tt,uu'); tall(1.1); shading flat; caxis([-3 3]); pause; 
    [vdf, edf] = eig(df(1:end-1,1:end-1));  edf = diag(edf);
    [sedf, ie] = sort(real(edf),1,'descend');
    re(k).eig = edf(ie);  re(k).evec = vdf(:,ie); end
  save kse22orbits re -append

%% ===Improve accuracy of RPOs and save results in kse22orbits===
% rpo(k).a;  rpo(k).T;  rpo(k).d;  rpo(k).eig;  rpo(k).evec;  
  clear;  load kse22orbits;
  L = 22;  N = 32;  % number of modes (number of ODEs = 2*N-2)
  hh = 0.1;         % integration stepsize for ksfmedt
  switch 4,
  case 1, load ks22names;  iname = 102; load(name(iname,:),'a0','tend','ph');
  case 2, load('ks22uqo169a','a0','tend','ph','h');
  case 3, ipo = 191;  a0 = rpo(ipo).a;  tend = rpo(ipo).T;  ph = rpo(ipo).d;
  case 4, ip = 43;  f90 = load('ks22dupo01s.rpo');  d = 22;  h = 0.25;
          tend = f90(ip,3); ph = f90(ip,4);  a0 = f90(ip,5:end)';
  end
  disp(['Period = ' num2str(tend) '  Phase = ' num2str(ph)]);
  for hh = 0.1:-0.05:0.1,
    np = round(tend/10.0); nstp = floor(tend./h);  mstp = floor(nstp./np./2).*2;
    disp(['Using multiple shooting: ' num2str([np mstp]) '  ' num2str(tend-h*mstp*(np-1))]);
    [tt, aa] = ksfmstp(a0, L, h, mstp*(np-1), mstp);
    if size(aa,1) < N-2, aa = [aa; zeros(N-2-size(aa,1),size(aa,2))]; end
    ai = [aa(:); tend; ph]; mstp = round(mstp*h/hh); h = hh; 
    gi = ksfmms(ai, L, h, mstp, np); disp(['|gms| = ' num2str(norm(gi))]);
    options = optimset('Display','on','outputfcn',@ksoutfun2,'MaxIter',2000, ...
      'MaxFunEvals',500000,'Jacobian','on','NonlEqnAlgorithm','lm','TolX',1e-12,'TolFun',1e-12);
    upo = fsolve(@(ai)ksfmms3(ai,L,h,mstp,np),ai,options);
    a0 = upo(1:N-2); tend = upo(end-1); ph = upo(end);
    figure(2); hold on; plot(tend,ph,'ko','markersize',7); hold off; end
  if 0,
    np = round(tend/20.0); nstp = floor(tend./h); mstp = floor(nstp./np./2).*2;
    disp(['Using multiple shooting: ' num2str([np mstp]) '  ' num2str(tend-h*mstp*(np-1))]);
    [tt, aa] = ksfmstp(a0, L, h, mstp*(np-1), mstp);
    if size(aa,1) < 2*N-2, aa = [aa; zeros(2*N-2-size(aa,1),size(aa,2))]; end
    ai = [aa(:); tend; ph]; mstp = round(mstp*h/hh); h = hh; 
    gi = ksfmms3(ai, L, h, mstp, np); disp(['|gms| = ' num2str(norm(gi))]);
    options = optimset('Display','on','outputfcn',@ksoutfun2,'MaxIter',2000, ...
      'MaxFunEvals',500000,'Jacobian','on','NonlEqnAlgorithm','lm','TolX',1e-12,'TolFun',1e-12);
    upo = fsolve(@(ai)ksfmms3(ai,L,h,mstp,np),ai,options);
    a0 = upo(1:2*N-2); tend = upo(end-1); ph = upo(end);
    figure(2); hold on; plot(tend,ph,'ko','markersize',7); hold off; end  
%  [tt, aa] = ksfmstp(a0, L, h, ceil(tend./h),5);
%  figure(5); clf; plot(aa(1,:),aa(2,:),'.-'); pause;
  if length(a0) < 2*N-2, n = 2*N-2-length(a0); a0 = [ksfmshift(a0); zeros(n,1)];
  else a0 = ksfmshift(a0); end
  if ph > L/2, ph = ph-L; elseif ph < -L/2, ph = ph+L; end
  if ph < 0, ph = -ph; a0(1:2:end) = -a0(1:2:end); end
  options = optimset('Display','on','outputfcn',@ksoutfun2,'MaxIter',5000, ...
    'MaxFunEvals',20000,'Jacobian','on','NonlEqnAlgorithm','lm','TolX',1e-12,'TolFun',1e-12);
  [upo,fval,eflag] = fsolve(@(a)ksfmms3(a,L,h,1),[a0;tend;ph],options);
  a0 = upo(1:end-2); tend = upo(end-1); ph = upo(end);
  for ic = 1:0, format short g;
    [g, jac] = ksfmf5(0,[a0;tend;ph],L,h,eye(2*N),[1 1]);
    disp(['|g|=' num2str(norm(g(1:end-2)))]);  de = eig(jac(1:end-2,1:end-2)+eye(2*N-2)); 
    [se,ie]=sort(abs(de),'descend');  disp(de(ie(1:10)));
    [u,C,v] = svd(jac);  C = -v*u';  alpha = [1e0 1e0];
%    [u,C,v] = svd(jac(1:end-2,1:end-2)); C = blkdiag(-v*u',eye(2)); format short;
    options = odeset('abstol',1e-15,'reltol',2.3e-14,'outputfcn',@ksdupoplot4);
    [s,y] = ode15s(@(t,a)ksfmf5(t,a,L,h,C,alpha), [0 100000], [a0; tend; ph], options);
    a0 = y(end-1,1:end-2)'; tend = y(end-1,end-1), ph = y(end-1,end),
    but = input('Stop? ','s');  if but == 'y', break; end, end
% Determine if this orbit already exists in rpo
  if exist('rpo'), ipo = max(find([rpo.T] < tend+1e-4)); add = 1; repl = 0;
   if isempty(ipo), ipo = 0; add = 1;
   elseif abs(rpo(ipo).T-tend) < 1e-4,  % exists
     disp(['This RPO appears similar to the existing one: ipo = ' num2str(ipo)]);
     f = ksfmms3([rpo(ipo).a; rpo(ipo).T; rpo(ipo).d],L,h);
     disp(num2str([rpo(ipo).T tend; rpo(ipo).d ph; 0 norm(f(1:end-2))])); add = 0; 
     but = input('Replace? ','s'); if but == 'y', add = 1; repl = 1; end, end
  else ipo = 0;  add = 1;  rpo = []; end
  if add == 1, if repl == 0, ipo = ipo+1;
      for iit = size(rpo,2):-1:ipo,  rpo(iit+1) = rpo(iit); end, end
    rpo(ipo).a = a0;  rpo(ipo).T = tend;  rpo(ipo).d = ph;
    [f,df] = ksfmms3([rpo(ipo).a;rpo(ipo).T;rpo(ipo).d],L,h); 
    disp(['|f|=' num2str(norm(f(1:end-2)))]);
    [vdf,edf] = eig(df(1:end-2,1:end-2)+eye(2*N-2)); edf = diag(edf);
    [sedf, ie] = sort(abs(edf),1,'descend');
    rpo(ipo).eig = edf(ie);  rpo(ipo).evec = vdf(:,ie);
    disp(['Added orbit ' num2str(ipo) ' of ' num2str(size(rpo,2))]);
    disp(['Period = ' num2str(tend) '  Phase = ' num2str(ph)]);
    disp('Eigenvalues:'); format short g; disp(rpo(ipo).eig(1:8));
    save kse22orbits rpo h -append
  end
  

%% Explore unstable manifolds of equilibria (3-wave)
  clear;  load kse22orbits;  k = 3;  h = 0.1;  delta = 1e-4;  tend = 250;
  v = gsorth([real(eq(k).evec(:,1)) imag(eq(k).evec(:,1)) eq(k).evec(:,4)]);
  figure(1); clf;  figure(2); clf; 
  for dphi = -2e-12:1e-12:2e-12; %0.2532017200:0.0000000001:0.2532017208, %(0:0.1:6)*pi./3,
    phi = atan(v(1,2)./v(1,1)) + pi/2 + dphi;
    a0 = eq(k).a + delta.*(v(:,1).*cos(phi)+v(:,2).*sin(phi));
    [tt, aa] = ksfmedt(L, tend, a0, h, 2);
    [x, uu] = ksfm2real(aa, L, 64);  av = v'*aa;
    figure(1);  pcolor(x,tt,uu'); caxis([-3 3]); shading flat;  hold on;
    title(['\phi = ' sprintf('%15.12f',phi)]);
    figure(2);  plot3(av(1,:),av(2,:),av(3,:),'-'); 
    hold on; grid on; axis equal; view(0,90); pause;
  end,

%% Explore unstable manifolds of equilibria (2-wave)
  clear;  load kse22orbits;  k = 2;  h = 0.1;  tend = 400;
  ere = real(eq(k).eig(1));  eim = imag(eq(k).eig(1));
  period = 2*pi/eim;  scale = exp(ere*period);
  v = gsorth([real(eq(k).evec(:,1)) imag(eq(k).evec(:,1)) real(eq(k).evec(:,7))]);
  figure(1); clf;  figure(2); clf; 
  for delta = 0.2535144:.0000001:0.2535145, %0:0.1:ere*period,
    a0 = eq(k).a + 1e-4.*exp(delta).*v(:,2);
    [tt, aa] = ksfmedt(L, tend, a0, h, 5);
    [x, uu] = ksfm2real(aa, L, 64);  av = v'*aa;
    figure(1);  pcolor(x,tt,uu'); caxis([-3 3]); shading flat;  hold on;
    title(['\delta = ' sprintf('%12.9f',delta)]);
    figure(2);
    plot3(av(1,:),av(2,:),av(3,:),'-'); hold on; grid on; axis equal; pause;
 %   plot(av(1,:),av(2,:),'-'); hold on; grid on; axis equal; pause;
 %   plot3(tt,av(1,:),av(2,:),'.-'); hold on; grid on; view(0,0); pause;
  end,

%% Explore unstable manifolds of equilibria (1-wave, plane 1,2: p = 1,3)
  clear;  load kse22orbits;  k = 1;  p = 3;  h = 0.1;  tend = 200;
  ere = real(eq(k).eig(p));  eim = imag(eq(k).eig(p));
  period = 2*pi/eim;  scale = exp(ere*period);
  v = gsorth([real(eq(k).evec(:,p)) imag(eq(k).evec(:,p)) real(eq(k).evec(:,6))]);
  figure(1); clf;  figure(2); clf; 
  for delta = 0:0.05:ere*period,
    a0 = eq(k).a + 1e-4.*exp(delta).*v(:,2);
    [tt, aa] = ksfmedt(L, tend-delta/ere, a0, h, 2);
    [x, uu] = ksfm2real(aa, L, 64);  av = v'*aa;
    figure(1);  pcolor(x,tt,uu'); caxis([-3 3]); shading flat;
    title(['\delta = ' num2str(delta)]);
    figure(2);
    plot3(av(1,:),av(2,:),av(3,:),'-'); hold on; grid on; axis equal; view(-30,30); pause;
 %   plot(av(1,:),av(2,:),'-'); hold on; grid on; axis equal; pause;
  end,

%% Plot equilibria and travelling waves in (u,u_x,u_xx) coordinates
  clear;  load kse22orbits; colr = ['b';'r';'k'];
  figure(1); set(gcf,'pos',[420 500 560 450]); clf;
  ax1 = axes('Position',[0.05 0.0828 0.788 0.907]);
  axis(ax1,[-2.597 2.597 -3.002 1.459 -2.804 2.804]);
  xlabel(ax1,'u'); ylabel(ax1,'u_x'); zlabel(ax1,'u_{xx}','rotat',0);
  view(ax1,[25 25]); grid(ax1,'on'); hold(ax1,'all');
  for k = 1:3, [x,u,ux,uxx] = ksfm2real(eq(k).a,L,128);
    plot3(u,ux,uxx,['.-' colr(k)]); hold on; end
  grid on; axis equal; set(gca,'pos',[0.03 0.05 0.9 0.94]); view(25,25);
  lg1 = legend(ax1,{'1-wave','2-wave','3-wave'});
  set(lg1,'pos',[0.75 0.3 0.18 0.14]);  set(ax1,'pos',[0.02 0.0828 0.788 0.907]);
  set(get(gca,'xlabel'),'pos',[17 -39 15.2]);  set(get(gca,'ylabel'),'pos',[20 -37 15.5]);
  set(get(gca,'zlabel'),'pos',[-1.9 -5.8 1.6]);
  
%% PCA for ksfm
  clear; 
  d = 22;  h = 0.25;  N = 20;  x = d.*(1:N)'./N;  np = 10;  tsampl = 2020;
  a0 = zeros(N-2,1); randn('seed',22000001);  a0(1:6) = 0.2*randn(6,1);
  [tt, aa, a0p, ap] = ksfmedt(d, tsampl, a0, h, np);  na = size(aa,2);
  v = aa(1:2:end,:) + 1i*aa(2:2:end,:);
  v = [zeros(1,size(aa,2)); v; zeros(1,size(aa,2)); flipud(conj(v))];
  u = real(fft(v));
  figure(1); set(gcf,'pos',[5 35 250 910]); clf; 
  pcolor(x,tt,u'); shading flat; tall(1.1); hold on;

%%
  X = aa(:,6:end);  % sample set;
  mX = mean(X')';  B = X - repmat(mX,1,size(X,2));
  C = (B*B')./size(X,2);  [V,D] = eig(C);  d = diag(D);
  [sd, id] = sort(d,1,'descend');  V = V(:,id);  D = diag(sd);
  cumE = cumsum(sd)./sum(sd);  nP = min(find(cumE > 0.99));
  Vn = V(:,1:nP);  v = Vn(1:2:end,:) + 1i*Vn(2:2:end,:);
  v = [zeros(1,size(Vn,2)); v; zeros(1,size(Vn,2)); flipud(conj(v))];
  u = real(fft(v));
  figure(2); clf;  plot(x,u,'.-');

%% Plot RPOs in real space
  clear;  load kse22orbits; nst = length(rpo); nax = 6; np = 10; te = 200;
  for ist = 1:314,  ost = 1:nst;
%  for ist = 1:nax, % ost = [3 22 50 57 95];
%  for ist = 1:nax,  ost = [2 23 52 58 113 151]; %ost = [73:78];
%   ipo = find(abs([rpo.d]) < 1e-4);  % Periodic Orbits
%   for ist = 1:4*nax,  ost = ipo([[1:nax] [1:nax]*2+nax [1:nax]*2+3*nax [1:nax]*3 + 5*nax]);
%   ipo = find(abs([rpo.d]) > 1e-4);  % RPOs
%   for ist = 1:4*nax,  ost = ipo([[1:nax] [1:nax]*5+nax [1:nax]*10+6*nax [1:nax]*20 + 16*nax]);
    iorb = mod(ist-1,nax)+1;
    if iorb == 1,  
%      fig1 = figure('PaperPosition',[1.0 1.0 33 17],'PaperOrient','port',...
%         'PaperSize',[20.98 29.68],'Position',[35 200 1200 600]);
      fig1 = figure('PaperPosition',[1.0 1.0 24 16],'PaperOrient','port',...
         'PaperSize',[20.98 29.68],'Position',[35 200 900 600]);
      hax = subplots(1,nax,[0.03 0.03 0.07 0.15],[0.015 0 0 0]); end

    a0 = rpo(ost(ist)).a;  tend = rpo(ost(ist)).T;  ph = rpo(ost(ist)).d;
    N = length(a0)+2;  ek = exp((2i*pi/L).*ph.*(1:N/2-1)');
    [tt, aa] = ksfmetd2(a0, L, h, tend, np);
    tti = tt(1:end-1);  aai = aa(:,1:end-1);  ne = ceil(te./tend);  aav = aa;
    for ie = 1:ne-1,
      vi = (aav(1:2:end,:)+1i*aav(2:2:end,:)).*repmat(ek,1,size(aav,2));
      aav(1:2:end,:) = real(vi);  aav(2:2:end,:) = imag(vi);
      aai = [aai aav(:,1:end-1)];  tti = [tti tt(1:end-1)+ie*tend]; end
    [x, uui] = ksfm2real(aai, L);
          
    axes(hax(iorb)); pcolor(x,tti,uui'); shading flat; caxis([-3 3]);  hold on;
    plot(x([1 end])*ones(1,ne),[tend;tend]*(1:ne),'w-');
    plot(mod([ph;ph]*(1:ne-1),L)-L/2,[(1:ne-1);(2:ne)]*tend,'w-');
    title([sprintf('%3d\n T=%6.2f \n',ost(ist),tend) '\Delta=' sprintf('%7.3f',ph)]);
    set(gca,'ticklength',0.7*get(gca,'ticklength'),'tickdir','out',...
        'ylim',[0 te],'ytick',20:20:te,'box','off');  xlabel('x');
    if iorb > 1, set(gca,'yticklabel',[]); end
    if iorb == nax,
      hax(nax+1) = axes('pos',[.04 .9 .9 .07]);
      tit1 = 'Kuramoto-Sivashinsky: $u_t = -uu_x - u_{xx} - u_{xxxx}$~~,~~';
      tit2 = ['$x \in [-L/2, L/2]$;~~ BC: $u(x+L,t) = u(x,t)$;~~$'];
      tit3 = ['$' sprintf(' L = %4.1f ',L) '$;~' '~~Solutions of the form: $u(x+d,T/2) = -u(-x,0)$'];
      text(0.0,.9,[tit1 tit3],'interp','latex','fontsize',10);  set(hax(nax+1),'visi','off');
      axes(hax(1)); ylabel('t','rotat',0); 
%      print(gcf,'-dpng',sprintf('ks22rpos%05.1f-%05.1f.png',rpo(ost(ist-nax+1)).T,rpo(ost(ist)).T)); delete(fig1);   
    end
  end
  
%% Plot RPOs and PPOs from ks22f90 in real space (14-Jan-2010)
  clear;  load ks22f90h25t100; nax = 6;  np = 10;  te = 100;
  h = 0.1;  rpoflg = 1;
  if rpoflg, nst = length(rpo); else nst = length(ppo); end
  for ist = 1:nst,  ost = 1:nst;
%  for ist = 1:nax, % ost = [3 22 50 57 95];
%  for ist = 1:nax,  ost = [2 23 52 58 113 151]; %ost = [73:78];
%   ipo = find(abs([rpo.d]) < 1e-4);  % Periodic Orbits
%   for ist = 1:4*nax,  ost = ipo([[1:nax] [1:nax]*2+nax [1:nax]*2+3*nax [1:nax]*3 + 5*nax]);
%   ipo = find(abs([rpo.d]) > 1e-4);  % RPOs
%   for ist = 1:4*nax,  ost = ipo([[1:nax] [1:nax]*5+nax [1:nax]*10+6*nax [1:nax]*20 + 16*nax]);
    iorb = mod(ist-1,nax)+1;
    if iorb == 1,  
%      fig1 = figure('PaperPosition',[1.0 1.0 33 17],'PaperOrient','port',...
%         'PaperSize',[20.98 29.68],'Position',[35 200 1200 600]);
      fig1 = figure('PaperPosition',[1.0 1.0 24 16],'PaperOrient','port',...
         'PaperSize',[20.98 29.68],'Position',[35 200 900 600]);
      hax = subplots(1,nax,[0.03 0.03 0.07 0.15],[0.015 0 0 0]); end

    if rpoflg, a0 = rpo(ost(ist)).a1;  tend = rpo(ost(ist)).T1;  ph = rpo(ost(ist)).s1;  eig = rpo(ost(ist)).e1(1:8); pflg = 1;
    else a0 = ppo(ost(ist)).a1;  tend = ppo(ost(ist)).T1;  ph = 0;  eig = ppo(ost(ist)).e1(1:8);  pflg = -1; end
    N = length(a0)+2;  ek = exp((2i*pi/L).*ph.*(1:N/2-1)');
    [tt, aa] = ksfmetd2(a0, L, h, tend, np);
    tti = tt(1:end-1);  aai = aa(:,1:end-1);  ne = ceil(te./tend);  aav = aa;
    for ie = 1:ne-1,
      if pflg == 1,
        vi = (aav(1:2:end,:)+1i*aav(2:2:end,:)).*repmat(ek,1,size(aav,2));
        aav(1:2:end,:) = real(vi);  aav(2:2:end,:) = imag(vi);  aai = [aai aav(:,1:end-1)];
      elseif pflg == -1,  aav(1:2:end,:) = -aav(1:2:end,:);  aai = [aai aav(:,1:end-1)];
      end, tti = [tti tt(1:end-1)+ie*tend];  end
    [x, uui] = ksfm2real(aai, L);
          
    axes(hax(iorb)); pcolor(x,tti,uui'); shading flat; caxis([-3 3]);  hold on;
    plot(x([1 end])*ones(1,ne),[tend;tend]*(1:ne),'w-');
    plot(mod([ph;ph]*(1:ne-1),L)-L/2,[(1:ne-1);(2:ne)]*tend,'w-');
    if pflg == 1,  title([sprintf('%3d\n T=%6.2f \n',ost(ist),tend) '\Delta=' sprintf('%7.3f',ph)]);
    elseif pflg == -1,  title([sprintf('%3d\n T=%6.2f',ost(ist),tend)]); end
    set(gca,'ticklength',0.7*get(gca,'ticklength'),'tickdir','out',...
        'ylim',[0 te],'ytick',20:20:te,'box','off');  xlabel('x');
    if iorb > 1, set(gca,'yticklabel',[]); end
    if iorb == nax,
      hax(nax+1) = axes('pos',[.04 .9 .9 .07]);
      tit1 = 'Kuramoto-Sivashinsky: $u_t = -uu_x - u_{xx} - u_{xxxx}$~~,~~';
      tit2 = ['$x \in [-L/2, L/2]$;~~ BC: $u(x+L,t) = u(x,t)$;~~$'];
      tit3 = ['$' sprintf(' L = %4.1f ',L) '$;~'];
      if pflg == 1, tit4 = ['~~RPOs: $u(x+\Delta,T) = u(x,0)$'];
      else tit4 = ['~~PPOs: $u(x,T) = -u(-x,0)$']; end
      text(0.0,.9,[tit1 tit2 tit3 tit4],'interp','latex','fontsize',10);  set(hax(nax+1),'visi','off');
      axes(hax(1)); ylabel('t','rotat',0);
      if pflg == 1, print(gcf,'-dpng',sprintf('ks22rpos%05.1f-%05.1f.png',rpo(ost(ist-nax+1)).T1,rpo(ost(ist)).T1));
      elseif pflg == -1,  print(gcf,'-dpng',sprintf('ks22ppos%05.1f-%05.1f.png',ppo(ost(ist-nax+1)).T1,ppo(ost(ist)).T1));   
      end,  delete(fig1);   
    end
  end
  
%% Plot individual RPOs with the first 4 FMs in polar coordinates
  clear;  load kse22orbits;  te = 200;  np = 1;  refl = 0;
  for ist = 57:57, ost = 1:314; %ost = [1 2 5 10 50]; %ost = 20:5:40;
    a0 = rpo(ost(ist)).a;  tend = rpo(ost(ist)).T;  ph = rpo(ost(ist)).d;
    if refl, a0r = a0;  a0r(1:2:end) = -a0r(1:2:end);  phr = -ph; end
    eig = rpo(ost(ist)).eig(1:8);
    N = length(a0)+2;  ek = exp((2i*pi/L).*ph.*(1:N/2-1)');
    [tt, aa] = ksfmedt(L, tend, a0, h, 1);
    if refl, [tr, ar] = ksfmedt(L, tend, a0r, h, 1); end,
    if 0, % shift orbit in time
      [maa, ima] = max(sum(aa.^2)');  %disp([ima size(aa,2)]);
      if ima > 1, tt = [tt(ima:end) tt(2:ima)+tend]-tt(ima);
        aas = aa(:,2:ima);
        vi = (aas(1:2:end,:)+1i*aas(2:2:end,:)).*repmat(ek,1,ima-1);
        aas(1:2:end,:) = real(vi);  aas(2:2:end,:) = imag(vi);
        aa = [aa(:,ima:end) aas]; end, end
    if 1, phase = -52/360*L,% phase = 0.12, % shift orbit's phase
      vi = (aa(1:2:end,:) + 1i*aa(2:2:end,:)).*...
           repmat(exp((2i*pi/L).*phase.*(1:N/2-1)'),1,length(tt));
      aa(1:2:end,:) = real(vi);  aa(2:2:end,:) = imag(vi);
    end
    tti = tt(1:end-1);  aai = aa(:,1:end-1);  ne = ceil(te./tend);  aav = aa;
    for ie = 1:ne-1,
      vi = (aav(1:2:end,:)+1i*aav(2:2:end,:)).*repmat(ek,1,size(aav,2));
      aav(1:2:end,:) = real(vi);  aav(2:2:end,:) = imag(vi);
      aai = [aai aav(:,1:end-1)];  tti = [tti tt(1:end-1)+ie*tend]; end
    [x, uui] = ksfm2real(aai, L);
    
    fig1 = figure('PaperPosition',[1.0 1.0 26 18.5],'PaperOrient','port',...
         'PaperSize',[20.98 29.68],'Position',[35 200 1000 740]);
    ax(1) = axes('Position',[0.06 0.08 0.15 0.86],'Parent',fig1);
    ax(2) = axes('Position',[0.24 0.52 0.36 0.42],'Parent',fig1);
    ax(3) = axes('Position',[0.64 0.52 0.36 0.42],'Parent',fig1);
    ax(4) = axes('Position',[0.24 0.03 0.36 0.42],'Parent',fig1);
    ax(5) = axes('Position',[0.64 0.03 0.36 0.42],'Parent',fig1);
    ax(6) = axes('Position',[0.22 0.08 0.02 0.86],'Parent',fig1);
    ax(7) = axes('Position',[0.60 0.56 0.01 0.02],'Parent',fig1);
    axes(ax(1));  cmap = jet;
    pcolor(x,tti,uui'); caxis([-3 3]); shading flat; hold on;
    plot(x([1 end])*ones(1,ne),[tend;tend]*(1:ne),'w-');
    plot(mod([ph;ph]*(1:ne-1),L)-L/2,[(1:ne-1);(2:ne)]*tend,'w-');
    title([sprintf('%3d: T=%6.2f ',ost(ist),tend) '\Delta=' sprintf('%7.3f',ph)]); 
    set(gca,'ticklength',0.7*get(gca,'ticklength'),'tickdir','out',...
      'ylim',[0 te],'ytick',20:20:te,'box','off');  xlabel('x'); ylabel('Time');

    for iax = 1:4,   axes(ax(iax+1));
      vi = aa(2*iax-1,:) + 1i*aa(2*iax,:);  vim = max(abs(vi));
      polar(0,vim,'w.'); hold on;
      polarcol(angle(vi),abs(vi),tt,cmap);
      if refl, hold on; vr = ar(2*iax-1,:) + 1i*ar(2*iax,:);
        polarcol(angle(vr),abs(vr),tr,cmap); end
      title(sprintf('Mode %d',iax),'fontsize',14); end
    axes(ax(6)); plotcol(tt.*0,tt,tt,cmap); set(gca,'vis','off','ylim',[0 te]);
    axes(ax(7));
    text(1,0,sprintf('(%8.5f,%8.3f)\n',[log(abs(eig))./tend angle(eig)./pi]'),'vert','top','horiz','cen');
    text(0,1,'$(\log~|\lambda|/T,~\arg~(\lambda)/\pi)$','interp','latex','horiz','cen');
    set(gca,'vis','off');
    print(gcf,'-dpng',sprintf('ks22rpo%06.2f_%06.3f.png',tend,ph)); delete(fig1);
  end

%% Plot individual RPOs and PPOs from ks22f90 with the first 4 FMs in polar coordinates (19-Jan-2010)
  clear;  load ks22f90h25t100;  te = 100;  np = 1; h = 0.1; rpoflg = 0;
  if rpoflg, nst = length(rpo); else nst = length(ppo); end
  for ist = 14:100, ost = 1:nst;
    if rpoflg, a0 = rpo(ost(ist)).a1;  tend = rpo(ost(ist)).T1;  ph = rpo(ost(ist)).s1;  eig = rpo(ost(ist)).e1(1:8); pflg = 1;
    else a0 = ppo(ost(ist)).a1;  tend = ppo(ost(ist)).T1;  ph = 0;  eig = ppo(ost(ist)).e1(1:8);  pflg = -1; end
    N = length(a0)+2;  ek = exp((2i*pi/L).*ph.*(1:N/2-1)');
    [tt, aa] = ksfmetd2(a0, L, h, tend, 1);
    tti = tt(1:end-1);  aai = aa(:,1:end-1);  ne = ceil(te./tend);  aav = aa;
    for ie = 1:ne-1,
      if pflg == 1,
        vi = (aav(1:2:end,:)+1i*aav(2:2:end,:)).*repmat(ek,1,size(aav,2));
        aav(1:2:end,:) = real(vi);  aav(2:2:end,:) = imag(vi);  aai = [aai aav(:,1:end-1)];
      elseif pflg == -1,  aav(1:2:end,:) = -aav(1:2:end,:);  aai = [aai aav(:,1:end-1)];
      end, tti = [tti tt(1:end-1)+ie*tend];  end
%    [aa, ell, rho] = ksfm2fd(aa, L);  [aai, ell, rho] = ksfm2fd(aai, L);
%    [aa, ell, rho] = ksfm_o2(aa, L);  [aai, ell, rho] = ksfm_o2(aai, L);
%    [aa, ss] = ksfm_so2(aa, L);  [aai, ssi] = ksfm_so2(aai, L);
    [x, uui] = ksfm2real(aai, L);
    
%    fig1 = figure('PaperPosition',[1 14 19 14],'PaperOrient','port','Position',[35 200 1000 740]);
    fig1 = figure('PaperPosition',[1 1 26 20],'PaperOrient','landscape','Position',[35 200 1000 740]);
    ax(1) = axes('Position',[0.06 0.08 0.15 0.86],'Parent',fig1);
    ax(2) = axes('Position',[0.24 0.52 0.36 0.42],'Parent',fig1);
    ax(3) = axes('Position',[0.64 0.52 0.36 0.42],'Parent',fig1);
    ax(4) = axes('Position',[0.24 0.03 0.36 0.42],'Parent',fig1);
    ax(5) = axes('Position',[0.64 0.03 0.36 0.42],'Parent',fig1);
    ax(6) = axes('Position',[0.22 0.08 0.02 0.86],'Parent',fig1);
    ax(7) = axes('Position',[0.60 0.56 0.01 0.02],'Parent',fig1);
    axes(ax(1));  cmap = jet;
    pcolor(x,tti,uui'); caxis([-3 3]); shading flat; hold on;
    plot(x([1 end])*ones(1,ne),[tend;tend]*(1:ne),'w-');
    plot(mod([ph;ph]*(1:ne-1),L)-L/2,[(1:ne-1);(2:ne)]*tend,'w-');
    title([sprintf('%4d: T=%7.3f ',ost(ist),tend) '\Delta=' sprintf('%8.4f',ph)]); 
    set(gca,'ticklength',0.7*get(gca,'ticklength'),'tickdir','out',...
      'ylim',[0 te],'ytick',20:20:te,'box','off');  xlabel('x'); ylabel('Time');

    for iax = 1:4,   axes(ax(iax+1));
      vi = aa(2*iax-1,:) + 1i*aa(2*iax,:);  vim = max(abs(vi));
      polar(0,vim,'w.'); hold on;
      polarcol(angle(vi),abs(vi),tt,cmap);
      title(sprintf('Mode %d',iax),'fontsize',14); end
    axes(ax(6)); plotcol(tt.*0,tt,tt,cmap); set(gca,'vis','off','ylim',[0 te]);
    axes(ax(7));
    text(1,0,sprintf('(%8.5f,%8.3f)\n',[log(abs(eig))./tend angle(eig)./pi]'),'vert','top','horiz','cen');
    text(0,1,'$(\log~|\lambda|/T,~\arg~(\lambda)/\pi)$','interp','latex','horiz','cen');
    set(gca,'vis','off');
    if pflg == 1,
      print(gcf,'-dpng',sprintf('ks22rpo%06.2f_%06.3f_fm.png',tend,ph));
      %print(gcf,'-depsc2',sprintf('ks22rpo%06.2f_%06.3f_fm.eps',tend,ph));
      %print(gcf,'-dpdf',sprintf('ks22rpo%06.2f_%06.3f_fm.pdf',tend,ph));
    elseif pflg == -1, 
      print(gcf,'-dpng',sprintf('ks22ppo%06.2f_fm.png',tend));
      %print(gcf,'-depsc2',sprintf('ks22rpo%06.2f_%06.3f_fm.eps',tend,ph));
      %print(gcf,'-dpdf',sprintf('ks22ppo%06.2f_fm.pdf',tend));
    end
    pause; delete(fig1);
  end

%% Plot individual RPOs and PPOs from ks22f90 vs time (07-Feb-2010)
  clear;  load ks22f90h25t100;  te = 100;  np = 1; h = 0.1; rpoflg = 0;
  if rpoflg, nst = length(rpo); else nst = length(ppo); end
  for ist = 1:50, ost = 1:nst;
    if rpoflg, a0 = rpo(ost(ist)).a1;  tend = rpo(ost(ist)).T1;  ph = rpo(ost(ist)).s1;  eig = rpo(ost(ist)).e1(1:8); pflg = 1;
    else a0 = ppo(ost(ist)).a1;  tend = ppo(ost(ist)).T1;  ph = 0;  eig = ppo(ost(ist)).e1(1:8);  pflg = -1; end
    N = length(a0)+2;  ek = exp((2i*pi/L).*ph.*(1:N/2-1)');
    [tt, aa] = ksfmetd2(a0, L, h, tend, 1);  te = 2*tend;
    tti = tt(1:end-1);  aai = aa(:,1:end-1);  ne = ceil(te./tend);  aav = aa;
    for ie = 1:ne-1,
      if pflg == 1,
        vi = (aav(1:2:end,:)+1i*aav(2:2:end,:)).*repmat(ek,1,size(aav,2));
        aav(1:2:end,:) = real(vi);  aav(2:2:end,:) = imag(vi);  aai = [aai aav(:,1:end-1)];
      elseif pflg == -1,  aav(1:2:end,:) = -aav(1:2:end,:);  aai = [aai aav(:,1:end-1)];
      end, tti = [tti tt(1:end-1)+ie*tend];  end
    [aa, ss, rr] = ksfm_o2(aa, L);  [aai, ssi, rri] = ksfm_o2(aai, L);
%    [aa, ss] = ksfm_so2(aa, L);  [aai, ssi] = ksfm_so2(aai, L);
    [x, uui] = ksfm2real(aai, L);
    
%    fig1 = figure('PaperPosition',[1 14 19 14],'PaperOrient','port','Position',[35 200 1000 740]);
    fig1 = figure('PaperPosition',[1 1 20 26],'PaperOrient','portrait','Position',[5  35  715  940]);
    hax = subplots(5,1,[0.07 0.02 0.02 0.02],[0 0 0.02 0.02]);
    axes(hax(1)); cmap = jet;
    pcolor(tti,x,uui); caxis([-3 3]); shading flat; hold on;
    plot([tend;tend]*(1:ne),x([1 end])*ones(1,ne),'w-');
    plot([(1:ne-1);(2:ne)]*tend,mod([ph;ph]*(1:ne-1),L)-L/2,'w-');
    title([sprintf('%4d: T=%7.3f ',ost(ist),tend) '\Delta=' sprintf('%8.4f',ph)]); 
    set(gca,'ticklength',0.7*get(gca,'ticklength'),'tickdir','out',...
      'xlim',[0 te],'xtick',20:20:te,'box','off');  ylabel('x','rotat',0);% ylabel('Time');

    if exist('ssi'), axes(hax(2));
      plot(tti,2*ssi,'.-'); hold all;
      if exist('rri'); plot(tti,rri,'.-'); end;
      plot([tend tend],[-1 1],'k--');
      set(gca,'xlim',[0 te]);  end
    
    for iax = 1:3, axes(hax(iax+2));
      plot(tti,aai(2*iax-1,:),'b.-',tti,aai(2*iax,:),'r.-');
      set(gca,'xlim',[0 te]);  ylm = get(gca,'ylim'); hold on;
      plot([0 te],[0 0],'k--',[tend tend],ylm,'k--');
      ylabel(['FM ' num2str(iax)]);
    end
    if pflg == 1,
      print(gcf,'-dpng',sprintf('ks22rpo%06.2f_%06.3f_t_fd.png',tend,ph));
%      print(gcf,'-dpdf',sprintf('ks22rpo%06.2f_%06.3f_t_fd.pdf',tend,ph));
    elseif pflg == -1, 
      print(gcf,'-dpng',sprintf('ks22ppo%06.2f_t_fd.png',tend));
%      print(gcf,'-dpdf',sprintf('ks22ppo%06.2f_t_fd.pdf',tend));
    end
    pause; delete(fig1);    
  end
  
%% Plot RPOs and PPOs in M/SO(2) quotient space
  clear;  load ks22f90h25t100;  te = 100; np = 1; h = 0.1;
  for ist = [2:2], ost = 1:1000; ost = [1 4:6 18 30 62 123];
    a0 = rpo(ost(ist)).a1;  tend = rpo(ost(ist)).T1;  ph = rpo(ost(ist)).s1;  eig = rpo(ost(ist)).e1(1:8); pflg = 1;
%    a0 = ppo(ost(ist)).a1;  tend = ppo(ost(ist)).T1;  ph = 0;  eig = ppo(ost(ist)).e1(1:8);  pflg = -1;

    N = length(a0)+2;  ek = exp((2i*pi/L).*ph.*(1:N/2-1)');
    [tt, aa] = ksfmetd2(a0, L, h, tend, 1);
    tti = tt(1:end-1);  aai = aa(:,1:end-1);  ne = ceil(te./tend);  aav = aa;
    for ie = 1:ne-1,
      if pflg == 1,
        vi = (aav(1:2:end,:)+1i*aav(2:2:end,:)).*repmat(ek,1,size(aav,2));
        aav(1:2:end,:) = real(vi);  aav(2:2:end,:) = imag(vi);  aai = [aai aav(:,1:end-1)];
      elseif pflg == -1,  aav(1:2:end,:) = -aav(1:2:end,:);  aai = [aai aav(:,1:end-1)];
      end, tti = [tti tt(1:end-1)+ie*tend];  end
%    [aa, ell, rho] = ksfm2fd(aa, L);  [aai, ell, rho] = ksfm2fd(aai, L);
%    [aa, ell, rho] = ksfm_o2(aa, L);  [aai, ell, rho] = ksfm_o2(aai, L);
    ttii = [tt(1):0.01:tt(end) tt(end)];  aa = interp1(tt,aa',ttii)'; tt = ttii;
    [aa, ss] = ksfm_so2(aa, L);  [aai, ssi] = ksfm_so2(aai, L);
    [x, uui] = ksfm2real(aai(1:30,1:5:end),L);
    
    fig1 = figure('PaperPosition',[1.0 1.0 19 8],'PaperOrient','port','PaperSize',[20.98 29.68],'Position',[300 640 720 300]);
    ax(1) = axes('Position',[0.07 0.12 0.10 0.79],'Parent',fig1);
    ax(2) = axes('Position',[0.18 0.12 0.10 0.79],'Parent',fig1);
    ax(3) = axes('Position',[0.35 0.12 0.30 0.78],'Parent',fig1);
    ax(4) = axes('Position',[0.70 0.12 0.30 0.78],'Parent',fig1);
    axes(ax(1));  cmap = jet;
     pcolor(x,tti(1:5:end),uui'); caxis([-3 3]); shading flat; hold on;
     plot(x([1 end])*ones(1,ne),[tend;tend]*(1:ne),'w-');
    %plot(mod([ph;ph]*(1:ne-1),L)-L/2,[(1:ne-1);(2:ne)]*tend,'w-');
     set(gca,'ticklength',0.7*get(gca,'ticklength'),'tickdir','out',...
       'ylim',[0 te],'ytick',20:20:te,'box','off');  xlabel('$x$','interp','latex'); ylabel('Time','interp','latex');
    axes(ax(2));  plotcol(ss.*L,tt,tt,cmap); axis([-L/2 L/2 0 te]); grid on;
      title([sprintf('%4d: $T=%7.3f$ ',ost(ist),tend) '$\Delta=' sprintf('%8.4f$',ph)],'interp','latex'); 
      set(gca,'yticklabel',[]); xlabel('$L\theta_1/(2\pi)$','interp','latex');
    axes(ax(3));  plot3col(aa(3,:),aa(4,:),aa(2,:),tt,cmap); grid on; axis image;
      xlabel('$\bar{b}_2$','interp','latex'); ylabel('$\bar{c}_2$','interp','latex'); zlabel('$\bar{c}_1$','interp','latex','rotat',0); 
    axes(ax(4));  plot3col(aa(5,:),aa(6,:),aa(2,:),tt,cmap); grid on; axis image;
      xlabel('$\bar{b}_3$','interp','latex'); ylabel('$\bar{c}_3$','interp','latex'); zlabel('$\bar{c}_1$','interp','latex','rotat',0); 
    pause;
    print(gcf,'-dpng',sprintf('ks22rpo%06.2f_%06.3f.png',tend,ph));
    print(gcf,'-depsc2',sprintf('ks22rpo%06.2f_%06.3f.eps',tend,ph));
    delete(fig1);
  end
  
%% Determining proximity of chaotic orbit to RPOs
  clear;  load kse22orbits;  h = 0.1;  N = 32;  nph = 120;
  if 1,  np = 2;  tpre = 100;  tsampl = 1000;
    a0 = zeros(N-2,1); randn('seed',12350001);  a0(1:10) = 0.2*randn(10,1);
    [tt, aa] = ksfmedt(L, tpre, a0, h, 0);  a0 = aa;
    [tt, aa] = ksfmedt(L, tsampl, a0, h, np);
  else load ks22prox04; end
  figure(1); clf; subplot(2,1,1); [x, uu] = ksfm2real(aa, L, 64);
  pcolor(tt,x,uu); caxis([-3 3]); shading flat; wide(1.2); pause;
  subplot(2,1,2); wide(1.2);
  va = aa(1:2:end,:) + 1i*aa(2:2:end,:);  na = size(aa,2);
  for ieq = 1:3,                      % Proximity to Equilibria
    arpo = eq(ieq).a;  vr = arpo(1:2:N-2) + 1i*arpo(2:2:N-2);
    for ib = 1:na,  phase = exp((-2i*pi/nph).*(1:N/2-1)'*(1:nph));
      dv = repmat(vr,1,nph).*phase - repmat(va(:,ib),1,nph);
      dd = sqrt(sum(real(dv).^2+imag(dv).^2));
      [mdd, idd] = min(dd);  prox(ieq,ib) = mdd;
      tprox(ieq,ib) = 0;  phprox(ieq,ib) = (idd/nph-0.5)*L;  end;
    plot(tt,prox(ieq,:),'.-'); hold all;
    disp([ieq]); pause; end
  for itw = 3:2, for irfl = -1:0,     % Proximity to Traveling Waves
    arpo = re(itw).a; if irfl == 0, arpo(1:2:end) = -arpo(1:2:end); end
    vr = arpo(1:2:N-2) + 1i*arpo(2:2:N-2);
    for ib = 1:na,  phase = exp((-2i*pi/nph).*(1:N/2-1)'*(1:nph));
      dv = repmat(vr,1,nph).*phase - repmat(va(:,ib),1,nph);
      dd = sqrt(sum(real(dv).^2+imag(dv).^2));  [mdd, idd] = min(dd);
      prox(2*itw+irfl+3,ib) = mdd;
      tprox(2*itw+irfl+3,ib) = 0;  
      phprox(2*itw+irfl+3,ib) = (idd/nph-0.5)*L;  end;
    plot(tt,prox(2*itw+irfl+3,:),'.-'); hold all;
    disp([itw irfl]); pause; end, end  
  for irpo = 71:70, for irfl = -1:0, tic;% Proximity to RPOs
    iprox = 2*irpo+irfl+7;  arpo = rpo(irpo).a;  
    proxTrpo(iprox) = rpo(irpo).T;
    proxDrpo(iprox) = rpo(irpo).d;
    if irfl == 0, arpo(1:2:end) = -arpo(1:2:end); 
      proxDrpo(iprox) = -proxDrpo(iprox); end
    [tr, ar] = ksfmedt(L, rpo(irpo).T, arpo, h, 1);  nr = size(ar,2);
    vr = ar(1:2:N-2,:) + 1i*ar(2:2:N-2,:);  dd = zeros(nph,nr);
    if irfl == -1, phase = exp((-2i*pi*rpo(irpo).d./L).*(1:N/2-1)');
    else phase = exp((2i*pi*rpo(irpo).d./L).*(1:N/2-1)'); end
    disp(sqrt(sum(abs(vr(:,end).*phase - vr(:,1)).^2)));
    for ib = 1:na,
      for iph = 1:nph,  phase = exp((-2i*pi/nph*iph).*(1:N/2-1)');
        dv = vr.*repmat(phase,1,nr) - repmat(va(:,ib),1,nr);
        dd(iph,:) = sqrt(sum(real(dv).^2+imag(dv).^2)); end
      [mdd, idd] = min(dd(:));  [idr,idc] = ind2sub(size(dd),idd);
      prox(iprox,ib) = dd(idr,idc);  tprox(iprox,ib) = tr(idc);     
      phprox(iprox,ib) = idr/nph*L;  end;
    plot(tt,prox(iprox,:),'.-'); hold all;
    disp([irpo irfl iprox proxTrpo(iprox) proxDrpo(iprox)]); 
    drawnow; toc; end, end

%% Determining proximity of RPOs to equilibria and each other
  clear;  load kse22orbits;  h = 0.1;  N = 32;  nph = 120;
  for ir1 = 2:2,
    [tr1, ar1] = ksfmedt(L, rpo(ir1).T, rpo(ir1).a, h, 1);
    figure(1); clf; subplot(2,1,1); [x, uu] = ksfm2real(ar1, L, 64);
    pcolor(tr1,x,uu); caxis([-3 3]); shading flat; wide(1.2);
    subplot(2,1,2); wide(1.2);
    vr1 = ar1(1:2:N-2,:) + 1i*ar1(2:2:N-2,:);  nr1 = size(ar1,2);
    disp(sqrt(sum(abs(vr1(:,end).*exp((-2i*pi*rpo(ir1).d./L).*(1:N/2-1)') - vr1(:,1)).^2)));
    pause;
    for ieq = 1:3, prox = [];             % Proximity to Equilibria
      aeq = eq(ieq).a;  veq = aeq(1:2:N-2) + 1i*aeq(2:2:N-2);
      for ib = 1:nr1,  phase = exp((-2i*pi/nph).*(1:N/2-1)'*(1:nph));
        dv = repmat(veq,1,nph).*phase - repmat(vr1(:,ib),1,nph);
        dd = sqrt(sum(real(dv).^2+imag(dv).^2)); [mdd, idd] = min(dd);
        prox(ib) = mdd;  phprox(ib) = (idd/nph-0.5)*L; end
      [mprox,iprox] = min(prox);
      plot(tr1,prox,'.-'); hold all; set(gca,'xlim',[0 rpo(ir1).T]);
      plot(tr1(iprox),mprox,'ko');
      disp([ieq mprox tr1(iprox) phprox(iprox)]); pause; end
    for itw = 1:2, for irfl = -1:0,     % Proximity to Traveling Waves
      atw = re(itw).a; if irfl == 0, atw(1:2:end) = -atw(1:2:end); end
      vtw = atw(1:2:N-2) + 1i*atw(2:2:N-2);  prox = [];
      for ib = 1:nr1,  phase = exp((-2i*pi/nph).*(1:N/2-1)'*(1:nph));
        dv = repmat(vtw,1,nph).*phase - repmat(vr1(:,ib),1,nph);
        dd = sqrt(sum(real(dv).^2+imag(dv).^2));  [mdd, idd] = min(dd);
      prox(ib) = mdd;  phprox(ib) = (idd/nph-0.5)*L;  end;
      [mprox,iprox] = min(prox);      
      plot(tr1,prox,'.-'); hold all; set(gca,'xlim',[0 rpo(ir1).T]);
      plot(tr1(iprox),mprox,'ko');
      disp([itw irfl mprox tr1(iprox) phprox(iprox)]); pause; end, end  
  end
%%  
  for irpo = 33:33, for irfl = -1:0, tic;% Proximity to RPOs
    iprox = 2*irpo+irfl+7;  arpo = rpo(irpo).a;  
    proxTrpo(iprox) = rpo(irpo).T;
    proxDrpo(iprox) = rpo(irpo).d;
    if irfl == 0, arpo(1:2:end) = -arpo(1:2:end); 
      proxDrpo(iprox) = -proxDrpo(iprox); end
    [tr, ar] = ksfmedt(L, rpo(irpo).T, arpo, h, 1);  nr = size(ar,2);
    vr = ar(1:2:N-2,:) + 1i*ar(2:2:N-2,:);  dd = zeros(nph,nr);
    for ib = 1:na,
      for iph = 1:nph,  phase = exp((-2i*pi/nph*iph).*(1:N/2-1)');
        dv = vr.*repmat(phase,1,nr) - repmat(va(:,ib),1,nr);
        dd(iph,:) = sqrt(sum(real(dv).^2+imag(dv).^2)); end
      [mdd, idd] = min(dd(:));  [idr,idc] = ind2sub(size(dd),idd);
      prox(iprox,ib) = dd(idr,idc);  tprox(iprox,ib) = tr(idc);     
      phprox(iprox,ib) = idr/nph*L;  end;
    plot(tt,prox(iprox,:),'.-'); hold all;
    disp([irpo irfl iprox proxTrpo(iprox) proxDrpo(iprox)]); 
    drawnow; toc; end, end

%% Determine stable manifold at the end of E2 -> E2 connections
  clear;  load kse22orbits;  tend = 150; 
  ere = real(eq(2).eig(1));  period = 2*pi/imag(eq(2).eig(1));
  v = gsorth([real(eq(2).evec(:,1)) imag(eq(2).evec(:,1)) real(eq(2).evec(:,4))]);
  figure(1); clf; set(gcf,'pos',[5 35 250 900]);
  for delta = (0:0.1:1.1*0).*ere*period,
    a0 = eq(2).a + 1e-4.*exp(delta).*v(:,2);
    [tt, aa] = ksfmedt(L, tend, a0, h, 2);
    vv = aa(1:2:end,:) + 1i*aa(2:2:end,:);
    vv = vv.*repmat(exp(-2i*pi/4.*(1:size(vv,1)))',1,size(vv,2));
    aa(1:2:end,:) = real(vv);  aa(2:2:end,:) = imag(vv);
    [xx, uu] = ksfm2real(aa, L, 64);
    pcolor(xx,tt,uu'); shading flat; 
    set(gca,'pos',[0.13  0.06  0.78  0.90]); pause;
  end,

%% Defining instantaneous phase of KS solution
  clear; L = 22;  N = 32;  h = 0.25;  np = 1;  tend = 100;  nm = 4;
  if 0, a0 = zeros(N-2,1); randn('seed',22000001);  a0(1:10) = 0.2*randn(10,1);
  elseif 0, load ks22utw2a;
  else load ks22f90h25; ipo = 4; a0 = rpo(ipo).a;  tend = rpo(ipo).T;
  end
  [t, aa] = ksfmedt(L, tend, a0, h, np);  
  [x, uu] = ksfm2real(aa, L);  va = aa(1:2:end,:) + 1i*aa(2:2:end,:);
  figure(1); clf;  pcolor(x,t,uu'); caxis([-3 3]); shading flat;
  figure(2); clf;  plot(t,aa(1:10,:),'.-');
  
  if 0, % Don't recall what I tried here
    k = 2i*pi*(1:N/2-1)'./L;  da = diff(aa')';
    ta = (aa(1:2:end,1:end-1) + 1i*aa(2:2:end,1:end-1)).*repmat(k,1,length(t)-1);
    tt = da;  tt(1:2:end,:) = real(ta);  tt(2:2:end,:) = imag(ta);
    na = sqrt(sum(aa(:,1:end-1).^2));
    nt = sqrt(sum(tt.^2));  tt = tt./repmat(nt,size(tt,1),1);
    pa = sum(da.*tt)./na.*L./2./pi;
    figure(3); clf;  plot(t(1:end-1),cumsum(pa),'.-'); grid on;
  end

  % Weighted phase 
  anga = angle(va);  danga = diff(anga');
  dap = find(danga > pi); dam = find(danga < -pi);
  danga = zeros(size(danga)); danga(dap) = -2*pi;  danga(dam) = 2*pi;
  plot(t(2:end),danga(:,1:nm),'.-');
  canga = cumsum(danga); anga(:,2:end) = anga(:,2:end) + canga';
  absa = abs(va); sanga = diag(1./(1:nm))*anga(1:nm,:);
  figure(3); clf; subplot(3,1,1); plot(t,sanga,'.-');
  subplot(3,1,2); plot(t,absa(1:nm,:).^2,'.-');
  shift = sum(absa(1:nm,:).^2.*sanga)./sum(absa(1:nm,:).^2);
  subplot(3,1,3); plot(t,shift,'.-');

%% Compute Lyapunov exponents of KS (using ksfmstp with Jacobian)  
  clear; L = 22; N = 32; h = 0.25; nlyap = 7;
  tpre = 50.0; titr = 50.0; nitr = 500;
  a = zeros(N-2,1);  randn('seed',22000009); a(1:10) = 0.2*randn(10,1);
  [t, a] = ksfmstp(a, L, h, tpre/h, 0);
  v = randn(N-2,nlyap); [v, s] = gsorth(v);
  figure(2); clf; lyap = zeros(nitr,nlyap);
  for ni = 1:nitr,
    [t, a, da] = ksfmstp(a, L, h, titr/h, 0);
    v = da*v;  [v, s] = gsorth(v);
    lyap(ni,:) = log(s')./titr;
    plot(ni,lyap(ni,:),'*'); hold on; drawnow;
  end
  
%% Compute Lyapunov exponents of KS (using ksfmlyap and GS)
  clear; N = 64; h = 0.1; nlyap = 20;
  for L = 22.0:0.1:22.0,
    tpre = 1000.0; titr = 1.0; nitr = 20000*25;
    a = zeros(N-2,1); randn('seed',22000020); a(1:10) = 0.2*randn(10,1);
    v = randn(N-2,nlyap); v = gsorth(v);
    [a, v] = ksfmlyap(a, v, L, h, tpre/h); v = gsorth(v);
    lyap = zeros(nitr,nlyap); tic;
    for ni = 1:nitr,
      [a, v] = ksfmlyap(a, v, L, h, titr/h); [v, s] = gsorth(v);
      lyap(ni,:) = log(s)./titr; end, toc; disp([ni lyap(ni,1:4)]);
    figure(2); clf; plot(1:nitr,lyap,'*');
    for ni = 1:nlyap, elyap(ni) = max(confint(lyap(:,ni))); end
    lyap = mean(lyap); disp(num2str(L)); disp(num2str([lyap; elyap]));
  %  load kslyaps;
  %  Ls = [Ls; L]; Ns = [Ns; N]; Lyaps = [Lyaps; lyap]; eLyaps = [eLyaps; elyap];
  %  save kslyaps Ls Ns Lyaps eLyaps; 
  end
  
%% Compute Lyapunov exponents of KS (using ksfmlyap and QR)
  clear; N = 32; h = 0.01; nlyap = N-2;
  for L = 22.0:0.1:22.0,
    tpre = 10.0; titr = h; nitr = 200000;
    a = zeros(N-2,1); randn('seed',22000021); a(1:10) = 0.2*randn(10,1);
    v = randn(N-2,nlyap); [Q,R] = qr(v);
    [a, v] = ksfmlyap(a, Q, L, h, tpre/h); [Q,R] = qr(v);
    lyap = zeros(nitr,nlyap); tic;
    for ni = 1:nitr,
      [a, v] = ksfmlyap(a, Q, L, h, titr/h); [Q, R] = qr(v);
      lyap(ni,:) = log(diag(abs(R)))./titr; end, toc; disp([ni lyap(ni,1:4)]);
    figure(2); clf; plot(1:nitr,lyap,'*');
    for ni = 1:nlyap, elyap(ni) = max(confint(lyap(:,ni))); end
    lyap = mean(lyap); disp(num2str(L)); disp(num2str([lyap; elyap]));
  %  load kslyaps;
  %  Ls = [Ls; L]; Ns = [Ns; N]; Lyaps = [Lyaps; lyap]; eLyaps = [eLyaps; elyap];
  %  save kslyaps Ls Ns Lyaps eLyaps; 
  end
  
%% Roots of equilibria lam*(1+lam^2) - 4*E
  figure(1); clf;
  for E = 0:.1:10,
    lam = roots([1 0 1 -4*E]);
    plot(E,[-real(lam(1))*2 imag(lam(1))],'o'); hold on;
  end

%% Convert ks22f90h25 to ASCII format
clear; load ks22f90h25;  rpo(mrpo) = [];  ppo(mppo) = [];
fid = fopen('ks22rpo20k.dat','w');
for ii = 1:length(rpo),
  fprintf(fid,'%20.15f%20.15f',rpo(ii).T,rpo(ii).s);
  for in = 1:30, fprintf(fid,'%25.16e',rpo(ii).a(in)); end
  for ie = 1:6, fprintf(fid,'%17.8e%17.8e',real(rpo(ii).e(ie)),imag(rpo(ii).e(ie))); end
  fprintf(fid,'\n'); end, fclose(fid);
fid = fopen('ks22ppo20k.dat','w');
for ii = 1:length(ppo),
  fprintf(fid,'%20.15f',ppo(ii).T);
  for in = 1:30, fprintf(fid,'%25.16e',ppo(ii).a(in)); end
  for ie = 1:6, fprintf(fid,'%17.8e%17.8e',real(ppo(ii).e(ie)),imag(ppo(ii).e(ie))); end
  fprintf(fid,'\n'); end, fclose(fid);

%% Extract from ks22f90h25 orbits with T < 100 (14-Jan-2010)
  clear; load ks22f90h25; 
  rpo(mrpo) = [];  ppo(mppo) = [];
  ipo = find([rpo.T] > 100);  rpo(ipo) = [];
  ipo = find([ppo.T] > 100);  ppo(ipo) = [];
  save ks22f90h25t100 L rpo ppo
  
%% Check calculation of theta and thetadot
  clear;  load ks22f90h25t100;  L = 22;  h = 0.1;  
  ipo = 101;  a0 = rpo(ipo).a1;  tend = rpo(ipo).T1;  ph = rpo(ipo).s1;
  [tt, aa] = ksfmetd2(a0, L, h, tend, 1);  fa = ksfm2(aa, L);
  va = aa(1:2:end,:) + 1i*aa(2:2:end,:);  
  theta1 = angle(va(1,:)); theta2 = angle(va(2,:)); theta3 = angle(va(3,:)); 
  thdot1 = (aa(1,:).*fa(2,:)-aa(2,:).*fa(1,:))./(aa(1,:).^2+aa(2,:).^2);
  thdot2 = (aa(3,:).*fa(4,:)-aa(4,:).*fa(3,:))./(aa(3,:).^2+aa(4,:).^2);
  thdot3 = (aa(5,:).*fa(6,:)-aa(6,:).*fa(5,:))./(aa(5,:).^2+aa(6,:).^2);
  figure(1); clf; plot(tt, [theta1; thdot1; theta2-theta3; thdot2-thdot3]','.-'); grid on;

%%  Explore different maps to M/O(2)
  clear;  load ks22f90h25t100;  L = 22;  h = 0.1;
  for ipo = 1:10,  
    a0 = rpo(ipo).a1;  tend = rpo(ipo).T1;  ph = rpo(ipo).s1;
  %  a0 = ppo(ipo).a1;  tend = ppo(ipo).T1;  ph = 0;
    [tt, aa] = ksfmetd2(a0, L, h, tend, 1);  [x, uu] = ksfm2real(aa, L);
    [as0, s0] = ksfm_o2(aa, L, 0);  [ar0, r0, ir0, rr0] = ksfm_r(aa, L, 0);  [x, us0] = ksfm2real(as0, L);
    [as1, s1] = ksfm_o2(aa, L, 1);  [ar1, r1, ir1, rr1] = ksfm_r(aa, L, 1);  [x, us1] = ksfm2real(as1, L);
    [as2, s2] = ksfm_o2(aa, L, 2);  [ar2, r2, ir2, rr2] = ksfm_r(aa, L, 2);  [x, us2] = ksfm2real(as2, L);
    
    figure(1); clf; hax = subplots(7,1,[0 0 0 0.03],[0.05 0.04 0.03 0.00]);
    axes(hax(1));  %plot(tt,aa(1:6,:),'.-'); 
      pcolor(tt,x,uu); caxis([-3 3]); shading flat;
      title(num2str([ipo tend ph])); set(gca,'xlim',[0 tend]); grid on;
    axes(hax(2));  plot(tt,[s0; r0]','.-'); hold on;
      plot(tt(ir0)+h.*rr0, zeros(size(ir0)), 'r*');
      set(gca,'xlim',[0 tend]); grid on;
    axes(hax(3));  %plot(tt,as0(1:6,:),'.-'); 
      pcolor(tt,x,us0); caxis([-3 3]); shading flat;
      set(gca,'xlim',[0 tend]); grid on;
    axes(hax(4));  plot(tt,[s1; r1]','.-'); set(gca,'xlim',[0 tend]); grid on;
    axes(hax(5));  %plot(tt,as1(1:6,:),'.-'); 
      pcolor(tt,x,us1); caxis([-3 3]); shading flat;
      set(gca,'xlim',[0 tend]); grid on;
    axes(hax(6));  plot(tt,[s2; r2]','.-'); set(gca,'xlim',[0 tend]); grid on;
    axes(hax(7));  %plot(tt,as2(1:6,:),'.-'); 
      pcolor(tt,x,us2); caxis([-3 3]); shading flat;
      set(gca,'xlim',[0 tend]); grid on;
    pause; end
  
%% Map KSE solutions to Poincare map in M/SO(2)
  clear; load ks22f90h25t100;  L = 22;  h = 0.1;
  figure(2); clf;
  for ipo = 1:100,  
    a0 = rpo(ipo).a1;  tend = rpo(ipo).T1;  ph = rpo(ipo).s1;
    %a0 = ppo(ipo).a1;  tend = ppo(ipo).T1;  ph = 0;
    [tt, aa] = ksfmetd2(a0, L, h, tend, 1);
%    [ar, r, ir, rr] = ksfm_r(aa, L);  tp = tt(ir) + h.*rr;  
%    ap = aa(:,ir) + (aa(:,ir+1)-aa(:,ir)).*repmat(rr,size(aa,1),1);
%    [ao, s, r] = ksfm_o2(ap, L);
%    plot3(ao(3,:),ao(4,:),ao(2,:),'k.'); grid on; hold on;
    [ar, r, irp, rrp, irm, rrm] = ksfm_rpm(aa, L);  
    tpp = tt(irp) + h.*rrp;  tpm = tt(irm) + h.*rrm;  
    app = aa(:,irp) + (aa(:,irp+1)-aa(:,irp)).*repmat(rrp,size(aa,1),1);
    apm = aa(:,irm) + (aa(:,irm+1)-aa(:,irm)).*repmat(rrm,size(aa,1),1);
    [aop, sp, rp] = ksfm_o2(app, L); [aom, sm, rm] = ksfm_o2(apm, L);
    subplot(1,2,1); plot3(aop(3,:),aop(4,:),aop(2,:),'k.',aom(3,:),aom(4,:),aom(2,:),'r.'); grid on; hold on;
    subplot(1,2,2); plot3(aop(5,:),aop(6,:),aop(2,:),'k.',aom(5,:),aom(6,:),aom(2,:),'r.'); grid on; hold on;

  end

%% Eqilibria and their eigenvectors in real space
  clear;  load kse22orbits;  k = 2;
  figure(1); clf; [x, u] = ksfm2real(eq(k).a, L); subplot(5,3,1); plot(x,u,'.-');
  [x, u] = ksfm2real(real(eq(k).evec(:,1)), L); subplot(5,3,2); plot(x,u,'.-'); title(num2str(eq(k).eig(1)));
  [x, u] = ksfm2real(imag(eq(k).evec(:,1)), L); subplot(5,3,3); plot(x,u,'.-'); title(num2str(eq(k).eig(1)));
  [x, u] = ksfm2real(real(eq(k).evec(:,3)), L); subplot(5,3,4); plot(x,u,'.-'); title(num2str(eq(k).eig(3)));
  [x, u] = ksfm2real(imag(eq(k).evec(:,3)), L); subplot(5,3,5); plot(x,u,'.-'); title(num2str(eq(k).eig(3)));
  [x, u] = ksfm2real(eq(k).evec(:,5), L);       subplot(5,3,6); plot(x,u,'.-'); title(num2str(eq(k).eig(5)));
  [x, u] = ksfm2real(real(eq(k).evec(:,6)), L); subplot(5,3,7); plot(x,u,'.-'); title(num2str(eq(k).eig(6)));
  [x, u] = ksfm2real(imag(eq(k).evec(:,6)), L); subplot(5,3,8); plot(x,u,'.-'); title(num2str(eq(k).eig(6)));
  [x, u] = ksfm2real(eq(k).evec(:,8), L);       subplot(5,3,9); plot(x,u,'.-'); title(num2str(eq(k).eig(8)));
  [x, u] = ksfm2real(eq(k).evec(:,9), L);       subplot(5,3,10);plot(x,u,'.-'); title(num2str(eq(k).eig(9)));
  [x, u] = ksfm2real(eq(k).evec(:,10), L);      subplot(5,3,11);plot(x,u,'.-'); title(num2str(eq(k).eig(10)));
  [x, u] = ksfm2real(eq(k).evec(:,11), L);      subplot(5,3,13);plot(x,u,'.-'); title(num2str(eq(k).eig(11)));
  [x, u] = ksfm2real(eq(k).evec(:,12), L);      subplot(5,3,14);plot(x,u,'.-'); title(num2str(eq(k).eig(12)));
  set(get(gcf,'child'),'xlim',[-L L]/2,'ygrid','on');
  
%% Map KSE solutions to Poincare map in the fundamental domain
  clear;  load kse22orbits;  k = 1;  p = 1;  h = 0.1;  tend = 75;
  ere = real(eq(k).eig(1));  period = 2*pi/imag(eq(k).eig(1));
    clear;  load kse22orbits;  irpo = [15 17 19 29 35 45 48 63]; av = [];
  tend = 150; rcol = ['b';'r';'k';'g';'c';'m';'y'];  figure(1); clf;
  ere = real(eq(2).eig(1));  period = 2*pi/imag(eq(2).eig(1));
  v = gsorth([real(eq(2).evec(:,1)) imag(eq(2).evec(:,1)) real(eq(2).evec(:,7))]);
  for delta = (0:0.05:1.05).*ere*period,
    a0 = eq(2).a + 1e-4.*exp(delta).*v(:,2);
    [tt, aa] = ksfmetd2(a0, L, h, tend, 2);  [aa, ss, rr] = ksfm_o2(aa, L); 
    av = [av; v'*aa]; end,
  plot3(av(1:3:end-8,:)',av(2:3:end-7,:)',av(3:3:end-6,:)','k-');
  hold on; grid on; axis equal; view(10,20);

%% Combine equilibria, relative equilibria, relative and pre-periodic orbits
  clear;  load kse22orbits;  Tmax = 100; 

%% Compute covariant Lyapunov vectors and Floquet eigenvectors for RPOs
  clear; load ks22f90h25t100; ipo = 2;
%  h = 0.2500821; [tt, at, da] = ksfmstp2(rpo(ipo).a, L, h, 82);
  h = 0.2500; at = zeros(30,83);
  ga = zeros(30,30,83); ra = ga;  randn('seed',22000022);
  ga(:,:,1) = randn(30); [ga(:,:,1),ra(:,:,1)] = qr(ga(:,:,1));
  for ii = 1:500,  at(:,1) = rpo(ipo).a;
  for ih = 1:82,
    [tt, at(:,ih+1), da] = ksfmstp2(at(:,ih), L, h, 1);
    ga(:,:,ih+1) = da*ga(:,:,ih);  ga(:,:,ih+1) = gsorth(ga(:,:,ih+1));
    %[ga(:,:,ih+1),ra(:,:,ih+1)] = qr(ga(:,:,ih+1));  
  end
  %figure(1); clf; %plot(1:82,at(1:5,:),'.-'); pause;
  plot(ii,squeeze(ga(1,1:20,1)),'.'); hold on; 
  ga(:,:,1) = ga(:,:,83); end
%  h = 0.25; [tt, at, da] = ksfmetd2(rpo(ipo).a, L, h, rpo(ipo).T);
%  [qa, ra] = qr(da);  [va, ea] = eig(da);
%  disp(norm(at(:,end)-rpo(ipo).a));
%  [gm, dgm] = ksfmms3([rpo(ipo).a;rpo(ipo).T;rpo(ipo).s],L,h);
%  disp(norm(gm));  

%% Compute covariant Lyapunov vectors for Ikeda map
  clear; load ../ik16ops15;
  x0 = [op(1).x(1); op(1).y(1)];  [x, J] = ikeda([1 .9 .4 6], x0, 1);
  [v, e] = eig(J);
  figure(1); clf; plot(x0(1) + [0 v(1,1)],x0(2) + [0 v(2,1)],'r-',x0(1) + [0 v(1,2)],x0(2) + [0 v(2,2)],'b-'); hold on; axis equal; 
  randn('seed',12340002);  gv = randn(2);  gv = gsorth(gv); pause;
  hp = plot(x0(1) + [0 gv(1,1)],x0(2) + [0 gv(2,1)],'m-',x0(1) + [0 gv(1,2)],x0(2) + [0 gv(2,2)],'c-');
%  for ii = 1:100,
%    gv = J*gv;  gv = gsorth(gv);
%    set(hp,'xdata',x0(1) + [0 gv(1,1)],x0(2) + [0 v(2,1)],'r-',x0(1) + [0 v(1,2)],x0(2) + [0 v(2,2)],'b-');
%  end

%%  Compute covariant Lyapunov vectors at a fixed point
  clear;  qrflg = 1;
  e = diag([0.1 2.0]);  v = [1 0; 0.6 0.8]';
  J = v*e*inv(v);
  randn('seed',12340001);  g = randn(2); 
  if qrflg, [g, R] = qr(g); else g = gsorth(g); end
  for ii = 1:20, disp(ii);  g = J*g;  
    if qrflg, [g, R] = qr(g); disp(R); else g = gsorth(g); end
    disp(g); pause;
  end
  iR = inv(R);
  if 1,
    u1 = g(:,1); u2 = g(:,2);
    for ii = 1:20,
      u1 = iR*u1; u1 = u1./norm(u1);
      u2 = iR*u2; u2 = u2./norm(u2);
      disp(ii); disp([u1 u2]); pause;
    end
  else
    C = [1 1; 0 1];
    for ii = 1:20,  C = iR*C; disp(ii); disp(C); pause;  end
    disp(''); disp(g*C);
  end

%% Computing RPO/PPO eigenvalues using periodic Schur TMB03WD routine (1-Jul-2010)
  clear; load ks22f90h25t100; h = 0.25;  global PFLG;  PFLG = 1;  mstp = 4;
  format short g;  
%  [f,df] = ksfmms3([rpo(ipo).a;rpo(ipo).T;rpo(ipo).s],L,h);  disp(' '); disp(norm(f));
  
  for ipo = 1:1,
    a0 = rpo(ipo).a;  tend = rpo(ipo).T;  ph = rpo(ipo).s;  na = length(a0);
    nt = floor(tend/h);  [tt, aa] = ksfmstp2(a0, L, h, nt, 1);
    ii = 1:mstp:nt-mstp;  np = length(ii);
    ai = aa(:,ii);  ai = [ai(:); tend; ph]; ip = 0:na:length(ai)-na;
    [g,dg] = ksfmms3(ai,L,h,mstp,np); disp([ipo norm(g)]);
    if 0, pdg = eye(na);
      for ia = ip,  pdg = dg(ia+(1:na),ia+(1:na))*pdg;  end
      peig = eig(pdg);  [rpo(ipo).e(1:16) peig(1:16)], end
% Prepare input file for SLICOT routine TMB03WD
    fid = fopen(sprintf('MB03WD_r%03d.dat',ipo),'w');
    fprintf(fid,sprintf('TMB03WD_1 input file for RPO %3d\n',ipo));
    fprintf(fid,'%3d %3d %3d %3d %3d %3d  S  V\n',na,np,1,na,1,na);
    for ia = fliplr(ip),  for ira = 1:na,
      fprintf(fid,'%25.16e ',dg(ia+ira,ia+(1:na))); fprintf(fid,'\n');
    end,  end,  fclose(fid);  end
  
%% Extract results from MB03WD_*
  clear; load ks22f90h25t100;
  for ipo = 2:2,
    res = load(sprintf('MB03WD_r%03d.res',ipo));
    if ~isempty(res),
      T = reshape(res(1:size(res,1)/2,:)', size(res,2), size(res,2), round(size(res,1)/2/size(res,2)));  T = permute(T, [2 1 3]);
     % Q = reshape(res(size(res,1)/2+1:end,:)', size(res,2), size(res,2), round(size(res,1)/2/size(res,2)));  Q = permute(Q, [2 1 3]);
     % Determine which sub-diagonal elements of T(:,:,1) are non-zero
      ic = find(diag(T(:,:,1),-1) ~= 0); % index for complex eigenvalues
      ir = (1:size(T,1))'; ir([ic; ic+1]) = []; % index for real eigenvalues
      lam = zeros(size(T,1),1);
      for ii = ic,
        
      end
      for ii = ir',
        lam(ii) = sum(log(abs(T(ii,ii,:))))./rpo(ipo).T;
      end
    end
  end
  
  
  
  