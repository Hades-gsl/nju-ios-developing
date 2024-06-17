# 项目文档

## 1、设计思路

目录结构：

```
├── Calcudoku Collection App
│   ├── Calcudoku Collection App
│   └── Calcudoku Collection App.xcodeproj
├── README.md
├── document.md
└── scrape
    ├── Scrape.xcframework
    ├── go.mod
    ├── go.sum
    └── main.go
```

项目可分为两部分：

### UI部分：

Calcudoku Collection App 文件夹部分
- 使用 Tab Bar Controller 构建了4个tab选项(4x4，5x5，6x6，About)，其中4x4，5x5，6x6为对应聪明格题型的入口，About则为app介绍页面。
- 每个 tab 界面，通过 Navigation Controller 管理，使用2个 tableview controller 进行分级。
- PDF展示则利用 WKWebView 进行简单展示，位于最后一级。

### 爬虫部分

scrape 文件夹部分，该部分使用 `Golang` 实现，基于 `colly` 进行爬虫，之后通过 `gomobile` 将其编译为可直接供 `swift` 调用的 library 。

## 2、演示视频

https://www.bilibili.com/video/BV1oa4y1S7ek

## 3、问题

- 加载PDF较慢，需要等待几秒。
- 网站不允许爬虫，频繁爬取可能会导致被封禁（封禁时间24小时）。
