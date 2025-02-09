#import "@preview/i-figured:0.2.4"
#import "../utils/custom-numbering.typ": custom-numbering


// 后记，重置 heading 计数器
#let appendix(

  numbering: custom-numbering.with(first-level: "", depth: 4, "1.1 "),

  // figure 计数
  show-figure: i-figured.show-figure.with(numbering: "1.1"),

  // equation 计数
  show-equation: i-figured.show-equation.with(numbering: "(1.1)"),

  // 重置计数
  reset-counter: false,

  // 双面打印
  need2page: true,

  it,
) = {

  // 标题编号
  set heading(numbering: numbering)

  // 重置计数器
  if reset-counter {
    counter(heading).update(0)
  }

  // 设置 figure 的编号
  show figure: show-figure

  // 设置 equation 的编号
  show math.equation.where(block: true): show-equation

  // 确保在双面打印时，从奇数页开始
  pagebreak(weak: true, to: if need2page { "odd" })
  
  it
  
}
