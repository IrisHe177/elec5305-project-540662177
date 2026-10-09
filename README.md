# Environmental Sound Classification Using Temporal and Spectral Audio Features

ELEC5305 – Acoustics, Speech and Signal Processing  
The University of Sydney  
Student ID: 540662177

## Project Overview

This project investigates how temporal and spectral audio features contribute to environmental sound classification in MATLAB.

The main goal is to evaluate whether simple, interpretable descriptors can distinguish sound categories and improve an MFCC-based baseline. Support vector machines (SVM) are used as the primary classifier, with k-nearest neighbours (kNN) as a reference.

This repository records the implementation, experimental results, and ongoing project development.

## Research Questions

- How well does an MFCC + zero-crossing rate baseline classify environmental sounds?
- How effective are simple temporal and spectral descriptors on their own?
- Does combining these descriptors with MFCCs improve classification?
- Which sound categories remain difficult to distinguish?

## Dataset

The experiments use ESC-10, the predefined 10-class subset of ESC-50.

- 400 audio clips: 40 clips per class.
- Each clip is 5 seconds long, mono, and sampled at 44.1 kHz.
- Classes: dog, rooster, rain, sea waves, crackling fire, crying baby, sneezing, clock tick, helicopter, and chainsaw.
- The official five folds are preserved.
- Each fold contains 80 test clips, with the remaining 320 used for training.
- Dataset preparation checks audio properties, class balance, and source separation between folds.

The original proposal considered selecting 5–8 classes. The implemented study uses the predefined ESC-10 subset to provide a balanced dataset and a reproducible evaluation protocol.

