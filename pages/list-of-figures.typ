#import "@preview/i-figured:0.2.4"
#import "@preview/outrageous:0.1.0"
#import "../utils/invisible-heading.typ": invisible-heading
#import "../utils/style.typ": 字号, 字体


// 表格目录生成函数
#let list-of-figures(

  // documentclass 传入参数
  need2page:true,          // 需要、应为双页的页面
  fonts: (:),
  // 其他参数
  title: "插图目录",
  outlined: false,
  title-vspace: 32pt,
  title-text-args: auto,
  separator: "  ",  // caption 的分隔符
  font: auto,       // 字体
  size: 字号.小四,   // 字号
  vspace: 14pt,     // 垂直间距
  fill: auto,       // 是否显示点号
  ..args,

) = {

  // 1. 默认参数处理
  fonts = 字体 + fonts
  if title-text-args == auto {
    title-text-args = (font: fonts.宋体, size: 字号.三号, weight: "bold")
  }
  if font == auto {
    font = fonts.宋体
  }

  // 2. 开始页面渲染
  // 确保在双面打印时，从奇数页开始，也即至偶数页结束
  pagebreak(weak: true, to: if need2page { "odd" })

  // 3. 设置默认文本样式
  set text(font: font, size: size)

  // 4. 渲染标题
  {
    set align(center)
    text(..title-text-args, title)
    // 添加不可见标题用于目录生成
    invisible-heading(level: 1, outlined: outlined, title)
  }

  v(title-vspace)

  // 5. 自定义目录条目样式
  show outline.entry: outrageous.show-entry.with(
    ..outrageous.presets.typst,
    body-transform: (level, it) => {
      // 替换分隔符
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
  // 确保在双面打印时，从奇数页开始，也即至偶数页结束
  pagebreak(weak: true, to: if need2page { "odd" })

}
