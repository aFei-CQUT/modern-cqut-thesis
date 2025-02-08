#import "../utils/indent.typ": indent
#import "../utils/style.typ": 字号, 字体
#import "../utils/custom-cuti.typ": fakebold
#import "../utils/datetime-display.typ": datetime-display

// 本科生声明页
#let bachelor-decl-page(

  // documentclass 传入的参数
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),

  // 其他参数
  stroke-width: 0.5pt,
  info-inset: (x: 0pt, bottom: 0pt),
  info-key-font: "黑体",
  info-value-font: "宋体",
  datetime-display: datetime-display,
) = {

  // 0. 如果需要匿名则短路返回
  if anonymous {
    return
  }

  // 1. 默认参数
  fonts = 字体 + fonts
  info = (
    title: ("基于 Typst 的", "重庆理工大学学位论文"),
    department: "某学院",
    major: "某专业",
    author: "张三",
    student-id: "1234567890",
    sign-date: datetime.today(),
  ) + info

  // 2. 对参数进行处理
  if type(info.title) == str {
    info.title = info.title.split("\n")
  }
  if type(info.sign-date) == datetime {
    info.sign-date = datetime-display(info.sign-date)
  }

  // 3. 辅助函数
  let info-value(key, body, width-1:auto, width-2: 100%) = {
    if type(body) == array and body.len() == 2 and body.at(1) != "" {
      // 处理两行标题
      stack(
        spacing: 0.5em,
        [
          #box(
            width: width-1,
            inset: info-inset,
            stroke: (bottom: stroke-width + black),
            text(
              font: fonts.at(info-value-font, default: "宋体"),
              size: 字号.小三,
              bottom-edge: "descender",
              body.at(0)
            )
          )
        ],
        box(
          width: width-2,
          inset: info-inset,
          stroke: (bottom: stroke-width + black),
          text(
            font: fonts.at(info-value-font, default: "宋体"),
            size: 字号.小三,
            bottom-edge: "descender",
            body.at(1)
          )
        )
      )
    }
    else {
      // 处理单行标题（包括只有一个元素的数组、第二个元素为空字符串的数组）
      box(
        width: width-1,
        inset: info-inset,
        stroke: (bottom: stroke-width + black),
        text(
          font: fonts.at(info-value-font, default: "宋体"),
          size: 字号.小三,
          bottom-edge: "descender",
          if type(body) == array { body.at(0) } else { body }
        )
      )
    }
  }


  // 4. 正式渲染
  pagebreak(weak: true, to: if twoside { "odd" })

  v(10.0pt)

  align(
    center,
    text(
      font: fonts.黑体,
      size: 字号.二号,
      fakebold[重庆理工大学 \ 本科毕业论文（论文）诚信承诺书],
    ),
  )

  v(16.0pt)

  block[
    #set text(font: fonts.宋体, size: 字号.小三)
    #set par(justify: true, first-line-indent: 2em, leading: 1.28em)

    #fakebold[
      #indent 本人为重庆理工大学
        #info-value(
          "department", info.department, width-1: 90pt
        ) 
      学院
        #info-value(
          "major", info.major, width-1: 105pt
        )
      专业的学生。

      // 标题部分：使用 grid 布局
      #let title-prefix = text[#indent 毕业设计（论文）题目为：]
      #grid(
        columns: (auto, 1fr),
        gutter: 0.0em,
        title-prefix,
        info-value(
          "title", 
          info.title, 
          width-1: 100%,
          width-2: 100%
        )
      )

      #h(2em)
      本人郑重承诺：
    ]

    1.该毕业设计（论文）是在指导教师的指导下，查阅相关文献，进行分析研究，独立撰写而成的。

    2.该毕业设计（论文）中有关本人完成的实验数据或调查数据（材料）均是真实的。

    3.该毕业设计（论文）中引用他人已经发表或出版过的研究成果，文中已加特别标注。对本人毕业设计（论文）撰写曾做出过贡献的老师、同学等均在文中作了明确说明并表示衷心感谢。

    4.该毕业设计（论文）在毕业设计（论文）的各种检查、评比中，如经本人所在学院或学校认定有抄袭、剽窃等行为，愿按学校有关规定接受处理，并承担相应法律责任。
  ]

  v(20pt)

  align(left)[
    // 设置
    #set text(font: fonts.宋体, size: 字号.四号)
    // 签名
    毕业设计（论文）作者签名：#box(width: 45pt, info.author)  
    // 间距
    #h(2em)
    // 学号
    学号：#box(width: 85pt, info.student-id)

    // 间距（对齐）
    #v(-1.5em)
    \ #h(8em)
    // 日期
    签字日期：#box(width: 210pt, info.sign-date)
  ]
}
