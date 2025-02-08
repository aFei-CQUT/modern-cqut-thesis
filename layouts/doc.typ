@ -1,45 +1,63 @@
#import "../utils/indent.typ": indent
#import "../utils/style.typ": 字号, 字体

// 文稿设置，可以进行一些像页面边距这类的全局设置
#let doc(
  // documentclass 传入参数
  info: (:),
  // 其他参数
  fallback: false,  // 字体缺失时使用 fallback，不显示豆腐块
  lang: "zh",
  margin: (
    top: 2.5cm,
    bottom: 2.5cm, 
    left: 2.5cm,
    right: 2cm
  ),
  it,
) = {
  // 1.  默认参数
  info = (
    title: ("基于 Typst 的", "重庆理工大学学位论文"),
    author: "张三",
  ) + info

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if type(info.title) == str {
    info.title = info.title.split("\n")
  }

  // 3.  基本的样式设置
  set text(fallback: fallback, lang: lang)
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
  
  // 3.1 行间距
  set par(leading: 1.5em)

  // 4.  PDF 元信息
  set document(
    title: (("",)+ info.title).sum(),
    author: info.author,
  )

  it
}
