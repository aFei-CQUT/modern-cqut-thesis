#import "@preview/outrageous:0.3.0"
#import "../utils/invisible-heading.typ": invisible-heading
#import "../utils/style.typ": 字号, 字体


// 本科生目录生成
#let bachelor-outline-page(

  // documentclass 传入的参数
  fonts: (:),
  info: (:),
  
  // 其他参数
  need2page: true,
  depth: 4,
  title: "目　　录",
  outlined: false,
  title-vspace: 0pt,
  title-text-args: auto,

  // 引用页数的字体，这里用于显示 Times New Roman
  reference-font: auto,
  reference-size: 字号.小四,

  // 字体与字号
  font: auto,
  size: (字号.四号, 字号.小四),

  // 垂直间距
  vspace: (25pt, 14pt),
  indent: (0pt, 18pt, 28pt),

  // 全都显示点号
  fill: (auto,),

  // 页眉
  margin: (
    top: 2.5cm,
    bottom: 2.5cm, 
    left: 2.5cm,
    right: 2cm
  ),
  ..args,

) = {

  // 1.  默认参数
  fonts = 字体 + fonts
  if (title-text-args == auto) {
    title-text-args = (font: fonts.宋体, size: 字号.三号, weight: "bold")
  }
  // 引用页数的字体，这里用于显示 Times New Roman
  if (reference-font == auto) {
    reference-font = fonts.宋体
  }
  // 字体与字号
  if (font == auto) {
    font = (fonts.黑体, fonts.宋体)
  }

  // 2.  确保在双面打印时，从奇数页开始，也即从偶数页结束
  pagebreak(weak: true, to: if need2page { "odd" })

  // 默认显示的字体
  set text(font: reference-font, size: reference-size)

  // 3.  设置页眉
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

  // 4.  标题设置
  {
    set align(center)
    text(..title-text-args, title)
    // 标记一个不可见的标题用于目录生成
    invisible-heading(level: 1, outlined: outlined, title)
  }

  v(title-vspace)

  // 5.  目录条目样式设置
  show outline.entry: outrageous.show-entry.with(
    // 保留 Typst 基础样式
    ..outrageous.presets.typst,
    body-transform: (level, it) => {
      // 设置字体和字号
      set text(
        font: font.at(calc.min(level, font.len()) - 1),
        size: size.at(calc.min(level, size.len()) - 1),
      )
      // 计算缩进
      let indent-list = indent + range(level - indent.len()).map((it) => indent.last())
      let indent-length = indent-list.slice(0, count: level).sum()
      h(indent-length) + it
    },
    vspace: vspace,
    fill: fill,
    ..args,
  )

  // 6.  显示目录
  outline(title: none, depth: depth)

  // 7. 结束渲染
  pagebreak(weak: true, to: if need2page { "odd" })

}
