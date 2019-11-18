pro s_vel

tpt = read_gdf('tpt.t0v-2v')
r = i_veldist(tpt,color='blk7',bs=1.5)
tpt = read_gdf('tpt.t0v-1500mv')
r = i_veldist(tpt,color='blu7',bs=1.5,/overplot)
tpt = read_gdf('tpt.t0v-1v')
r = i_veldist(tpt,color='grn7',bs=1.5,/overplot)
tpt = read_gdf('tpt.t0v-500mv')
r = i_veldist(tpt,color='red7',bs=1.5,/overplot)

end
