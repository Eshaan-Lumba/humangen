# humangen

A Machine Learning project that creates a real life image from a drawing.

## App Design

Frontend: Flutter
Backend: Python

## Project Overview
The project uses the state of the art [pix2pix](https://arxiv.org/abs/1611.07004) machine learning algorithm. The algorithm takes in a drawing of a face, and outputs a predicted image of what a person in real life would look like based on the drawing. The algorithm learned using face images from [this website](https://generated.photos/). 

##Details
The same pix2pix algorithm was used, except with a different training dataset. The model is given an example drawing (based on a real life photo) and the original photo itself. It is then tasked to predict, from the drawing, what the face would look like. This prediction is compared to the original photo, and the cycle continues till the program learns better and stronger. For this project, the algorithm went through 150 EPOCHS and trained on a set of photos from the given link. The photos are mostly front-facing face views in a white background. Hence, when drawing, the drawer should only draw the face. Remarkably, it results in extremely accurate real-life depictions. 

## Backend 


## Practical Applications
One use of this program could be for the Police Department. Criminals could be better identified from the drawings and sketches that witnesses can produce. 


