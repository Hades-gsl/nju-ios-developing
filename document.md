# 1、项目解释

使用CreateML训练一个简单的食物是否健康分类模型，之后将其引入到项目中，实现了对图片的简单分类。

# 2、代码解释

代码片段：

```swift
if let results = request.results as? [VNClassificationObservation] {
    if results.isEmpty {
        self.resultsLabel.text = "nothing found"
    } else if results[0].confidence < 0.1 {
        self.resultsLabel.text = "not sure"
    } else {
        self.resultsLabel.text = String(format: "%@ %.1f%%", results[0].identifier, results[0].confidence * 100)
    }
} else if let error = error {
    self.resultsLabel.text = "error: \(error.localizedDescription)"
} else {
    self.resultsLabel.text = "???"
}
```

该段代码用来获取图片分类的结果：

- 如果获取到结果，进行进一步判断
    - 如果结果为空，显示nothing found
    - 如果第一个结果（概率最高的结果）概率小于10%，显示not sure
    - 否则正常显示结果和概率
- 如果发生错误，显示错误
- 否则，显示 ???

# 3、演示视频

    https://www.bilibili.com/video/BV1t94y1E7bz