Dataset source: [ESC-50 repository](https://github.com/karolpiczak/ESC-50)

## Methodology

The processing pipeline is:

Audio validation → frame-based feature extraction → clip-level aggregation → training-fold standardization → classification → evaluation.

### Audio Processing

The current configuration uses:

- Sample rate: 44,100 Hz.
- Main analysis frame length: 2,048 samples, approximately 46.44 ms.
- Hop length: 512 samples, approximately 11.61 ms.
- Periodic Hann window for MFCC and spectral analysis.
- FFT length: 2,048 samples.
- Reflection padding for centred main analysis frames.
- RMS calculated from unwindowed frames.
- ZCR calculated from unwindowed 512-sample blocks, including the final partial block.
- Spectral rolloff threshold: 90%.

No resampling, silence trimming, denoising, pre-emphasis, or audio amplitude normalization is applied.

Preserving the original amplitude retains RMS differences between recordings. However, RMS can also be affected by recording gain and microphone distance, so it is not interpreted as calibrated sound-pressure level.

### Feature Configurations

Each frame-level feature is summarized using its mean and population standard deviation across the clip.

| Group | Features | Dimensions |
|---|---|---:|
| A: Baseline | 12 MFCCs + ZCR | 26 |
| B: Interpretable descriptors | RMS + ZCR + spectral centroid + spectral spread + spectral flatness + spectral rolloff | 12 |
| C: Combined | 12 MFCCs + ZCR + RMS + spectral centroid + spectral spread + spectral flatness + spectral rolloff | 36 |

The MFCC representation uses coefficients C1–C12, excluding C0. Delta coefficients are not included. ZCR is included only once in Group C.

### Classifiers

The initial comparison uses fixed settings across all three feature groups:

- SVM: Gaussian kernel, box constraint `C = 1`, `KernelScale = sqrt(26)`, and one-versus-one multiclass classification.
- kNN: `k = 5`, Euclidean distance, and equal neighbour weights.

No hyperparameter tuning is performed in the current comparison.

For every fold and feature group, standardization statistics are calculated using the training data only. The same training mean and standard deviation are then applied to the test data.

Any future hyperparameter selection will be performed within the training data, keeping the official test fold separate.

## Evaluation

All feature groups use the same official five folds. Each clip receives exactly one held-out prediction per classifier and feature group.

Reported metrics are:

- Accuracy over all 400 out-of-fold predictions.
- Macro precision, macro recall, and macro F1, calculated as unweighted averages over the ten classes using pooled out-of-fold predictions.
- Sample standard deviation of the five fold accuracies.
- Per-class metrics and confusion matrices.

Macro F1 is the average of class-level F1 scores, not the average of fold-level F1 scores. Fold accuracy standard deviation describes variation across folds; it is not a confidence interval.

## Experimental Records

The current implementation includes the baseline experiment, the three-group feature comparison, and consolidated evaluation tables.

- [Baseline results](baseline_results/run_20261009_025418_395/)
- [Feature comparison results](feature_comparison_results/run_20261009_031441_478/)
- [All evaluation metrics](feature_comparison_results/run_20261009_031441_478/step6_all_metrics.csv)
- [Per-fold results](feature_comparison_results/run_20261009_031441_478/fold_metrics.csv)
- [Out-of-fold predictions](feature_comparison_results/run_20261009_031441_478/oof_predictions.csv)

Confusion matrices:

- [Group A](feature_comparison_results/run_20261009_031441_478/A_SVM_confusion.png)
- [Group B](feature_comparison_results/run_20261009_031441_478/B_SVM_confusion.png)
- [Group C](feature_comparison_results/run_20261009_031441_478/C_SVM_confusion.png)

## Software Requirements

The scripts have been run using MATLAB R2024b with:

- Audio Toolbox.
- Signal Processing Toolbox.
- Statistics and Machine Learning Toolbox.

MATLAB's built-in audio feature functions are used where applicable.

## How to Run

1. Download or clone this repository.
2. Download ESC-50 from the dataset repository.
3. Place the extracted dataset in a folder named `ESC-50-master` at the project root. The following paths must exist:
   - `ESC-50-master/audio/`
   - `ESC-50-master/meta/esc50.csv`
4. Set MATLAB's Current Folder to the project root.
5. Run the Live Scripts in the following order.

| Order | Script | Purpose |
|---|---|---|
| 1 | `prepare_esc10.mlx` | Validate ESC-10 and save the official fold assignments |
| 2 | `configure_features.mlx` | Save the audio and feature configuration |
| 3 | `run_mfcc_zcr_baseline.mlx` | Extract baseline features and evaluate SVM and kNN |
| 4 | `run_feature_comparison.mlx` | Evaluate feature groups A, B, and C |
| 5 | `summarize_evaluation_results.mlx` | Produce the consolidated evaluation tables |
| 6 | `analyze_representative_sounds.mlx` | Generate feature distributions and example plots |

Run each script in full. If prompted, select the project root folder.

New classification runs create timestamped result folders. The `latest_baseline.mat` and `latest_comparison.mat` files identify the runs used by subsequent scripts.

The full audio dataset is not included in this repository. Running the complete pipeline regenerates the preparation files, features, models, and results.

## Repository Contents

| Location | Contents |
|---|---|
| Root `.mlx` files | Main experiment scripts |
| `feature_config.mat` | Saved feature configuration |
| `ESC10_prepared/` | Dataset manifest, class mapping, and official fold assignments |
| `baseline_results/` | Baseline features, models, predictions, metrics, and figures |
| `feature_comparison_results/` | Feature comparison results, evaluation summaries, and analysis outputs |
| `ELEC5305 Project Proposal.pdf` | Original project proposal |

The original proposal is retained as the initial project plan. This README describes the implemented study and its current progress.

## Project Status and Next Steps

Completed:

- [x] Project proposal and repository setup.
- [x] ESC-10 preparation and validation.
- [x] Reproducible feature configuration.
- [x] MFCC + ZCR baseline.
- [x] Initial comparison of three feature groups.
- [x] Official five-fold evaluation with training-only standardization.
- [x] Saved predictions, evaluation tables, and confusion matrices.

Planned:

- [ ] Extend the analysis of class-level errors and feature contributions.
- [ ] Assess further improvements using training-data-only model selection.
- [ ] Discuss limitations and consolidate the experimental findings.
- [ ] Complete the final report and project documentation.

## Project Proposal

[Read the original project proposal](ELEC5305%20Project%20Proposal.pdf)
