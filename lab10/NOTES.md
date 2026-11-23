
## Part 5 — Image Sources

All three image sources use the same classification method.
Images are decoded, resized, normalized and processed
using the TensorFlow Lite model.

### Evaluation

| Source | Expected | Predicted | Confidence | Correct? |
|---|---|---|---|---|
| Camera | Pen | | | |
| Gallery | Pen | | | |
| Download | Pen | | | |
| Camera | Keyboard | | | |
| Gallery | Keyboard | | | |
| Download | Keyboard | | | |
| Camera | Mouse | | | |
| Gallery | Mouse | | | |
| Download | Mouse | | | |
| Camera | Notebook | | | |
| Gallery | Notebook | | | |
| Download | Notebook | | | |
| Camera | Face | | | |
| Gallery | Face | | | |
| Download | Face | | | |
| Camera | Empty hand | | | |
| Gallery | Empty hand | | | |
| Download | Empty hand | | | |

Overall accuracy: ___ / 18 = ___%

Weakest class: ___

### Part 5 Questions

1. Camera and downloaded pictures can receive different
scores because of differences in lighting, background,
viewing angle and object size compared with the training
samples.

2. Classification time: ___ ms, measured using Stopwatch.
The app shows a processing indicator while the image is
being obtained and classified. Since inference runs on the
UI thread, the indicator may briefly freeze.

### Implementation

Camera, gallery and URL images are handled by
lib/services/image_sources.dart.

All image bytes are sent to Classifier.classify() in
lib/services/classifier.dart through one shared method
in lib/main.dart.

Results are displayed in result_screen.dart and stored
in the current session's history.
