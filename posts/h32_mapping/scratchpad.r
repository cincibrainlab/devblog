mea_to_hs_map = c(
  "E1"   = 29,
  "E2"   = 27,
  "E3"   = 25,
  "E4"   = 23,
  "E5"   = 21,
  "E6"   = 19,
  "E7"   = 17,
  "E8"   = 30,
  "E9"   = 28,
  "E10"  = 26,
  "E11"  = 24,
  "E12"  = 22,
  "E13"  = 20,
  "E14"  = 18,
  "E15"  = 16,
  "E16"  = 14,
  "E17"  = 12,
  "E18"  = 10,
  "E19"  = 8,
  "E20"  = 6,
  "E21"  = 4,
  "E22"  = 2,
  "E23"  = 0,
  "E24"  = 15,
  "E25"  = 13,
  "E26"  = 11,
  "E27"  = 9,
  "E28"  = 7,
  "E29"  = 5,
  "E30"  = 3
) 

# convert this to a dataframe
mea_to_hs_map_df = data.frame(mea_to_hs_map) %>% 
  rownames_to_column(var = "mea") %>% 
  rename(hs_idx = mea_to_hs_map) %>%
  as_tibble()  %>% 
  mutate(headset = paste0("pri_", hs_idx))
mea_to_hs_map_df

mea_map <- "https://raw.githubusercontent.com/cincibrainlab/vhtp/main/chanfiles/NeuroNexusMouseEEGv2H32_Map.csv"
# 
# [1] "chan_name"      "chan_type"      "ntv_chan_idx"   "ntv_chan_name"  "sys_chan_idx"   "site_shape"     "port"           "absolute_idx"  
# [9] "scs_to_tcs_y"   "site_lim_x_min" "site_lim_z_max" "site_ctr_y"     "headstage_id"   "site_ctr_z"     "site_ctr_x"     "site_ctr_tcs_x"
# [17] "site_lim_x_max" "probe_id"       "site_ctr_tcs_y" "site_num"       "sensor_units"   "scs_to_tcs_z"   "is_audio"       "is_audio_left" 
# [25] "is_audio_right" "is_selected"    "site_lim_y_min" "site_lim_y_max" "scs_to_tcs_x"   "site_lim_z_min" "dsrc_uid"       "sensor_uid"    
# [33] "site_ctr_tcs_z" "color_grp_idx" 

data <- read_csv(mea_map)

full_table <- data %>% 
    left_join(mea_to_hs_map_df, by=c("chan_name" = "headset"))  %>% 
    relocate(mea, .after = chan_name)   %>% 
    mutate(chan_pos = str_replace(chan_name, "pri_", "E")) 


    # Two steps. The pri_ represents the final channels, 
    # but also initially the amplifer channels in order. 

    # So the first important table is just the chan name with 
    # the pri_ columns for matching with the amplifer. In this
    # case, there are two missing channels with the 30-lead 
    # murine probe as pri_1 (index 2) and pri_31 (index 32).

mea_to_amplifer <- full_table  %>% select(chan_name, mea)

write_csv(mea_to_amplifer, "mea_to_amplifer.csv")

# in the next step we have to rename the current channel with their 
# appropriate position pri_ channel names with the two missing channels removed. 

# this is the final table that will be used for the mapping. 
# in this case the 
