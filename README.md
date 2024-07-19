1.⁠ ⁠Input image is passed through a CNN to extract features from the image.

2.⁠ ⁠The features are then passed through a series of fully connected layers, which predict ‌class probabilities and bounding box coordinates.

3.⁠ ⁠The image is divided into a grid of cells, and each cell is responsible for predicting a set of bounding boxes and class probabilities.

4.⁠ ⁠The output of the network is a set of bounding boxes and class probabilities for each cell.

5.⁠ ⁠The bounding boxes are then filtered using a post-processing algorithm called non-max suppression to remove overlapping boxes and choose the box with the highest probability.

6.⁠ ⁠The final output is a set of predicted bounding boxes and class labels for each object in the image.
YOLO divides the input image into a grid, typically 7x7 or 9x9.
For each grid cell, YOLO predicts bounding boxes (x, y, w, h, confidence) representing the object's position, size, and confidence level.
Alongside bounding boxes, YOLO predicts class probabilities for each object within the box using a softmax function.
YOLO applies non-max suppression to refine the bounding boxes and remove duplicate detections.
The final output of YOLO consists of bounding boxes, their associated class labels, and confidence scores, achieved in a single forward pass of the network, making it suitable for real-time applications.
