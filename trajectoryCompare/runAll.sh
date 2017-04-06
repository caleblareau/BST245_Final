packages:
  - chromVAR
  - motifmatchr
  - Matrix
  - SummarizedExperiment
  - ggplot2
  - cowplot
  - ggrepel
  - ggmotif
  - dplyr
  - Biostrings
  - Rcpp

sources:
  - R

include:
  - remake_sch.yml
  - remake_heme.yml
  - remake_supplementary.yml

targets:

  all:
    depends:
      - extra_figures/sch_sample_filtering.pdf
      - extra_figures/sch_variability.pdf
      - extra_figures/sch_7mer_variability.pdf
      - extra_figures/leuk_variability.pdf
      - extra_figures/leuk_7mer_variability.pdf
      - extra_figures/heme_variability.pdf
      - extra_figures/heme_7mer_variability.pdf
      - extra_figures/heme_clustering.pdf
      - extra_figures/heme_clustering2.pdf
      - extra_figures/heme_clustering3.pdf
      - extra_figures/heme_clustering4.pdf
      - extra_figures/heme_clustering5.pdf
      - extra_figures/tsne_inv.pdf
      - main_figures/figure1c.pdf
      - main_figures/figure1b.pdf
      - main_figures/figure2.pdf
      - main_figures/figure3.pdf
      - supplementary_figures/supplementary_heme_downsampling.pdf
      - supplementary_figures/supplementary_sch_variability.pdf
      - supplementary_figures/supplementary_aml.pdf
      - supplementary_figures/supplementary_synergy.pdf
      - supplementary_figures/supplementary_gata.pdf
      - supplementary_figures/supplementary_denovos.pdf
      - supplementary_figures/supplementary_denovos_dnase.pdf
      - supplementary_figures/supplementary_bias_skew.pdf
      - supplementary_figures/supplementary_iterations.pdf
      - supplementary_figures/supplementary_background_parameters.pdf
      - supplementary_figures/supplementary_background_example.pdf
      - supplementary_figures/supplementary_background_method.pdf
      - supplementary_figures/supplementary_denovos_dnase_footprint.pdf
      - extra_figures/kmer_example.png
      - k562_deviations

  extra_figures/kmer_example.png:
    command: gata_examples(sch_7mer_deviations)

  extra_figures/heme_clustering.pdf:
    command: clustering_comparison(cluster_scores, cluster_score_full, cluster_scores2, cluster_score2_full)
    plot:
      width: 2.5
      height: 2.5

  extra_figures/heme_clustering2.pdf:
    command: clustering_comparison2(cluster_scores, cluster_score_full, cluster_scores3, cluster_score3_full)
    plot:
      width: 2.5
      height: 2.5

  extra_figures/heme_clustering3.pdf:
    command: clustering_comparison(cluster_scores, cluster_score_full, cluster_scores4, cluster_score4_full)
    plot:
      width: 2.5
      height: 2.5

  extra_figures/heme_clustering4.pdf:
    command: clustering_comparison2(cluster_scores, cluster_score_full, cluster_scores5, cluster_score5_full)
    plot:
      width: 2.5
      height: 2.5

  extra_figures/heme_clustering5.pdf:
    command: clustering_comparison(cluster_scores, cluster_score_full, cluster_scores6, cluster_score6_full)
    plot:
      width: 2.5
      height: 2.5

  extra_figures/tsne_inv.pdf:
    command: tsne_inv_extra_plot(motif_tsne, sch_deviations,sch_variability_both, sch_7mer_deviations, sch_deviations_both)


  main_figures/figure1c.pdf:
    command: downsampling_tsne(heme_downsample_results)


  main_figures/figure1b.pdf:
    command: devcors_plot(devcors, heme_variability)



  main_figures/figure2.pdf:
    command: main_tsne_plot(sch_tsne, sch_tsne_no_bg,motif_tsne, sch_deviations,
                           sch_deviations_no_bg, sch_deviations_both,
                           sch_bb_deviations_no_bg, sch_bb_deviations, sch_variability,
                           sch_variability_both, sch_7mer_deviations,leuk_deviations, leuk_tsne)


  main_figures/figure3.pdf:
    command: kmer_plot(ktmd, sch_deviations, sch_denovo_deviations, kcov,
                        human_pwms_v1, kmer_motifs, sch_denovo_variability, sch_variability,
                        sch_7mer_deviations, sch_variability_both, motif_tsne)


