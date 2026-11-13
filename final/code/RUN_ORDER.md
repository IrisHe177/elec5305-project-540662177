# Final experiment: run order

Set MATLAB's Current Folder to this `code` folder and run the Live Scripts in order (full instructions and data downloads are in the repository README).

| Step | Live Script | Needs |
|---|---|---|
| 0 | `s0_check_environment` | nothing |
| 1 | `s1_clean_tuned_eval` | progress-stage features (`features_ABC.mat`) |
| 2 | `s2_yamnet_clean` | ESC-50 audio, Deep Learning Toolbox + YAMNet weights |
| 3 | `s3_prepare_noise` | ESC-50 audio, DEMAND |
| 4 | `s4_noise_robustness` | S1 (+S2); DEMAND or the cached features in `../results/noise_features` |
| 5 | `s5_multicondition` | S1, S4; DEMAND or the cache |
| 6 | `s6_analysis` | S1, S3, S4 (+S5) |

Each step writes a time-stamped folder in `../results/` and records it in `latest_<step>.mat`, which later steps read. `p3_config.m` finds the progress-stage data automatically, either in the repository root (GitHub layout: this folder is `final/code`) or in a sibling `Project_2` folder.

Helper functions (`.m`): `p3_config` (paths and settings), `extractHandcrafted` (features, identical to the progress stage), `mixAtSNR` (active-frame SNR mixing), `loadDemandNoise`, `nestedSvmEval` / `trainSvmFold` (nested SVM), `yamnetSetup` / `yamnetClipEmbedding`, `classMetrics`, `mcnemarExact`, `featureGroups` and small utilities.
