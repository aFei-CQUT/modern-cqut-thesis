// layouts 部分
// Layouts section
#import "layouts/doc.typ": doc
#import "layouts/preface-counter.typ": preface-counter
#import "layouts/mainmatter.typ": mainmatter  // This includes the logic for page numbering


// pages 部分
// Pages section
#import "pages/fonts-display-page.typ": fonts-display-page
#import "pages/design-cover.typ": design-cover
#import "pages/bachelor-cover.typ": bachelor-cover
#import "pages/master-cover.typ": master-cover
#import "pages/bachelor-outline-page.typ": bachelor-outline-page
#import "pages/list-of-figures.typ": list-of-figures
#import "pages/list-of-tables.typ": list-of-tables
#import "pages/notation.typ": notation
#import "pages/bachelor-decl-page.typ": bachelor-decl-page
#import "pages/master-decl-page.typ": master-decl-page
#import "pages/bachelor-abstract.typ": bachelor-abstract
#import "pages/master-abstract.typ": master-abstract
#import "pages/bachelor-abstract-en.typ": bachelor-abstract-en
#import "pages/master-abstract-en.typ": master-abstract-en
#import "pages/bilingual-bibliography.typ": bilingual-bibliography
#import "pages/acknowledgement.typ": acknowledgement
#import "pages/appendix.typ": appendix


// utils 部分
/// 应通过闭包实现全局配置的文档类型主题部分的 utils 内部工具
/// 这部分与上述导入部分通过闭包实现了全局配置, 导入时可仅仅指定导入函数
/// 即可用 #import "@preview/modern-cqut-thesis:0.1.0": documentclass, indent
// utils section
#import "utils/anti-matter.typ": anti-inner-end as mainmatter-end
#import "utils/custom-cuti.typ": *
#import "utils/custom-numbering.typ": custom-numbering
#import "utils/custom-heading.typ": heading-display, active-heading, current-heading
#import "utils/indent.typ": indent, fake-par
#import "@preview/i-figured:0.2.4": show-figure, show-equation
#import "utils/style.typ": 字体, 字号


/// 这里未实现闭包, 所以如果要支持以下功能需要在主程序中导入全部
/// 即使用 #import "@preview/modern-cqut-thesis:0.1.0": *
/// Here, we don't implement closures, so you need to import all functions in the main program.
#import "utils/theorem.typ": *
#import "utils/chem-for.typ": ca, cb
#import "utils/cite-style.typ": custom-cite


