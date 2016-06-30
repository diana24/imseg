# Semantic Image Segmentation
This is part of a dissertation project entitled <i>Semantic Image Segmentation and Image Understanding</i>. The thesis is focused on research over most segmentation techniques, including human perception theory and a review of the latest approaches in segmentation, based on ontologies. In addition, two implementation have been developed - brain tumor detection and road detection. Both are unsupervised methods, use low-level features and histogram thresholding.
<br />
## Brain tumor detection
The algorithm aims to retrieve brain tumors from MRI scans. The method is adapted from [here](http://ijecscse.org/papers/apr2012/Brain-Tumour-Extraction-from-MRI-Images-Using-MATLAB.pdf), with additional information about Matlab implementation of morphological operations found in [this article](http://www.mecs-press.net/ijigsp/ijigsp-v4-n10/IJIGSP-V4-N10-5.pdf). 
<br />
The algorithm uses the assumption that the tumor area has the highest intensity in the image. It performs the following steps:
* convert the image to grayscale
* apply a noise reduction filter
* apply a gaussian low-pass filter to smooth the image
* apply a butterworth high-pass filter for sharpening
* apply median filter to remove salt-and-pepper noise resulted from previous step
* perform histogram thresholding with single threshold (tumor/non-tumor)
* perform morphological operations - actual tumor detection step:
  * create morphological, disk-shaped element
  * erode the image, to separate the tumor area
  * dilate the image, to smooth the edges

<br />
The result is displayed as an image in which the tumor and non-tumor areas are colored differently. Additionally, in the tumor detection step we added a parameter related to image resolution and tuned using a constant, to control the size of the detected morphological element (tumor), thus avoiding false positive detections.
<br />
![initial](/results/im7.png)![final](/results/im8.png)
<br />
## Road detection
<br />
[Link to slides](https://drive.google.com/file/d/0B4H1TGx6R0MOa1dTd2ZRQUxuSU0/view?ths=true)
