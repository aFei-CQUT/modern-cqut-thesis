#import "../utils/custom-cuti.typ": fakebold
#import "../utils/style.typ": 字号, 字体
#import "../utils/indent.typ": fake-par
#import "../utils/double-underline.typ": double-underline
#import "../utils/invisible-heading.typ": invisible-heading


// 本科生中文摘要页
#let bachelor-abstract(

  // documentclass 传入的参数
  anonymous: false,
  fonts: (:),
  info: (:),

  // 其他参数
  need2page:true,
  keywords: (),
  outline-title: "中文摘要",
  outlined: false,
  anonymous-info-keys: ("author", "supervisor", "supervisor-ii"),
  leading: 1.28em,
  spacing: 1.28em,
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
    title: ("基于 Typst 的", "重庆理工大学学位论文"),
    author: "张三",
    department: "某学院",
    major: "某专业",
    supervisor: ("李四", "教授"),
  ) + info

  // 2. 参数处理
  // 2.1 如果标题是字符串，则使用换行符将其分隔为列表
  if type(info.title) == str {
    info.title = info.title.split("\n")
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

  // 4.  结束渲染
  pagebreak(weak: true, to: if need2page { "odd" })

  [
    #set text(font: fonts.楷体, size: 字号.小四)
    #set par(leading: leading, justify: true, spacing: spacing)

    // 5.2 添加不可见标题用于目录生成
    #invisible-heading(level: 1, outlined: outlined, outline-title)

    // 5.3 中文摘要信息（注释掉，需要时可取消注释）
    // #fakebold[题目：]#info-value("title", (("",)+ info.title).sum())
    // #fakebold[院系：]#info-value("department", info.department)
    // #fakebold[专业：]#info-value("major", info.major)
    // #fakebold[本科生姓名：]#info-value("author", info.author)
    // #fakebold[指导教师（姓名、职称）：]#info-value("supervisor", info.supervisor.at(0) + info.supervisor.at(1)) #(if info.supervisor-ii != () [#h(1em) #info-value("supervisor-ii", info.supervisor-ii.at(0) + info.supervisor-ii.at(1))])

    // 5.4 中文摘要标题
    #align(center)[
      #set text(size: 字号.小二, weight: "bold")
      #v(1em)
      #fakebold[摘　要]
    ]

    // 5.5 中文摘要正文
    #[
      #set par(first-line-indent: 2em)  // 设置首行缩进
      #fake-par
      #body
    ]

    #v(1em)

    // 5.6 中文关键词
    #fakebold[关键词：]#(("",)+ keywords.intersperse("；")).sum()
  ]

    // 6.  结束渲染
    pagebreak(weak: true, to: if need2page { "odd" })
    
}
