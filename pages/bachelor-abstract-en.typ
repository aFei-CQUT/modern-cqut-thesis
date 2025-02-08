#import "../utils/custom-cuti.typ": fakebold
#import "../utils/style.typ": 字号, 字体
#import "../utils/indent.typ": fake-par
#import "../utils/double-underline.typ": double-underline
#import "../utils/invisible-heading.typ": invisible-heading

// 本科生英文摘要页
#let bachelor-abstract-en(
  // documentclass 传入的参数
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  // 其他参数
  keywords: (),
  outline-title: "ABSTRACT",
  outlined: false,
  anonymous-info-keys: ("author-en", "supervisor-en", "supervisor-ii-en"),
  leading: 1.28em,
  spacing: 1.38em,
  margin: (
    top: 2.5cm,
    bottom: 2.5cm, 
    left: 2.5cm,
    right: 2cm
  ),
  body,
) = {
  // 1. 默认参数设置
  fonts = 字体 + fonts
  info = (
    title-en: "CQUT Thesis Template for Typst",
    author-en: "Zhang San",
    department-en: "XX Department",
    major-en: "XX Major",
    supervisor-en: "Professor Li Si",
  ) + info

  // 2. 参数处理
  // 2.1 如果标题是字符串，则使用换行符将其分隔为列表
  if type(info.title-en) == str {
    info.title-en = info.title-en.split("\n")
  }

  // 3. 内置辅助函数
  let info-value(key, body) = {
    if (not anonymous or (key not in anonymous-info-keys)) {
      body
    }
  }

  // 4. 页面设置：页眉
  set page(
    margin: margin,
    header-ascent: 1.5cm,
    footer-descent: 1.5cm,
    header: context {
      let header-text = [重庆理工大学毕业设计（论文）]
      let title = info.title.join(" ")
      grid(
        columns: (1fr, 1fr),
        text(font: 字体.宋体, size: 字号.五号, header-text),
        align(right, text(font: 字体.宋体, size: 字号.五号, title))
      )

      v(-0.8em) // 减少页眉和横线之间的间距
      
      line(length: 100%, stroke: 0.5pt)
    }
  )

  // 5. 开始页面渲染
  // 5.1 确保在双面打印时，英文摘要从奇数页开始
  pagebreak(weak: true, to: if twoside { "odd" })

  [
    #set text(font: fonts.楷体, size: 字号.小四)
    #set par(leading: leading, justify: true, spacing: spacing)

    // 5.2 添加不可见标题用于目录生成
    #invisible-heading(level: 1, outlined: outlined, outline-title)

    #v(2pt)

    // 5.3 英文摘要信息
    // THESIS: #info-value("title-en", (("",)+ info.title-en).sum())
    // DEPARTMENT: #info-value("department-en", info.department-en)
    // SPECIALIZATION: #info-value("major-en", info.major-en)
    // UNDERGRADUATE: #info-value("author-en", info.author-en)
    // MENTOR: #info-value("supervisor-en", info.supervisor-en) #(if info.supervisor-ii-en != "" [#h(1em) #info-value("supervisor-ii-en", info.supervisor-ii-en)])

    // 5.4 英文摘要标题
    #align(center)[
      #set text(size: 字号.小二, weight: "bold")
      #v(1em)
      ABSTRACT
    ]

    // 5.5 英文摘要正文
    #body

    #v(1em)

    // 5.6 英文关键词
    #fakebold[KEYWORDS]: #(("",)+ keywords.intersperse("; ")).sum()
  ]

  // 6. 结束页面渲染
  // 6.1 确保在双面打印时，英文摘要后的内容从奇数页开始
  pagebreak(weak: true, to: if twoside { "odd" })
}
