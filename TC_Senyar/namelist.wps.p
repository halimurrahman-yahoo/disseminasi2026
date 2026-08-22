&share
 wrf_core = 'ARW',
 max_dom = 2,
 start_date       = '2025-11-20_00:00:00','2025-11-20_00:00:00',
 end_date         = '2025-12-01_23:00:00','2025-12-01_23:00:00',
 interval_seconds = 3600
 io_form_geogrid  = 2
 debug_level      = 0
/

&geogrid
 parent_id            = 1, 1
 parent_grid_ratio    = 1, 3 
 i_parent_start       = 1, 178
 j_parent_start       = 1, 147
 e_we                 = 1228 , 2593
 e_sn                 = 812, 1492
 geog_data_res = 'default','default',
 dx = 10000,
 dy = 10000,

 map_proj          = 'mercator'
 ref_lat           = -7.65
 ref_lon           = 108.85
 truelat1          = -7.65
 stand_lon         = 108.85
 geog_data_path = '/comsoftware/wrf/WPS-4.3/DATA/WPS_GEOG'
/

&ungrib
 out_format = 'WPS',
 prefix = 'ERA5_p',
/

&metgrid
 fg_name              = 'ERA5_p', 'ERA5_sfc',
 io_form_metgrid      = 2
/

