clear all
clc

a0=[1.081769255879405645e-01 0.000000000000000000e+00  -1.130645021532460798e-01 2.735234400271993951e-02  -2.300369007695817619e-02  2.743365567776075153e-02 4.242109469805525057e-01  -3.221375201839944691e-02  3.517350195620121411e-01 4.196323928512094570e-01  7.405822221667555938e-02  -4.911698645198029345e-01 -2.619084037151255262e-01  8.869647954573157966e-03  2.667068425090810685e-02 -1.245857190912121742e-01  1.848625450932936676e-01  -1.886910780372257068e-01 -4.364329592632312099e-02  -8.603322827952401136e-03  -4.893648586116418342e-02 -4.227361593906937137e-02  -5.743046880645331920e-02  6.141174799787345318e-02  3.556320072237982056e-03  -2.647610106987533310e-02  -3.295731184608969265e-03  -1.760410218329051119e-02  -1.449156681256755577e-02  1.551927466950007474e-02];
a0=a0';
rpo = [3.70955584e-01   1.59178104e-16  -5.35414753e-01   6.72233738e-01 ...
  -1.60102241e-01   2.77492997e-01   2.26119482e-01   9.20202541e-02 ...
   1.01234154e-01  -7.61348435e-02   2.86999279e-03  -5.71633872e-02 ...
  -2.19911067e-02  -8.45432215e-03  -9.70953085e-03   5.74786687e-03 ...
   4.19544211e-04   4.07227658e-03   1.61695688e-03   7.51275352e-04 ...
   5.51797781e-04  -3.99001588e-04  -2.26058837e-05  -2.53441206e-04 ...
  -9.51845395e-05  -3.49971067e-05  -2.92711613e-05   2.18049965e-05 ...
   5.41318900e-07   1.12892181e-05]';
a0 = rpo;
[tt,aa]=ksfmstp2(a0, 22, 0.1, 328*2, 1);
aatrans = aa';
ta = [tt' aatrans];
save('data/sspsolution.dat', 'ta')
