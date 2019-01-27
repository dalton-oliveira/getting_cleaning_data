#Code Book

* `tbl` - Train and Test observations
* `tblMean` - `tbl` measurement average by `subjectId` and `activityLabel `
## `tbl` Columns  
* `subjectId` - The participant ID
* `activityLabel` - Label of activity performed on observed measures: `WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING`
* `bodyAcc[XYZ]_[1:128]` - body accelerometer measuremets on 3-axial
* `bodyGyro[XYZ]_[1:128]` - gyroscope measurements on 3-axial
* `totalAcc[XYZ]_[1:128]` - body plus gravity acelerometer measurements on 3-axial

Column naming described in `activity_labels.txt` were modified to remove special characters like `(),-` and replaced the prefix `f` and `t` by `FrequencyDomain` and `TimeDomain`.

