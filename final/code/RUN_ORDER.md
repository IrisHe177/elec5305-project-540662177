# Final experiment: run order

Set MATLAB's Current Folder to this `code` folder and run the Live Scripts in order (full instructions and data downloads are in the repository README).

| Step | Live Script | Needs |
|---|---|---|
| 0 | `check_environment` | nothing |
| 1 | `clean_tuned_eval` | progress-stage features (`features_ABC.mat`) |
| 2 | `yamnet_clean` | ESC-50 audio, Deep Learning Toolbox + YAMNet weights |
| 3 | `prepare_noise` | ESC-50 audio, DEMAND |
| 4 | `noise_robustness` | steps 1 (+2); DEMAND or the cached features in `../results/noise_features` |
| 5 | `multicondition` | steps 1, 4; DEMAND or the cache |
| 6 | `analysis` | steps 1, 3, 4 (+5) |

Each step writes a time-stamped folder in `../results/` and records it in `latest_<step>.mat`, which later steps read. `p3_config.m` finds the progress-stage data automatically, either in the repository root (GitHub layout: this folder is `final/code`) or in a sibling `Project_2` folder.

Helper functions (`.m`): `p3_config` (paths and settings), `extractHandcrafted` (features, identical to the progress stage), `mixAtSNR` (active-frame SNR mixing), `loadDemandNoise`, `nestedSvmEval` / `trainSvmFold` (nested SVM), `yamnetSetup` / `yamnetClipEmbedding`, `classMetrics`, `mcnemarExact`, `featureGroups` and small utilities.
