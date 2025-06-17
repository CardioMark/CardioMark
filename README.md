# CardioMark: Open-Source MATLAB Toolbox for ECG Annotation in Machine Learning and Research

## Authors
**Samir Abdel-Rahman** <sup>a, b, *</sup>  
**Pavel Antiperovitch** <sup>c</sup>  
**Anthony Tang** <sup>c</sup>  
**Vijay Parsa** <sup>a</sup>  
**James C. Lacefield** <sup>a, b, d</sup>  

### Affiliations
- <sup>a</sup> **Department of Electrical & Computer Engineering**, Western University, London, ON, Canada  
- <sup>b</sup> **Robarts Research Institute**, Western University, London, ON, Canada  
- <sup>c</sup> **Department of Medicine**, Schulich School of Medicine & Dentistry, Western University, London, ON, Canada  
- <sup>d</sup> **Department of Medical Biophysics**, Western University, London, ON, Canada  

### Corresponding Author
**Name**: Samir Abdel-Rahman  
**Phone**: 519-661-2111 ext. 84303  
**Fax**: 519-850-2436  

## Abstract
As machine learning, particularly deep learning, gains traction in ECG analysis, access to well-annotated databases has become increasingly critical. However, many publicly available ECG datasets lack detailed QRS morphology labels or comprehensive 12-lead recordings. Manual annotation, while necessary, is time-consuming, subjective, and often requires multiple reviewers. **CardioMark** streamlines the annotation process with an intuitive MATLAB toolbox designed for multi-observer input, session-based work, and seamless export for machine learning applications. Its modular structure enables customization for a variety of ECG-related tasks, making it an invaluable resource for both academic research and clinical cardiology education.

## Requirements
This software requires only a basic **MATLAB** with **Signal Processing Toolbox**.

## Installation
The software can be run by adding its folder to the MATLAB search path and opening **“CardioMark.mlapp”** or by installing the **“CardioMark.mlappinstall”** file; then the software can be found in the APPS menu in MATLAB. MATLAB’s Signal Processing Toolbox is required, but it can be easily replaced with a few custom-made functions.

## Documentation
The **CardioMark Documentation** file, located in the `documentation` folder, contains details on folder organization and a quick start guide.

## Reference
For further information, please refer to the following article:  
S. Abdel-Rahman, P. Antiperovitch, A. Tang, M.I. Daoud, V. Parsa, J.C. Lacefield, Faster R-CNN approach for estimating global QRS duration in electrocardiograms with a limited quantity of annotated data, Comput. Biol. Med. 192 (2025) 110200. [DOI: 10.1016/j.compbiomed.2025.110200](https://doi.org/10.1016/j.compbiomed.2025.110200)
