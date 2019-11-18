pro s_fpt, plus=plus, minus=minus

if keyword_set(plus) then begin
    fpt, 'tpt.t0v2v', [5./2.*3.75,3.75], psym=14, dmax=8., velo=2.
    fpt, 'tpt.t0v1500mv', [5./2.*3.75, 3.75], psym=15, /overplot, dmax=8., velo=2.
    fpt, 'tpt.t0v1v+', [5./2.*3.75, 3.75], psym=16, /overplot, dmax=8., velo=2.
    fpt, 'tpt.t0v500mv', [5./2.*3.75, 3.75], psym=17, /overplot, dmax=8., velo=2.
endif

if keyword_set(minus) then begin
    fpt, 'tpt.t0v-2v', [5./2.*3.75,3.75], psym=14, dmax=8., velo=2.
    fpt, 'tpt.t0v-1500mv', [5./2.*3.75, 3.75], psym=15, /overplot, dmax=8., velo=2.
    fpt, 'tpt.t0v-1v', [5./2.*3.75, 3.75], psym=16, /overplot, dmax=8., velo=2.
    fpt, 'tpt.t0v-500mv', [5./2.*3.75, 3.75], psym=17, /overplot, dmax=8., velo=2.
endif

end
