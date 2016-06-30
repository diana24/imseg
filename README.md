# Semantic Image Segmentation
This is part of a dissertation project entitled <i>Semantic Image Segmentation and Image Understanding</i>. The thesis is focused on research over most segmentation techniques, including human perception theory and a review of the latest approaches in segmentation, based on ontologies. In addition, two implementation have been developed - brain tumor detection and road detection. Both are unsupervised methods, use low-level features and histogram thresholding.
<br />
## Brain tumor detection
The algorithm aims to retrieve brain tumors from MRI scans. The method is adapted from [here](http://ijecscse.org/papers/apr2012/Brain-Tumour-Extraction-from-MRI-Images-Using-MATLAB.pdf), with additional information about Matlab implementation of morphological operations found in [this article](http://www.mecs-press.net/ijigsp/ijigsp-v4-n10/IJIGSP-V4-N10-5.pdf). 
<br />
The algorithm uses the assumption that the tumor area has the highest intensity in the image. It performs the following steps:
* convert the image to grayscale
* apply noise reduction filters:
 * gaussian low-pass filter to smooth the image
 * butterworth high-pass filter for sharpening
* apply median filter to remove salt-and-pepper noise resulted from previous step
* perform histogram thresholding with single threshold (tumor/non-tumor)
* perform morphological operations - actual tumor detection step:
  * create morphological, disk-shaped element
  * erode the image, to separate the tumor area
  * dilate the image, to smooth the edges

<br />
The result is displayed as an image in which the tumor and non-tumor areas are colored differently. Additionally, in the tumor detection step we added a parameter related to image resolution and tuned using a constant, to control the size of the detected morphological element (tumor), thus avoiding false positive detections.
<br />

| ![initial](/results/im7.png)   | ![final](/results/im8.png)    |
| ------------------------------ | ----------------------------- |



<br />
## Road detection
The implementation is based on an algorithm described in [this article](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.28.1325&rep=rep1&type=pdf), used by robot vehicles and automated driving systems. The idea is to segment an image in two areas: road and non-road, considering that road areas have lower saturation and intensity than the background. The steps are:
* convert the image to HSI color space, more similar to human vision
* build the bimodal histograms for all three chanels - H, S, I
* build a fourth, additional channel as the difference of normalized saturation and intensity
* extract the threshold from the new channel
* perform segmentation according to the threshold
<br />
Histogram of each channel is bimodal and similar to the following:<br/>
![bimodal hist](/results/hist.jpg)
<br />
Segmentation results: <br/>


| ![initial](/results/im5.jpg)   | ![final](/results/im6.jpg)    |
| ------------------------------ | ----------------------------- |

<br />
[Link to slides](https://drive.google.com/file/d/0B4H1TGx6R0MOa1dTd2ZRQUxuSU0/view?ths=true)
