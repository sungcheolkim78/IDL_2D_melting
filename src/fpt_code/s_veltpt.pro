pro s_veltpt, plus=plus, minus=minus

if keyword_set(plus) then begin
    veltpt,'tpt.t0v2v',y2max=70,ymax=50,color='blk7',dmax=9,psym=14
    veltpt,'tpt.t0v1500mv',y2max=70,ymax=50,color='blk7',dmax=9,psym=15, /overplot
    veltpt,'tpt.t0v1v+',y2max=70,ymax=50,color='blk7',dmax=9,psym=16, /overplot
    veltpt,'tpt.t0v500mv',y2max=70,ymax=50,color='blk7',dmax=9,psym=17, /overplot
endif

if keyword_set(minus) then begin
    veltpt,'tpt.t0v-2v',y2max=70,ymax=50,color='blk7',dmax=9,psym=14
    veltpt,'tpt.t0v-1500mv',y2max=70,ymax=50,color='blk7',dmax=9,psym=15, /overplot
    veltpt,'tpt.t0v-1v',y2max=70,ymax=50,color='blk7',dmax=9,psym=16, /overplot
    veltpt,'tpt.t0v-500mv',y2max=70,ymax=50,color='blk7',dmax=9,psym=17, /overplot
endif

end