// 使用函数闭包特性，通过 `documentclass` 函数类进行全局信息配置，然后暴露出拥有了全局配置的、具体的 `layouts` 和 `templates` 内部函数。
// Use function closures to globally configure document types, then expose layouts and templates with global configurations.
#let documentclass(
  doctype: "bachelor",  // "bachelor" | "master" | "doctor" | "postdoc"，文档类型，默认为本科生 bachelor
  degree: "academic",  // "academic" | "professional"，学位类型，默认为学术型 academic
  nl-cover: false,    // TODO: 是否使用国家图书馆封面，默认关闭
  de-cover: false,    // 是否使用 design-cover 渲染封面，默认关闭
  twoside: false,     // 双面模式，默认关闭。会加入空白页，便于打印
  need2page:true,     // 需要、应为双页的页面
  anonymous: false,   // 盲审模式
  bibliography: none, // 参考文献函数
  fonts: (:),  // 字体，应传入「宋体」、「黑体」、「楷体」、「仿宋」、「等宽」
  info: (:),
) = {
  // 默认参数
  // Default parameters
  fonts = 字体 + fonts
  info = (
    title: ("基于 Typst 的", "重庆理工大学学位论文"),
    title-en: "CQUT Thesis Template for Typst",
    grade: "20XX",
    student-id: "1234567890",
    author: "张三",
    author-en: "Zhang San",
    department: "某学院",
    department-en: "XX Department",
    major: "某专业",
    major-en: "XX Major",
    field: "某方向",
    field-en: "XX Field",
    supervisor: ("李四", "教授"),
    supervisor-en: "Professor Li Si",
    supervisor-ii: (),
    supervisor-ii-en: "",
    submit-date: datetime.today(),
    // 以下为研究生项
    defend-date: datetime.today(),
    confer-date: datetime.today(),
    bottom-date: datetime.today(),
    chairman: "某某某 教授",
    reviewer: ("某某某 教授", "某某某 教授"),
    clc: "O643.12",
    udc: "544.4",
    secret-level: "公开",
    supervisor-contact: "重庆理工大学 重庆市巴南区红光大道59号",
    email: "xyz@smail.cqut.edu.cn",
    school-code: "10284",
    degree: auto,
    degree-en: auto,
  ) + info

  (
    // 将传入参数再导出
    // Exposing the passed parameters
    doctype: doctype,
    degree: degree,
    nl-cover: nl-cover,
    twoside: twoside,
    anonymous: anonymous,
    fonts: fonts,
    info: info,
    // 页面布局
    // Page layout
    doc: (..args) => {
      doc(
        ..args,
        info: info + args.named().at("info", default: (:)),
      )
    },
    preface-counter: (..args) => {
      preface-counter(
        twoside: twoside,
        ..args,
      )
    },
    mainmatter: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        mainmatter(
          twoside: twoside,
          display-header: true,
          info: info,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
        )
      } else {
        mainmatter(
          twoside: twoside,
          // 信息
          // Information
          info: info,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
        )
      }
    },
    mainmatter-end: (..args) => {
      mainmatter-end(
        ..args,
      )
    },
    appendix: (..args) => {
      appendix(
        need2page: need2page,
        ..args,
      )
    },

    // 字体展示页
    // Font display page
    fonts-display-page: (..args) => {
      fonts-display-page(
        need2page: need2page,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    },

    // 封面页，通过 type 分发到不同函数
    // Cover page, distributed to different functions based on type
    cover: (..args) => {
      if de-cover {
        // 如果 de-cover 为 true，使用 design-cover 渲染封面
        // If de-cover is true, use design-cover to render the cover
        design-cover(
          anonymous: anonymous,
          need2page: need2page,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      } else if doctype == "master" or doctype == "doctor" {
        master-cover(
          doctype: doctype,
          degree: degree,
          nl-cover: nl-cover,
          anonymous: anonymous,
          need2page: need2page,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      } else if doctype == "postdoc" {
        panic("postdoc has not yet been implemented.")
      } else {
        bachelor-cover(
          anonymous: anonymous,
          need2page: need2page,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      }
    },

    // 声明页，通过 type 分发到不同函数
    // Declaration page, distributed to different functions based on type
    decl-page: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        master-decl-page(
          anonymous: anonymous,
          need2page: need2page,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
        )
      } else if doctype == "postdoc" {
        panic("postdoc has not yet been implemented.")
      } else {
        bachelor-decl-page(
          anonymous: anonymous,
          need2page: need2page,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      }
    },
    
    // 中文摘要页，通过 type 分发到不同函数
    // Chinese abstract page, distributed to different functions based on type
    abstract: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        master-abstract(
          doctype: doctype,
          degree: degree,
          anonymous: anonymous,
          need2page: need2page,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      } else if doctype == "postdoc" {
        panic("postdoc has not yet been implemented.")
      } else {
        bachelor-abstract(
          anonymous: anonymous,
          need2page: need2page,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      }
    },

    // 英文摘要页，通过 type 分发到不同函数
    // English abstract page, distributed to different functions based on type
    abstract-en: (..args) => {
      if doctype == "master" or doctype == "doctor" {
        master-abstract-en(
          doctype: doctype,
          degree: degree,
          anonymous: anonymous,
          need2page: need2page,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      } else if doctype == "postdoc" {
        panic("postdoc has not yet been implemented.")
      } else {
        bachelor-abstract-en(
          anonymous: anonymous,
          need2page: need2page,
          ..args,
          fonts: fonts + args.named().at("fonts", default: (:)),
          info: info + args.named().at("info", default: (:)),
        )
      }
    },

    // 目录页
    // Table of contents page
    outline-page: (..args) => {
      bachelor-outline-page(
        need2page: need2page,
        info: info,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    },

    // 插图目录页
    // List of figures page
    list-of-figures: (..args) => {
      list-of-figures(
        need2page: need2page,
        info: info,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    },

    // 表格目录页
    // List of tables page
    list-of-tables: (..args) => {
      list-of-tables(
        need2page: need2page,
        info: info,
        ..args,
        fonts: fonts + args.named().at("fonts", default: (:)),
      )
    },

    // 符号表页
    // Notation page
    notation: (..args) => {
      notation(
        need2page: need2page,
        ..args,
      )
    },

    // 参考文献页
    // Bibliography page
    bilingual-bibliography: (..args) => {
      bilingual-bibliography(
        bibliography: bibliography,
        need2page: need2page,
        ..args,
      )
    },

    // 致谢页
    // Acknowledgements page
    acknowledgement: (..args) => {
      acknowledgement(
        anonymous: anonymous,
        need2page: need2page,
        ..args,
      )
    },
  )
}
