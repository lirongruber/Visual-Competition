# Visual-Competition

This is the repository for the paper:
 “Visual competition: similarities and differences between deep neural networks and humans”.
It contains the following:
1.	‘human experiment’ folder: codes and stimuli used in the human behavioral experiment 
  a.	Mixed images can be found in ‘img’ folder.
  b.	For a ‘dummy’ version of the experiment open index.html in any browser.
2.	‘results’ folder: csv output files of the human’s answers
  a.	‘personal’ – subjects’ details (condition, gender, etc.)
  b.	 ‘subject_answers’ – raw subjects’ text answers 
  c.	‘results_cond_#’ – encoded subjects’ answers (0=none, 1=chose first,2=chose second,3=chose both).
3.	‘analysis’ folder: Example codes for data generation and analysis. These codes demonstrate the major analysis we performed (pretrained models were downloaded from: https://github.com/BVLC/caffe/wiki/Model-Zoo, ImageNet dataset was downloaded from: http://image-net.org/download-images). 
  a.	‘morph_img_pair.m’-  code for mixing two images in different methods. 
  b.	‘extractNetworkChoice.m’ – used after running the images in the network. This code loads the network’s output and define the network choice (see text). This script uses three utils functions: ‘LoadNetResults.m’, ‘GetIndicesAccordingToNet.m’, ‘GetIndicesAccordingToExp.m’
  c.	‘CalcImageParameters.m’ – Calculates the image parameters used in the paper (see Table 1). 
  d.	‘RunGLMOnImageFeatures.m’ – Trains a generalized linear model to predict networks’/humans’ choices using different features combinations. 

For further details please contact: lironzgruber@weizmann.ac.il



