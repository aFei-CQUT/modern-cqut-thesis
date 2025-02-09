#import "@preview/i-figured:0.2.4"
#import "@preview/outrageous:0.1.0"
#import "../utils/invisible-heading.typ": invisible-heading
#import "../utils/style.typ": 字号, 字体


#let list-of-figures(

  // documentclass 传入的参数
  fonts: (:),
  info: (:),

  // 其他参数
  need2page: true,
  title: "插图目录",
  outlined: false,
  title-vspace: 32pt,
  title-text-args: auto,
  separator: "  ",

  // 引用页数的字体，这里用于显示 Times New Roman
  reference-font: auto,
  reference-size: 字号.小四,

  // 字体与字号
  font: auto,
  size: 字号.小四,

  vspace: 14pt,
  fill: auto,
  margin: (
    top: 2.5cm,
    bottom: 2.5cm, 
    left: 2.5cm,
    right: 2cm
  ),
  ..args,

) = {

  // 1. 默认参数处理
  fonts = 字体 + fonts
  if title-text-args == auto {
    title-text-args = (font: fonts.宋体, size: 字号.三号, weight: "bold")
  }
  if reference-font == auto {
    reference-font = fonts.宋体
  }
  if font == auto {
    font = fonts.宋体
  }

  // 2. 开始页面渲染
  pagebreak(weak: true, to: if need2page { "odd" })

  // 设置默认文本样式
  set text(font: reference-font, size: reference-size)

  // 3. 设置页眉
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

      v(-0.8em)
      
      line(length: 100%, stroke: 0.5pt)
    }
  )

  // 4. 渲染标题
  {
    set align(center)
    text(..title-text-args, title)
    invisible-heading(level: 1, outlined: outlined, title)
  }

  v(title-vspace)

  // 5. 自定义目录条目样式
  show outline.entry: outrageous.show-entry.with(
    ..outrageous.presets.typst,
    body-transform: (level, it) => {
      set text(font: font, size: size)
      if it.has("children") and it.children.at(3, default: none) == [#": "] {
        it.children.slice(0, 3).sum() + separator + it.children.slice(4).sum()
      } else {
        it
      }
    },
    vspace: (vspace,),
    fill: (fill,),
  )

  // 6. 生成图表目录
  i-figured.outline(target-kind: image, title: none)
  
  // 7. 结束页面渲染
  pagebreak(weak: true, to: if need2page { "odd" })
  
}
