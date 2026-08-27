# elec5305-project-540662177
Environmental sound classification using temporal and spectral audio features with kNN and SVM in MATLAB.
# Environmental Sound Classification Using Temporal and Spectral Audio Features

## Project Overview

This project develops an environmental sound classification system using temporal and spectral audio features in MATLAB.

Environmental audio recordings will be processed to extract representative features such as RMS energy, zero-crossing rate (ZCR), spectral centroid, spectral spread, spectral flatness, and spectral rolloff. These features will then be used to train conventional machine-learning classifiers, including k-nearest neighbours (kNN) and support vector machines (SVM).

The project will investigate how different groups of audio features affect environmental sound classification performance.

## Objectives

The main objectives of this project are to:

- Extract temporal and spectral features from environmental audio signals.
- Compare the classification performance of temporal features, spectral features, and their combination.
- Compare kNN and SVM classifiers.
- Evaluate classification performance using accuracy, precision, recall, F1-score, and confusion matrices.

## Methodology

The proposed processing pipeline is:

Audio Dataset  
→ Pre-processing  
→ Short-Time Framing and Windowing  
→ Temporal and Spectral Feature Extraction  
→ Feature Normalisation  
→ kNN / SVM Classification  
→ Performance Evaluation

The main audio features considered are:

- RMS Energy
- Zero-Crossing Rate (ZCR)
- Spectral Centroid
- Spectral Spread
- Spectral Flatness
- Spectral Rolloff

## Dataset

The project plans to use a selected subset of the ESC-50 Environmental Sound Classification dataset.

Approximately 5–8 representative environmental sound classes will initially be selected to maintain a manageable and balanced project scope.

## Tools

- MATLAB
- Signal Processing Toolbox
- Statistics and Machine Learning Toolbox
- GitHub for project documentation and version control

## Evaluation

Classification performance will be evaluated using:

- Accuracy
- Precision
- Recall
- F1-score
- Confusion Matrix

Three feature configurations will be compared:

1. Temporal features only
2. Spectral features only
3. Combined temporal and spectral features

## Project Proposal

The full ELEC5305 Project Proposal will be available in this repository.

## Current Status

- [x] Project topic selected
- [x] GitHub repository created
- [ ] Project proposal uploaded
- [ ] ESC-50 dataset prepared
- [ ] Feature extraction implemented
- [ ] Classifiers implemented
- [ ] Experimental evaluation completed
- [ ] Final report completed

## Course

**ELEC5305 – Acoustics, Speech and Signal Processing**  
The University of Sydney
