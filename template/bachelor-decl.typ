// 导入 preview 中的固定版本 modern-cqut-thesis:0.1.0 进行编译
// #import "@preview/modern-cqut-thesis:0.1.0": documentclass, indent

// 这个是从 lib.typ 导入并编译, 如果你要修改这个模板格式并编译请务必注释上方 @preview... 一行, 并导入下方 lib.typ进行编译
#import "../lib.typ": *

#let (
  // 布局函数
  twoside, doc, preface-counter, mainmatter, mainmatter-end, appendix,
  // 页面函数
  fonts-display-page, cover, decl-page, abstract, abstract-en, bilingual-bibliography,
  outline-page, list-of-figures, list-of-tables, notation, acknowledgement,
) = documentclass(
  doctype: "bachelor",
  twoside: true,  // 双面模式，会加入空白页，便于打印
  nl-cover: false,  // 不使用国家图书馆封面
  de-cover: true,
  info: (
    title: ("化工过程模拟课程总结", ""),
    title-en: "Chemical Process Simulation Course Summary: Chongqing University of Technology Course Design Thesis",
    grade: "2022",
    student-id: "12115990136",
    author: "刘抗非",
    author-en: "Liu Kangfei",
    department: "化学化工学院",
    department-en: "School of Chemistry and Chemical Engineering",
    major: "化学工程与工艺",
    major-en: "Chemical Engineering and Technology",
    supervisor: ("杨鑫", "教授"),
    supervisor-en: "Professor Yang Xin",
    submit-date: datetime.today(),
  ),
  bibliography: bibliography.with("化工过程模拟.bib"),
)

// 文稿设置
#show: doc

// // 一个别的引用样式，打印时应该注释掉
// #show cite: custom-cite

// // 封面页
// #cover()


// 如果上述封面不符
// 可用 #image 插入封面页矢量图并居中
// #align(center)[#image("covers/课程设计封面.svg", width: 210mm, height: 297mm)]


// // 字体展示测试页
// #fonts-display-page()


// 声明页
#decl-page()
