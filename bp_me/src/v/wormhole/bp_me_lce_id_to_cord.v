

/* TODO: Should be replaced by a lookup table.  Programmable? */
module bp_me_lce_id_to_cord
 import bp_common_pkg::*;
 import bp_common_aviary_pkg::*;
 #(parameter bp_params_e bp_params_p = e_bp_inv_cfg
   `declare_bp_proc_params(bp_params_p)

   )
  (input [lce_id_width_p-1:0]                lce_id_i
   , output logic [coh_noc_cord_width_p-1:0] lce_cord_o
   , output logic [coh_noc_cid_width_p-1:0]  lce_cid_o
   );


  localparam io_rows_lp  = `BSG_CDIV(num_io_p, cc_x_dim_p);
  localparam sac_cols_lp = `BSG_CDIV(num_sacc_p, cc_y_dim_p);

  localparam max_cc_lce_lp  = num_core_p*2;
  localparam max_cac_lce_lp = max_cc_lce_lp + num_cacc_p;
  localparam max_mc_lce_lp  = max_cac_lce_lp + num_l2e_p;
  localparam max_sac_lce_lp = max_mc_lce_lp + num_sacc_p;
  localparam max_ioc_lce_lp = max_sac_lce_lp + num_io_p;

  // TODO: We only support 1 additional column / row for non-core-complex accelerators
  always_comb
    if (lce_id_i < max_cc_lce_lp)
      begin
        lce_cord_o[0+:coh_noc_x_cord_width_p]                      = sac_cols_lp + (lce_id_i>>1'b1 % cc_x_dim_p);
        lce_cord_o[coh_noc_x_cord_width_p+:coh_noc_y_cord_width_p] = io_rows_lp  + (lce_id_i>>1'b1 / cc_x_dim_p);
        lce_cid_o                                                  = lce_id_i[0];
      end
    else if (lce_id_i < max_cac_lce_lp)
      begin
        lce_cord_o[0+:coh_noc_x_cord_width_p]                      = sac_cols_lp + cc_x_dim_p + 1'b1;
        lce_cord_o[coh_noc_x_cord_width_p+:coh_noc_y_cord_width_p] = io_rows_lp  + (lce_id_i % cc_x_dim_p);
        lce_cid_o                                                  = '0;
      end
    else if (lce_id_i < max_mc_lce_lp)
      begin
        lce_cord_o[0+:coh_noc_x_cord_width_p]                      = sac_cols_lp + (lce_id_i % cc_x_dim_p);
        lce_cord_o[coh_noc_x_cord_width_p+:coh_noc_y_cord_width_p] = io_rows_lp + cc_y_dim_p + 1'b1;
        lce_cid_o                                                  = '0;
      end
    else
      begin
        lce_cord_o[0+:coh_noc_x_cord_width_p]                      = sac_cols_lp + (lce_id_i % cc_x_dim_p);
        lce_cord_o[coh_noc_x_cord_width_p+:coh_noc_y_cord_width_p] = '0;
        lce_cid_o                                                  = '0;
      end

endmodule

